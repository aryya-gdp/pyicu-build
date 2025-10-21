:: Download and prepare PyICU and ICU4C source code
@echo on

curl -L -o pyicu.zip https://gitlab.pyicu.org/main/pyicu/-/archive/%PYICU_TAG%/pyicu-%PYICU_TAG%.zip
if errorlevel 1 exit /B 1

tar -xf pyicu.zip --strip-components=1
if errorlevel 1 exit /B 1

git apply --check --verbose PyICU.diff
if errorlevel 1 (
  echo Patch check failed. Attempting to apply anyway...
  git apply --verbose --binary PyICU.diff
  if errorlevel 1 (
    echo Patch application failed. Checking if already applied...
    git apply -R --check --verbose PyICU.diff
    if errorlevel 1 (
      echo ERROR: Patch neither applies nor reverses cleanly.
      exit /B 1
    ) else (
      echo Patch appears to be already applied. Continuing...
    )
  )
)

curl -L -o icu4c.zip https://github.com/unicode-org/icu/releases/download/release-%ICU_RELEASE%-%ICU_PLAT%.zip
if errorlevel 1 exit /B 1

tar -xf icu4c.zip
if errorlevel 1 exit /B 1

ren lib%ICU_ARCH%\????????.lib ????????_.lib
if errorlevel 1 exit /B 1

copy /Y /B bin%ICU_ARCH%\icu*.dll py\icu\
if errorlevel 1 exit /B 1
