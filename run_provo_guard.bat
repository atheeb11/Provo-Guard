@echo off
echo ==========================================
echo STARTING PROVO GUARD DEV ENVIRONMENT
echo ==========================================

echo Starting Node.js Backend Server in a new window...
start cmd /k "cd guardian_ai_backend && npm start"

echo Starting Flutter Mobile Application in Chrome...
start cmd /k "cd guardian_ai_app && flutter run -d chrome"

echo ==========================================
echo BOTH SERVICES LAUNCHED!
echo ==========================================
pause
