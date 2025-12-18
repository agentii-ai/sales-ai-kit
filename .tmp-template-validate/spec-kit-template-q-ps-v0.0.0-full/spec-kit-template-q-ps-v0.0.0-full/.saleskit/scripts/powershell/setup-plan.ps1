[CmdletBinding()]
param(
  [switch]$Json
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir 'common.ps1')

$paths = Get-FeaturePaths

try {
  Assert-FeatureBranch -Branch $paths.CURRENT_BRANCH -HasGit ([bool]$paths.HAS_GIT)
} catch {
  Write-Error $_
  exit 1
}

New-Item -ItemType Directory -Force -Path $paths.FEATURE_DIR | Out-Null

$template = Join-Path $paths.REPO_ROOT '.saleskit\templates\plan-template.md'
if (Test-Path -LiteralPath $template -PathType Leaf) {
  Copy-Item -LiteralPath $template -Destination $paths.IMPL_PLAN -Force
  Write-Output "Copied plan template to $($paths.IMPL_PLAN)"
} else {
  Write-Warning "Plan template not found at $template"
  if (-not (Test-Path -LiteralPath $paths.IMPL_PLAN -PathType Leaf)) {
    New-Item -ItemType File -Force -Path $paths.IMPL_PLAN | Out-Null
  }
}

if ($Json) {
  [pscustomobject]@{
    FEATURE_SPEC = $paths.FEATURE_SPEC
    IMPL_PLAN = $paths.IMPL_PLAN
    SPECS_DIR = $paths.FEATURE_DIR
    BRANCH = $paths.CURRENT_BRANCH
    HAS_GIT = [bool]$paths.HAS_GIT
  } | ConvertTo-Json -Compress
} else {
  Write-Output "FEATURE_SPEC: $($paths.FEATURE_SPEC)"
  Write-Output "IMPL_PLAN: $($paths.IMPL_PLAN)"
  Write-Output "SPECS_DIR: $($paths.FEATURE_DIR)"
  Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
  Write-Output "HAS_GIT: $($paths.HAS_GIT)"
}
