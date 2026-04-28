dnl
dnl Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
dnl
dnl Copyright (C) 2025 - Dassault Systèmes S.E.
dnl
dnl AC_RAPIDJSON
dnl ------------------------------------------------------
dnl Check if RAPIDJSON is usable and working
dnl
AC_DEFUN([AC_RAPIDJSON], [
AC_LANG_PUSH([C++])

save_CPPFLAGS="$CPPFLAGS"

if $WITH_DEVTOOLS; then # Scilab thirparties
    CPPFLAGS="-I$DEVTOOLS_INCDIR"
    AC_CHECK_HEADER([rapidjson/writer.h],
        [RAPIDJSON_CPPFLAGS="$CPPFLAGS"],
        [AC_MSG_ERROR([Cannot find headers (rapidjson/writer.h) of the library RAPIDJSON. Please install the dev package (Debian : rapidjson-dev)])]
    )
else
    AC_CHECK_HEADER([rapidjson/writer.h],
        [RAPIDJSON_CPPFLAGS=],
        [AC_CHECK_HEADER([rapidjson/writer.h],
            [RAPIDJSON_CPPFLAGS=],
            AC_MSG_ERROR([Cannot find headers (rapidjson/writer.h) of the library RAPIDJSON. Please install the dev package (Debian : rapidjson-dev)]))
        ]
    )
fi
CPPFLAGS="$save_CPPFLAGS"

ac_saved_cxxflags=$CXXFLAGS
CXXFLAGS="$CXXFLAGS $RAPIDJSON_CPPFLAGS"

AC_MSG_CHECKING([if RAPIDJSON is at least version 1.1.0])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
#include "rapidjson/writer.h"
], [int test = rapidjson::WriteFlag::kWriteNanAndInfFlag;])],
    AC_MSG_RESULT([yes]),
    AC_MSG_ERROR([Version 1.1.0 of RAPIDJSON expected (at least)]))

AC_MSG_CHECKING([if RAPIDJSON is above version 1.1.0])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
#include "rapidjson/writer.h"
], [int test = rapidjson::WriteFlag::kWriteNanAndInfNullFlag;])],
    [AC_MSG_RESULT([yes]) AC_DEFINE([RAPIDJSON_MASTER], 1, [Using rapidjson master branch])],
    [AC_MSG_WARN([kWriteNanAndInfNullFlag not found])])

CXXFLAGS=$ac_saved_cxxflags

AC_SUBST(RAPIDJSON_CPPFLAGS)
AC_LANG_POP([C++])
])
