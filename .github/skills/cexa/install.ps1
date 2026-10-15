<#
.SYNOPSIS
    Installs cexa CLI with UTF-8 console support.

.DESCRIPTION
    - Configures PYTHONIOENCODING=utf-8 at user level (if not already set)
    - Sets it in the current session for immediate effect
    - Installs cexa via uv tool
    - Verifies installation
    - Checks for EXA_API_KEY

.EXAMPLE
    .\install.ps1
#>

$ErrorActionPreference = 'Stop'

Write-Host "Installing cexa with UTF-8 support..." -ForegroundColor Cyan

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

# Install cexa
Write-Host "`nInstalling cexa CLI..." -ForegroundColor Cyan
try {
    uv tool install git+https://github.com/davidw-philips/cexa
    Write-Host "✓ cexa installed successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to install cexa: $_" -ForegroundColor Red
    exit 1
}

# Verify installation
Write-Host "`nVerifying installation..." -ForegroundColor Cyan
try {
    $help = cexa --help 2>&1
    Write-Host "✓ cexa is ready to use" -ForegroundColor Green
    cexa --help | Select-Object -First 5
} catch {
    Write-Host "✗ cexa verification failed: $_" -ForegroundColor Red
    exit 1
}

# Check for API key
Write-Host "`nChecking for EXA_API_KEY..." -ForegroundColor Yellow
if ($env:EXA_API_KEY) {
    Write-Host "✓ EXA_API_KEY is configured" -ForegroundColor Green
} else {
    Write-Host "⚠ EXA_API_KEY not set. Set it with:" -ForegroundColor Yellow
    Write-Host '  $env:EXA_API_KEY="your-api-key"' -ForegroundColor White
}

Write-Host "`n✓ Installation complete!" -ForegroundColor Cyan
Write-Host "Run: cexa --help" -ForegroundColor Cyan
