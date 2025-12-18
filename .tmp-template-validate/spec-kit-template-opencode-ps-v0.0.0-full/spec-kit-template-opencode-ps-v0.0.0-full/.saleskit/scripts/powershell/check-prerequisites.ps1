[CmdletBinding()]
param(
  [switch]$Json,
  [switch]$RequireTasks,
  [switch]$IncludeTasks,
  [switch]$PathsOnly
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

if ($PathsOnly) {
  if ($Json) {
    $out = [pscustomobject]@{
      REPO_ROOT = $paths.REPO_ROOT
      BRANCH = $paths.CURRENT_BRANCH
      FEATURE_DIR = $paths.FEATURE_DIR
      FEATURE_SPEC = $paths.FEATURE_SPEC
      IMPL_PLAN = $paths.IMPL_PLAN
      TASKS = $paths.TASKS
    }
    $out | ConvertTo-Json -Compress
  } else {
    Write-Output "REPO_ROOT: $($paths.REPO_ROOT)"
    Write-Output "BRANCH: $($paths.CURRENT_BRANCH)"
    Write-Output "FEATURE_DIR: $($paths.FEATURE_DIR)"
    Write-Output "FEATURE_SPEC: $($paths.FEATURE_SPEC)"
    Write-Output "IMPL_PLAN: $($paths.IMPL_PLAN)"
    Write-Output "TASKS: $($paths.TASKS)"
  }
  exit 0
}

if (-not (Test-Path -LiteralPath $paths.FEATURE_DIR -PathType Container)) {
  Write-Error "Feature directory not found: $($paths.FEATURE_DIR)`nRun /saleskit.specify first to create the feature structure."
  exit 1
}

if (-not (Test-FilePresent -Path $paths.IMPL_PLAN)) {
  Write-Error "plan.md not found in $($paths.FEATURE_DIR)`nRun /saleskit.plan first to create the implementation plan."
  exit 1
}

if ($RequireTasks -and -not (Test-FilePresent -Path $paths.TASKS)) {
  Write-Error "tasks.md not found in $($paths.FEATURE_DIR)`nRun /saleskit.tasks first to create the task list."
  exit 1
}

$docs = @()
if (Test-FilePresent -Path $paths.RESEARCH) { $docs += 'research.md' }
if (Test-FilePresent -Path $paths.DATA_MODEL) { $docs += 'data-model.md' }
if (Test-DirPresentNonEmpty -Path $paths.CONTRACTS_DIR) { $docs += 'contracts/' }
if (Test-FilePresent -Path $paths.QUICKSTART) { $docs += 'quickstart.md' }
if ($IncludeTasks -and (Test-FilePresent -Path $paths.TASKS)) { $docs += 'tasks.md' }

if ($Json) {
  [pscustomobject]@{
    FEATURE_DIR = $paths.FEATURE_DIR
    AVAILABLE_DOCS = $docs
  } | ConvertTo-Json -Compress
} else {
  Write-Output "FEATURE_DIR:$($paths.FEATURE_DIR)"
  Write-Output "AVAILABLE_DOCS:"

  $candidates = @(
    @{Path=$paths.RESEARCH; Label='research.md'; Type='file'}
    @{Path=$paths.DATA_MODEL; Label='data-model.md'; Type='file'}
    @{Path=$paths.CONTRACTS_DIR; Label='contracts/'; Type='dir'}
    @{Path=$paths.QUICKSTART; Label='quickstart.md'; Type='file'}
  )

  if ($IncludeTasks) {
    $candidates += @{Path=$paths.TASKS; Label='tasks.md'; Type='file'}
  }

  foreach ($c in $candidates) {
    $ok = $false
    if ($c.Type -eq 'file') { $ok = Test-FilePresent -Path $c.Path }
    if ($c.Type -eq 'dir') { $ok = Test-DirPresentNonEmpty -Path $c.Path }

    if ($ok) { Write-Output "  ✓ $($c.Label)" } else { Write-Output "  ✗ $($c.Label)" }
  }
}
