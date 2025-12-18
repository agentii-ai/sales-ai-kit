[CmdletBinding()]
param(
  [switch]$Json,
  [string]$ShortName,
  [int]$Number,
  [Parameter(ValueFromRemainingArguments=$true)]
  [string[]]$Args
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Clean-BranchName {
  param([string]$Name)
  $s = $Name.ToLowerInvariant()
  $s = [regex]::Replace($s, '[^a-z0-9]+', '-')
  $s = [regex]::Replace($s, '-+', '-')
  $s = $s.Trim('-')
  return $s
}

function Get-HighestFromSpecs {
  param([string]$SpecsDir)
  if (-not (Test-Path -LiteralPath $SpecsDir -PathType Container)) { return 0 }
  $highest = 0
  Get-ChildItem -LiteralPath $SpecsDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $m = [regex]::Match($_.Name, '^\d+')
    if ($m.Success) {
      $n = [int]$m.Value
      if ($n -gt $highest) { $highest = $n }
    }
  }
  return $highest
}

function Get-HighestFromBranches {
  $highest = 0
  try {
    $branches = git branch -a 2>$null
    if ($LASTEXITCODE -ne 0) { return 0 }
  } catch {
    return 0
  }

  foreach ($line in $branches) {
    $clean = $line.Trim()
    $clean = $clean.TrimStart('*').Trim()
    $clean = [regex]::Replace($clean, '^remotes/[^/]+/', '')

    $m = [regex]::Match($clean, '^(\d{3})-')
    if ($m.Success) {
      $n = [int]$m.Groups[1].Value
      if ($n -gt $highest) { $highest = $n }
    }
  }
  return $highest
}

function Get-NextNumber {
  param([string]$SpecsDir, [bool]$HasGit)

  if ($HasGit) {
    try { git fetch --all --prune 2>$null | Out-Null } catch {}
    $b = Get-HighestFromBranches
    $s = Get-HighestFromSpecs -SpecsDir $SpecsDir
    $max = [Math]::Max($b, $s)
    return ($max + 1)
  }

  $h = Get-HighestFromSpecs -SpecsDir $SpecsDir
  return ($h + 1)
}

$featureDescription = ($Args -join ' ').Trim()
if (-not $featureDescription) {
  Write-Error "Usage: create-new-feature.ps1 [-Json] [-ShortName <name>] [-Number <n>] <feature_description>"
  exit 1
}

$repoRoot = $null
$hasGit = $false
try {
  $repoRoot = (git rev-parse --show-toplevel 2>$null).Trim()
  if ($LASTEXITCODE -eq 0 -and $repoRoot) { $hasGit = $true }
} catch {}

if (-not $repoRoot) {
  $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
  $repoRoot = (Resolve-Path (Join-Path $scriptDir '..\..\..')).Path
}

Set-Location -LiteralPath $repoRoot

$specsDir = Join-Path $repoRoot 'specs'
New-Item -ItemType Directory -Force -Path $specsDir | Out-Null

$branchSuffix = if ($ShortName) { Clean-BranchName $ShortName } else { Clean-BranchName $featureDescription }

$branchNumber = if ($PSBoundParameters.ContainsKey('Number') -and $Number -gt 0) { $Number } else { Get-NextNumber -SpecsDir $specsDir -HasGit $hasGit }

$featureNum = '{0:D3}' -f $branchNumber
$branchName = "$featureNum-$branchSuffix"

$maxLen = 244
if ($branchName.Length -gt $maxLen) {
  $maxSuffix = $maxLen - 4
  $truncatedSuffix = $branchSuffix.Substring(0, [Math]::Min($branchSuffix.Length, $maxSuffix)).TrimEnd('-')
  $branchName = "$featureNum-$truncatedSuffix"
  Write-Warning "[sales] Branch name exceeded GitHub's 244-byte limit; truncated"
}

if ($hasGit) {
  git checkout -b $branchName | Out-Null
} else {
  Write-Warning "[sales] Git repository not detected; skipped branch creation for $branchName"
}

$featureDir = Join-Path $specsDir $branchName
New-Item -ItemType Directory -Force -Path $featureDir | Out-Null

$template = Join-Path $repoRoot '.saleskit\templates\spec-template.md'
$specFile = Join-Path $featureDir 'spec.md'
if (Test-Path -LiteralPath $template -PathType Leaf) {
  Copy-Item -LiteralPath $template -Destination $specFile -Force
} else {
  if (-not (Test-Path -LiteralPath $specFile -PathType Leaf)) {
    New-Item -ItemType File -Force -Path $specFile | Out-Null
  }
}

$env:SPECIFY_FEATURE = $branchName

if ($Json) {
  [pscustomobject]@{
    BRANCH_NAME = $branchName
    SPEC_FILE = $specFile
    FEATURE_NUM = $featureNum
  } | ConvertTo-Json -Compress
} else {
  Write-Output "BRANCH_NAME: $branchName"
  Write-Output "SPEC_FILE: $specFile"
  Write-Output "FEATURE_NUM: $featureNum"
  Write-Output "SPECIFY_FEATURE environment variable set to: $branchName"
}
