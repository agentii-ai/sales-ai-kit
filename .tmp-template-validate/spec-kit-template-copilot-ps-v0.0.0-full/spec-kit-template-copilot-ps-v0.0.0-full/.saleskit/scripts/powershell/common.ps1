Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Get-RepoRoot {
  try {
    $top = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -eq 0 -and $top) { return $top.Trim() }
  } catch {}

  $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
  $repo = (Resolve-Path (Join-Path $scriptDir '..\..\..')).Path
  return $repo
}

function Get-CurrentBranch {
  if ($env:SPECIFY_FEATURE) { return $env:SPECIFY_FEATURE }

  try {
    $b = git rev-parse --abbrev-ref HEAD 2>$null
    if ($LASTEXITCODE -eq 0 -and $b) { return $b.Trim() }
  } catch {}

  return 'main'
}

function Test-HasGit {
  try {
    git rev-parse --show-toplevel 2>$null | Out-Null
    return ($LASTEXITCODE -eq 0)
  } catch {
    return $false
  }
}

function Find-FeatureDirByPrefix {
  param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$true)][string]$BranchName
  )

  $specsDir = Join-Path $RepoRoot 'specs'

  $m = [regex]::Match($BranchName, '^(\d{3})-')
  if (-not $m.Success) {
    return (Join-Path $specsDir $BranchName)
  }

  $prefix = $m.Groups[1].Value
  $pattern = "$prefix-*"

  if (-not (Test-Path $specsDir)) {
    return (Join-Path $specsDir $BranchName)
  }

  $matches = Get-ChildItem -Path $specsDir -Directory -Filter $pattern | Select-Object -ExpandProperty Name

  if (-not $matches -or $matches.Count -eq 0) {
    return (Join-Path $specsDir $BranchName)
  }

  if ($matches.Count -eq 1) {
    return (Join-Path $specsDir $matches[0])
  }

  Write-Error "Multiple spec directories found with prefix '$prefix': $($matches -join ', ')"
  return (Join-Path $specsDir $BranchName)
}

function Get-FeaturePaths {
  $repoRoot = Get-RepoRoot
  $branch = Get-CurrentBranch
  $hasGit = Test-HasGit

  $featureDir = Find-FeatureDirByPrefix -RepoRoot $repoRoot -BranchName $branch

  return [pscustomobject]@{
    REPO_ROOT = $repoRoot
    CURRENT_BRANCH = $branch
    HAS_GIT = $hasGit
    FEATURE_DIR = $featureDir
    FEATURE_SPEC = (Join-Path $featureDir 'spec.md')
    IMPL_PLAN = (Join-Path $featureDir 'plan.md')
    TASKS = (Join-Path $featureDir 'tasks.md')
    RESEARCH = (Join-Path $featureDir 'research.md')
    DATA_MODEL = (Join-Path $featureDir 'data-model.md')
    QUICKSTART = (Join-Path $featureDir 'quickstart.md')
    CONTRACTS_DIR = (Join-Path $featureDir 'contracts')
  }
}

function Assert-FeatureBranch {
  param(
    [Parameter(Mandatory=$true)][string]$Branch,
    [Parameter(Mandatory=$true)][bool]$HasGit
  )

  if (-not $HasGit) {
    Write-Warning "[sales] Git repository not detected; skipped branch validation"
    return
  }

  if ($Branch -notmatch '^\d{3}-') {
    throw "Not on a feature branch. Current branch: $Branch`nFeature branches should be named like: 001-feature-name"
  }
}

function Test-FilePresent {
  param([string]$Path)
  return (Test-Path -LiteralPath $Path -PathType Leaf)
}

function Test-DirPresentNonEmpty {
  param([string]$Path)
  if (-not (Test-Path -LiteralPath $Path -PathType Container)) { return $false }
  return (@(Get-ChildItem -LiteralPath $Path -Force -ErrorAction SilentlyContinue).Count -gt 0)
}
