# ShellQ
ShellQ - UDK2017 UEFI Shell with a more quiet transition to startup.nsh

Copy Shell.{c,uni} overwriting the files in https://github.com/tianocore/edk2/tree/UDK2017/ShellPkg/Application/Shell/

build -b DEBUG -t VS2012x86 -a X64 -p ShellPkg/ShellPkg.dsc
