[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)][string]$AgentType
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir 'common.ps1')

$paths = Get-FeaturePaths

if (-not (Test-Path -LiteralPath $paths.IMPL_PLAN -PathType Leaf)) {
  Write-Error "No plan.md found at $($paths.IMPL_PLAN)"
  exit 1
}

# Keep behavior simple for now: delegate to bash implementation if available.
# This preserves the current update logic until a full PowerShell port is needed.
$bash = Join-Path $paths.REPO_ROOT '.saleskit\scripts\bash\update-agent-context.sh'
if (Test-Path -LiteralPath $bash -PathType Leaf) {
  bash $bash $AgentType
  exit $LASTEXITCODE
}

Write-Error "Missing bash fallback script at $bash"
exit 1
