<#
.SYNOPSIS
    Installs awskb CLI with UTF-8 console support.

.DESCRIPTION
    - Configures PYTHONIOENCODING=utf-8 at user level (if not already set)
    - Sets it in the current session for immediate effect
    - Installs awskb via uv tool
    - Verifies installation

.EXAMPLE
    .\install.ps1
#>

$ErrorActionPreference = 'Stop'

Write-Host "Installing awskb with UTF-8 support..." -ForegroundColor Cyan

# Configure PYTHONIOENCODING for user level (persistent)
$currentValue = [System.Environment]::GetEnvironmentVariable('PYTHONIOENCODING', 'User')

if (-not $currentValue) {
    Write-Host "Setting PYTHONIOENCODING=utf-8 at user level (persistent)..." -ForegroundColor Yellow
    [System.Environment]::SetEnvironmentVariable('PYTHONIOENCODING', 'utf-8', 'User')
} else {
    Write-Host "PYTHONIOENCODING already set to: $currentValue" -ForegroundColor Green
}

# Set for current session (immediate effect)
$env:PYTHONIOENCODING = 'utf-8'
Write-Host "PYTHONIOENCODING set to utf-8 for current session" -ForegroundColor Green

# Install awskb
Write-Host "`nInstalling awskb CLI..." -ForegroundColor Cyan
try {
    uv tool install git+https://github.com/davidw-philips/awskb
    Write-Host "✓ awskb installed successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to install awskb: $_" -ForegroundColor Red
    exit 1
}

# Verify installation
Write-Host "`nVerifying installation..." -ForegroundColor Cyan
try {
    $help = awskb --help 2>&1
    Write-Host "✓ awskb is ready to use" -ForegroundColor Green
    awskb --help | Select-Object -First 5
} catch {
    Write-Host "✗ awskb verification failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n✓ Installation complete!" -ForegroundColor Cyan
Write-Host "Run: awskb --help" -ForegroundColor Cyan
