# Stop any existing process occupying port 8080
$portProc = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -First 1
if ($portProc) {
    Stop-Process -Id $portProc -Force -ErrorAction SilentlyContinue
}

$scriptDir = $PSScriptRoot
$backendDir = Join-Path $scriptDir "guardian_ai_backend"
if (-not (Test-Path $backendDir)) {
    $backendDir = Join-Path $scriptDir "provo-guard-main/guardian_ai_backend"
}

$frontendDir = Join-Path $scriptDir "guardian_ai_app"
if (-not (Test-Path $frontendDir)) {
    $frontendDir = Join-Path $scriptDir "provo-guard-main/guardian_ai_app"
}

# Start Backend in a new window
Write-Host "Starting Node.js Backend Server..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$backendDir'; npm start"

# Start Frontend in a new window
Write-Host "Starting Flutter Mobile Application in Chrome..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$frontendDir'; flutter run -d chrome"
