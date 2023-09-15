pushd "../html" > nul
for %%f in (*.html) do (
  call :MainFile %%f ../%%f
)
for %%f in (posts/*.html) do (
  call :MainFile posts/%%f ../%%f
)
for %%f in (*.tmp) do (
  del %%f
)
popd > nul
exit /b 0

:MainFile
if "%~t2" GTR "%~t1" (
  rem exit /b 0
)
set InDir=%1
set OutDir=%2
set /a Count=0
type nul>head.tmp
type nul>body.tmp
type nul>main.tmp
type nul>footer.tmp
type nul>%OutDir%
for /f "delims=" %%t in (%InDir%) do (
  echo "%%t" | find "include" > nul
  if not ERRORLEVEL 1 (
    set key=%%t
    setlocal enabledelayedexpansion
    set key=!key:^<^!--include =!
    set key=!key:--^>=!
    call :IncludeFile !key!
    endlocal
  ) else (
    set dirFix=%%t
    setlocal enabledelayedexpansion
    set dirFix=!dirFix:../=!
    echo !dirFix!>>%OutDir%
    echo "!dirFix!" | find "<head>" > nul
    if not ERRORLEVEL 1 type head.tmp>>%OutDir%
    echo "!dirFix!" | find "<body>" > nul
    if not ERRORLEVEL 1 type body.tmp>>%OutDir%
    echo "!dirFix!" | find "<main>" > nul
    if not ERRORLEVEL 1 type main.tmp>>%OutDir%
    echo "!dirFix!" | find "<footer>" > nul
    if not ERRORLEVEL 1 type footer.tmp>>%OutDir%
    endlocal
  )
  if exist %%t (set /a Count=Count+1)
  call ../bat/rowCount.bat %Count% %1
)
exit /b 0

:IncludeFile
set /a Count=0
for /f "delims=" %%i in (%1) do (
  echo "%%i" | find "<head>" > nul
  if not ERRORLEVEL 1 (set tag=head) else (
    echo "%%i" | find "</head>" > nul
    if not ERRORLEVEL 1 (set tag=0) else (
      echo "%%i" | find "<body>" > nul
      if not ERRORLEVEL 1 (set tag=body) else (
        echo "%%i" | find "</body>" > nul
        if not ERRORLEVEL 1 (set tag=0) else (
          echo "%%i" | find "<main>" > nul
          if not ERRORLEVEL 1 (set tag=main) else (
            echo "%%i" | find "</main>" > nul
            if not ERRORLEVEL 1 (set tag=0) else (
              echo "%%i" | find "<footer>" > nul
              if not ERRORLEVEL 1 (set tag=footer) else (
                echo "%%i" | find "</footer>" > nul
                if not ERRORLEVEL 1 (set tag=0) else (
                  setlocal enabledelayedexpansion
                  if !tag! == head echo %%i>>head.tmp
                  if !tag! == body echo %%i>>body.tmp
                  if !tag! == main echo %%i>>main.tmp
                  if !tag! == footer echo %%i>>footer.tmp
                  endlocal
                )
              )
            )
          )
        )
      )
    )
  )
  if exist %%i (set /a Count=Count+1)
  call ../bat/rowCount.bat %Count% %1
)
endlocal
exit /b 0
