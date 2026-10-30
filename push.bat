@echo off
set "PATH=%PATH%;D:\Git\cmd"
cd /d "D:\blockchain-todo"
echo ===================================================
echo Pushing Chain Tasks to GitHub...
echo Repository: https://github.com/mehreen05-png/chain-tasks-
echo ===================================================
echo.
echo If GitHub Credential Manager pops up, please sign in or authorize in your browser.
echo.
git push -u origin main
echo.
if %ERRORLEVEL% EQU 0 (
    echo ===================================================
    echo SUCCESS! Your code has been pushed to GitHub.
    echo Next: Go to https://github.com/mehreen05-png/chain-tasks-/settings/pages
    echo to verify or activate GitHub Pages!
    echo ===================================================
) else (
    echo ===================================================
    echo Push encountered an error. If authentication failed,
    echo make sure you sign in to your GitHub account mehreen05-png.
    echo ===================================================
)
echo.
pause
