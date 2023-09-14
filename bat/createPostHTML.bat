@echo off
pushd "../html" > nul
for %%f in (posts/*.txt) do call :MainFile posts/%%f
for %%f in (*.tmp) do del %%f
popd > nul
exit /b 0

:MainFile

call :PostFile %1

set html=%~n1.html
echo %html%
type nul>%html%
for /f "delims=" %%t in (library/postBase.html) do (
    set row=%%t
    setlocal enabledelayedexpansion
    echo !row!>>%html%
    echo !row!
    echo "!row!" | find "<main>" > nul
    if not ERRORLEVEL 1 type main.tmp>>%html%
    endlocal
)
echo;
exit /b 0

:PostFile
echo %1
type nul>main.tmp
echo ^<br^>^<br^>>>main.tmp
for /f "delims=" %%t in (%1) do (
    set row=    ^<p^>%%t^<br^>^</p^>
    setlocal enabledelayedexpansion
    echo !row!
    echo !row!>>main.tmp
    endlocal
)
echo ^<br^>^<br^>>>main.tmp
echo;
exit /b 0
