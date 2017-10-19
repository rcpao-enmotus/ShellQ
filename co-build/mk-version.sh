#!/bin/bash

# Manually modify MAJOR_VERSION, MINOR_VERSION, and BUG_VERSION:
MAJOR_VERSION=0
MINOR_VERSION=0
BUG_VERSION=1

YEAR=`date +%Y`

# http://stackoverflow.com/questions/579196/getting-the-last-revision-number-in-svn
# SVN_REVISION=`svnversion $1 $SVN_REPO_URL_PREFIX/enmotus/en_bootier/trunk  | sed -e 's/[MS]//g' -e 's/^[[:digit:]]*://'`
# SVN_REVISION=`svn info -r 'HEAD' | grep "Last Changed Rev:" | egrep -o "[0-9]+"`
# SVN_REVISION=`svn info | grep "Last Changed Rev:" | egrep -o "[0-9]+"`
SVN_REVISION=`svn info | grep "Revision:" | egrep -o "[0-9]+"`

echo "VERSION_STR = \""$MAJOR_VERSION"."$MINOR_VERSION"."$BUG_VERSION"."$SVN_REVISION"\""


OUT=version.inc
: <<'comment_end'
echo ";$OUT for MASM compatible assemblers, created by mk-version.sh" > $OUT
#echo "BIOS_VERSION_WORD = "$VERSION >> $OUT
echo "MAJOR_VERSION_WORD = "$MAJOR_VERSION >> $OUT
echo "MINOR_VERSION_WORD = "$MINOR_VERSION >> $OUT
echo "BUG_VERSION_WORD = "$BUG_VERSION >> $OUT
echo "SVNREVISION_DWORD = "$SVN_REVISION >> $OUT
echo "VERSION_STR = \""$MAJOR_VERSION"."$MINOR_VERSION"."$BUG_VERSION"."$SVN_REVISION"\"" >> $OUT #untested in JWasm
echo "YEAR_STR = \""$YEAR"\"" >> $OUT
comment_end

OUT=version.ninc
: <<'comment_end'
echo ";$OUT for Netwide Assembler (NASM), created by mk-version.sh" > $OUT
#echo "BIOS_VERSION_WORD equ "$VERSION >> $OUT
echo "MAJOR_VERSION_WORD equ "$MAJOR_VERSION >> $OUT
echo "MINOR_VERSION_WORD equ "$MINOR_VERSION >> $OUT
echo "BUG_VERSION_WORD equ "$BUG_VERSION >> $OUT
echo "SVNREVISION_DWORD equ "$SVN_REVISION >> $OUT
echo "%define VERSION_STR \""$MAJOR_VERSION"."$MINOR_VERSION"."$BUG_VERSION"."$SVN_REVISION"\"" >> $OUT
echo "%define YEAR_STR \"$YEAR\"" >> $OUT
comment_end

OUT=version.h
#: <<'comment_end'
echo "/* $OUT for C, created by mk-version.sh */" > $OUT
echo "#define MAJOR_VERSION_WORD "$MAJOR_VERSION >> $OUT
echo "#define MINOR_VERSION_WORD "$MINOR_VERSION >> $OUT
echo "#define BUG_VERSION_WORD "$BUG_VERSION >> $OUT
echo "#define SVNREVISION_DWORD "$SVN_REVISION >> $OUT
echo "#define VERSION_STR \""$MAJOR_VERSION"."$MINOR_VERSION"."$BUG_VERSION"."$SVN_REVISION"\"" >> $OUT
echo "#define YEAR_STR \""$YEAR"\"" >> $OUT
#comment_end

OUT=version.bat
#: <<'comment_end'
echo "rem $OUT for CMD, created by mk-version.sh" > $OUT
echo "set MAJOR_VERSION_WORD="$MAJOR_VERSION >> $OUT
echo "set MINOR_VERSION_WORD="$MINOR_VERSION >> $OUT
echo "set BUG_VERSION_WORD="$BUG_VERSION >> $OUT
echo "set SVNREVISION_DWORD="$SVN_REVISION >> $OUT
echo "set VERSION_STR=\""$MAJOR_VERSION"."$MINOR_VERSION"."$BUG_VERSION"."$SVN_REVISION"\"" >> $OUT
echo "set YEAR_STR=\""$YEAR"\"" >> $OUT
#comment_end

# export OUT_FILE_NAME="TierDisk-"$MAJOR_VERSION"."$MINOR_VERSION"."$BUG_VERSION"."$SVN_REVISION".efi"


exit


[rcpao@fc16-vm en_bootier]$ svn info
Path: .
URL: SVN_REPO_URL_PREFIX/enmotus/en_bootier/trunk
Repository Root: SVN_REPO_URL_PREFIX/enmotus
Repository UUID: 56464190-ac38-1a4a-b415-73d4af44db19
Revision: 4129
Node Kind: directory
Schedule: normal
Last Changed Author: roger
Last Changed Rev: 4129
Last Changed Date: 2013-11-12 13:43:35 -0800 (Tue, 12 Nov 2013)

[rcpao@fc16-vm en_bootier]$ svn update
At revision 4130.
[rcpao@fc16-vm en_bootier]$ svn info
Path: .
URL: SVN_REPO_URL_PREFIX/enmotus/en_bootier/trunk
Repository Root: SVN_REPO_URL_PREFIX/enmotus
Repository UUID: 56464190-ac38-1a4a-b415-73d4af44db19
Revision: 4130
Node Kind: directory
Schedule: normal
Last Changed Author: roger
Last Changed Rev: 4129
Last Changed Date: 2013-11-12 13:43:35 -0800 (Tue, 12 Nov 2013)
