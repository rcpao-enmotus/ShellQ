@echo on

rem edk2_git_bld/mk-application.bat -- UEFI UDK2017 application
rem [mk-application.bat] Copyright (C) 2016-2017  Enmotus, Inc.  All rights reserved.

rem http://www.enmotus.com
rem 65 Enterprise
rem Aliso Viejo, CA 92656
rem Phone: 949.330.6220
rem Info@enmotus.com

rem This source code is the intellectual property of Enmotus, Inc.
rem It is only available under a non-disclosure agreement (NDA).

rem Roger C. Pao <rcpao.enmotus+TierDiskEfi@gmail.com>


set PROJECTNAME=ShellQ


set SVNENVBAT=%homepath%\Documents\svn_env.bat
if exist %SVNENVBAT% call %SVNENVBAT%

rem \\ROGER\C:\UDK2014.IHV\MdeModulePkg\Universal\Disk\PartitionDxe\co-build\mk-build-dbg.bat
rem echo %SVN_REPO_URL_PREFIX%/enmotus/trunk/en_bootefi/branches/PartitionDxeDbg/co-build/mk-build-dbg.bat
svn info mk-application.bat | grep URL:

set

set REV=%1
if %REV%nul==nul set REV=%GOT_REVISION%
if %REV%nul==nul set REV=head
echo REV=%REV%


if exist signenv.bat goto signenv_local
  if exist wintools\signenv.bat goto skip_co_wintools
    rem svn co -r %REV% %SVN_REPO_URL_PREFIX%/enmotus/en_win_tier/wintools %SVN_CREDENTIALS_ARGS%
    svn co -r %REV% %SVN_REPO_URL_PREFIX%/enmotus/trunk/en_win_tier/wintools %SVN_CREDENTIALS_ARGS%
:skip_co_wintools
  call wintools\signenv.bat
  goto signenv_done
:signenv_local
  call signenv.bat
  rem goto signenv_done
:signenv_done

set signtooldir="c:\Program Files (x86)\Windows Kits\8.0\bin\x64"


if exist mk-version.bat call mk-version.bat
if exist version.bat call version.bat
echo SVNREVISION_DWORD = %SVNREVISION_DWORD%
echo VERSION_STR = %VERSION_STR%
rem copy version.* ..


set DSTDIR=%EN_UEFI_DIR%\edk2_git\ShellPkg\Application\Shell
copy version.h %DSTDIR%\
copy ..\* %DSTDIR%\


rem PartitionDxeDbg only uses pr-cfg-normal.h as pr-cfg.h.
pushd ..
goto skip_pr_cfg
rem fc returns: 0 = files are identical; -1 syntax error (2 files not specified); 1 miscompare; 2 one or more files are missing
rem "if errorlevel #" returns TRUE if the return code is equal to or greater than #.

rem pr-cfg-silent.h = silent
rem fc pr-cfg-silent.h pr-cfg.h > nul 2>&1
rem if not errorlevel 1 goto skip_pr_cfg
rem   copy pr-cfg-silent.h pr-cfg.h

rem pr-cfg-normal.h = normal
fc pr-cfg-normal.h pr-cfg.h > nul 2>&1
if not errorlevel 1 goto skip_pr_cfg
  copy pr-cfg-normal.h pr-cfg.h

  touch pr-cfg.h

:skip_pr_cfg
popd


if %EDK_TOOLS_PATH%nul==nul call ..\..\edk2_git\edksetup.bat

 goto skip_NT32PKGDSC
set NT32PKGDSC=Nt32Pkg.dsc
rem set NT32PKGDSC=Nt32Pkg-edk2_git_bld.dsc
if "%NT32PKGDSC%"=="Nt32Pkg.dsc" goto skip_NT32PKGDSC
  dir %NT32PKGDSC%
  dir ..\..\edk2_git\Nt32Pkg
  copy %NT32PKGDSC% ..\..\edk2_git\Nt32Pkg\
  diff ..\..\edk2_git\Nt32Pkg\Nt32Pkg.dsc ..\..\edk2_git\Nt32Pkg\%NT32PKGDSC%
:skip_NT32PKGDSC

rem build.exe can only handle one .inf file in the sources directory
if exist setup.inf del setup.inf
dir *.inf

rem WARNING: -D does not pass from build.exe to cl.exe command line arguments
rem          so we modify pr-cfg.h above.
rem set BLD_ARGS=-D DEFAULT_VERBOSE_LEVEL=2
rem set BLD_TARGET=RELEASE
set BLD_TARGET=DEBUG
set BLD_TOOL_CHAIN_TAG=VS2012x86
rem [ WARNING: blklog in UDK2017 works with VS2012x86 but not VS2015x86! ] set BLD_TOOL_CHAIN_TAG=VS2015x86
rem set BLD_TARGET_ARCH=X64
rem set BLD_PLATFORM=MdeModulePkg/MdeModulePkg.dsc 
rem set BLD_TARGET_ARCH=IA32
set BLD_TARGET_ARCH=X64
rem set BLD_PLATFORM=Nt32Pkg/Nt32Pkg.dsc
rem set BLD_PLATFORM=Nt32Pkg/%NT32PKGDSC%
rem set BLD_PLATFORM=OvmfPkg/OvmfPkgX64.dsc
set BLD_PLATFORM=ShellPkg/ShellPkg.dsc
rem set BLD_PLATFORM=../%PROJECTNAME%/co-build/application-parent-dir.dsc
set BLD_ARGS=-b %BLD_TARGET% -t %BLD_TOOL_CHAIN_TAG% -a %BLD_TARGET_ARCH% -p %BLD_PLATFORM%
build.exe %BLD_ARGS% %2
rem build.exe %BLD_ARGS% -D SOURCE_DEBUG_ENABLE


                             set EN_UEFI_DIR=C:\Users\%USERNAME%\Documents\job\enmotus.com\en_uefi
if not exist "%EN_UEFI_DIR%" set EN_UEFI_DIR=C:\Users\%USERNAME%\Documents\job\enmotus.com
if not exist "%EN_UEFI_DIR%" set EN_UEFI_DIR=C:\Users\%USERNAME%\Documents\en_uefi
if not exist "%EN_UEFI_DIR%" set EN_UEFI_DIR=C:\Users\%USERNAME%\Documents


rem set SRCDIR=%EN_UEFI_DIR%\edk2_git\Build\AppPkg\DEBUG_%BLD_TOOL_CHAIN_TAG%\X64
rem set SRCDIR=%EN_UEFI_DIR%\edk2_git\Build\OvmfX64\DEBUG_%BLD_TOOL_CHAIN_TAG%\FV
    set SRCDIR=%EN_UEFI_DIR%\edk2_git\Build\Shell\DEBUG_%BLD_TOOL_CHAIN_TAG%\X64\ShellPkg\Application\Shell\Shell\DEBUG
set DSTDIR=%EN_UEFI_DIR%\ovmf-run\hda-contents

rem dir %SRCDIR%\*.efi
dir %SRCDIR%\Shell.efi
dir %DSTDIR%

copy %SRCDIR%\Shell.efi %DSTDIR%\%PROJECTNAME%.efi
dir %DSTDIR%\%PROJECTNAME%.efi


set DSTDIR=\\10.3.171.5\share\Enmotus\UEFI\en_bootefi\UefiShell\shell-quiet
copy %SRCDIR%\Shell.efi %DSTDIR%\%PROJECTNAME%.efi
dir %DSTDIR%\%PROJECTNAME%.efi


:Exit
echo mk-application.bat exiting