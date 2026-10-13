<#
.SYNOPSIS
    Installs agent skills locally (cwd) or globally (~/...).

.DESCRIPTION
    Copies skill bundles for GitHub Copilot, Claude Code, OpenAI Codex, or universal agents
    to either the current working directory or the user's profile directory.
    Supports local repo execution OR remote execution via Invoke-RestMethod / irm:
      & ([scriptblock]::Create((irm https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.ps1))) global all

.PARAMETER Scope
    'cwd' or 'global'.
    - cwd: Copies into current working directory (e.g., .\.github\skills, .\.claude\skills, etc.)
    - global: Copies into user profile directory (e.g., ~\.copilot\skills, ~\.claude\skills, etc.)

.PARAMETER Targets
    One or more targets: 'copilot', 'claude', 'codex', 'agents', or 'all'.

.EXAMPLE
    .\install-skills.ps1 cwd all
.EXAMPLE
    & ([scriptblock]::Create((irm https://raw.githubusercontent.com/davidw-philips/skills/main/install-skills.ps1))) global all
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('cwd', 'global', IgnoreCase = $true)]
    [string]$Scope,

    [Parameter(Mandatory = $true, Position = 1, ValueFromRemainingArguments = $true)]
    [string[]]$Targets
)

$ErrorActionPreference = 'Stop'

# Determine source location (local script directory vs remote download)
$ScriptDir = if ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} else {
    $null
}

$TempDir = $null

try {
    if (-not $ScriptDir -or -not (Test-Path -Path (Join-Path $ScriptDir ".github\skills"))) {
        Write-Host "Downloading skill repository archive..." -ForegroundColor Yellow
        $TempZip = Join-Path ([System.IO.Path]::GetTempPath()) "skills-main-$([System.Guid]::NewGuid()).zip"
        $TempDir = Join-Path ([System.IO.Path]::GetTempPath()) "skills-main-$([System.Guid]::NewGuid())"
        
        Invoke-WebRequest -Uri "https://github.com/davidw-philips/skills/archive/refs/heads/main.zip" -OutFile $TempZip
        Expand-Archive -Path $TempZip -DestinationPath $TempDir -Force
        Remove-Item -Path $TempZip -Force -ErrorAction SilentlyContinue
        
        $SourceBase = Join-Path $TempDir "skills-main"
    } else {
        $SourceBase = $ScriptDir
    }

    # Normalize targets
    $normalizedTargets = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($t in $Targets) {
        if ($t -eq 'all') {
            [void]$normalizedTargets.Add('copilot')
            [void]$normalizedTargets.Add('claude')
            [void]$normalizedTargets.Add('codex')
            [void]$normalizedTargets.Add('agents')
        } else {
            [void]$normalizedTargets.Add($t)
        }
    }

    function Install-SkillDirectory {
        param (
            [string]$TargetName,
            [string]$SourceDir,
            [string]$DestDir
        )

        if (-not (Test-Path -Path $SourceDir)) {
            Write-Warning "Source directory not found: $SourceDir"
            return
        }

        Write-Host "Installing $TargetName skills -> $DestDir"
        if (-not (Test-Path -Path $DestDir)) {
            New-Item -ItemType Directory -Path $DestDir -Force | Out-Null
        }

        Copy-Item -Path "$SourceDir\*" -Destination $DestDir -Recurse -Force
        Write-Host "✓ Installed $TargetName skills successfully." -ForegroundColor Green
    }

    $HomeDir = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)
    $CurrentDir = Get-Location

    foreach ($target in $normalizedTargets) {
        switch ($target.ToLowerInvariant()) {
            'copilot' {
                $src = Join-Path $SourceBase ".github\skills"
                $dest = if ($Scope.ToLowerInvariant() -eq 'global') {
                    Join-Path $HomeDir ".copilot\skills"
                } else {
                    Join-Path $CurrentDir ".github\skills"
                }
                Install-SkillDirectory -TargetName "GitHub Copilot" -SourceDir $src -DestDir $dest
            }
            'claude' {
                $src = Join-Path $SourceBase ".claude\skills"
                $dest = if ($Scope.ToLowerInvariant() -eq 'global') {
                    Join-Path $HomeDir ".claude\skills"
                } else {
                    Join-Path $CurrentDir ".claude\skills"
                }
                Install-SkillDirectory -TargetName "Claude Code" -SourceDir $src -DestDir $dest
            }
            'codex' {
                $src = Join-Path $SourceBase ".codex\skills"
                $dest = if ($Scope.ToLowerInvariant() -eq 'global') {
                    Join-Path $HomeDir ".codex\skills"
                } else {
                    Join-Path $CurrentDir ".codex\skills"
                }
                Install-SkillDirectory -TargetName "OpenAI Codex" -SourceDir $src -DestDir $dest
            }
            'agents' {
                $src = Join-Path $SourceBase ".agents\skills"
                $dest = if ($Scope.ToLowerInvariant() -eq 'global') {
                    Join-Path $HomeDir ".agents\skills"
                } else {
                    Join-Path $CurrentDir ".agents\skills"
                }
                Install-SkillDirectory -TargetName "Universal Agents" -SourceDir $src -DestDir $dest
            }
            Default {
                Write-Warning "Unrecognized target '$target'. Supported: copilot, claude, codex, agents, all"
            }
        }
    }

    Write-Host "`nInstallation complete!" -ForegroundColor Cyan
}
finally {
    if ($TempDir -and (Test-Path -Path $TempDir)) {
        Remove-Item -Path $TempDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
