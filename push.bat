@echo off
set "PATH=%PATH%;D:\Git\cmd"
cd /d "D:\blockchain-todo"
echo ===================================================
echo Pushing Chain Tasks to GitHub...
echo Repository: https://github.com/mehreen05-png/chain-tasks-
echo ===================================================
echo.
git push -u origin main
echo.
pause
