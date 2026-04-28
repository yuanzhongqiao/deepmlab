dnl
dnl Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
dnl Copyright (C) DIGITEO - 2009 - Bruno JOFRET
dnl
dnl Copyright (C) 2012 - 2016 - Scilab Enterprises
dnl
dnl This file is hereby licensed under the terms of the GNU GPL v2.0,
dnl pursuant to article 5.3.4 of the CeCILL v.2.1.
dnl This file was originally licensed under the terms of the CeCILL v2.1,
dnl and continues to be available under such terms.
dnl For more information, see the COPYING file which you should have received
dnl along with this program.
dnl
dnl libhdf5 is mandatory in Scilab
dnl When we check :
dnl * if the path is provided or that we have to find it ourself
dnl * if it is available
dnl * what are the compilation flags
dnl * what are linking flags
AC_DEFUN([AC_HDF5], [


AC_ARG_WITH(hdf5_include,
        AS_HELP_STRING([--with-hdf5-include=DIR],[Set the path to the HDF5 headers]),
        [with_hdf5_include=$withval],
        [with_hdf5_include='yes']
        )

AC_ARG_WITH(hdf5_library,
        AS_HELP_STRING([--with-hdf5-library=DIR],[Set the path to the HDF5 libraries]),
        [with_hdf5_library=$withval],
        [with_hdf5_library='yes']
        )

save_CFLAGS="$CFLAGS"
save_LIBS="$LIBS"

if test "x$with_hdf5_include" != "xyes"; then
    CFLAGS="-I$with_hdf5_include"
    AC_CHECK_HEADER([hdf5.h],
        [HDF5_CFLAGS="$CFLAGS"],
        [AC_MSG_ERROR([Cannot find headers (hdf5.h) of the library HDF5 in $with_hdf5_include. Please install the dev package])]
    )
else
    HDF5_CFLAGS=""
    if $WITH_DEVTOOLS; then # Scilab thirdparties
        HDF5_CFLAGS="-I$DEVTOOLS_INCDIR -DH5_NO_DEPRECATED_SYMBOLS"
    else
        if test -d /usr/include/hdf5/serial; then # New Debian packaging layout since hdf5-1.8.13
            AC_CHECK_HEADER([hdf5/serial/hdf5.h],
                [HDF5_CFLAGS="-I/usr/include/hdf5/serial"],
                [AC_MSG_ERROR([Cannot find headers (hdf5.h) of the library HDF5. Please install the dev package])])
        else
            AC_CHECK_HEADER([hdf5.h],
                [HDF5_CFLAGS=""],
                [AC_MSG_ERROR([Cannot find headers (hdf5.h) of the library HDF5. Please install the dev package])])
        fi
    fi
fi

# --with-hdf5-library set then check in this dir
if test "x$with_hdf5_library" != "xyes"; then
    HDF5_LIBS="-L$with_hdf5_library -lhdf5 -lhdf5_hl"
    LIBS="$LIBS $HDF5_LIBS"
    AC_CHECK_LIB([hdf5], [H5Fopen],
            [],
            [AC_MSG_ERROR([libhdf5 or libhdf5_hl: library missing. (Cannot find symbol H5Fopen) in $with_hdf5_library. Check if libhdf5 is installed and if the version is correct])],
            [-lz]
            )
else
    if $WITH_DEVTOOLS; then # Scilab thirparties
        HDF5_LIBS="-L$DEVTOOLS_LIBDIR -lhdf5 -lhdf5_hl"
    else
        if test -d /usr/include/hdf5/serial; then # New Debian packaging layout since hdf5-1.8.13
            HDF5_LIBS="-lhdf5_serial -lhdf5_serial_hl"
            LIBS="$LIBS $HDF5_LIBS"
            AC_CHECK_LIB([hdf5_serial], [H5Fopen],
                [],
                [AC_MSG_ERROR([libhdf5_serial or libhdf5_serial_hl: library missing. (Cannot find symbol H5Fopen). Check if libhdf5 is installed and if the version is correct])],
                [-lz]
                )
        else
            HDF5_LIBS="-lhdf5 -lhdf5_hl"
            LIBS="$LIBS $HDF5_LIBS"
            AC_CHECK_LIB([hdf5], [H5Fopen],
                [],
                [AC_MSG_ERROR([libhdf5 or libhdf5_hl: library missing. (Cannot find symbol H5Fopen). Check if libhdf5 is installed and if the version is correct])],
                [-lz]
                )
        fi
    fi
fi

CFLAGS="$CFLAGS $HDF5_CFLAGS"
LIBS="$LIBS $HDF5_LIBS"
AC_CHECK_HEADER([hdf5.h], [], [AC_MSG_ERROR([Check libhdf5 presence and version. See more details in config.log])])

dnl check HD5 version
hdf5_version_ok=no
AC_MSG_CHECKING([if hdf5 version is >= 1.12])
AC_RUN_IFELSE([AC_LANG_PROGRAM([
#include <H5public.h>
#include <stdlib.h>
#include <stdio.h>
],[
#if H5_VERSION_GE(1,12,0) == 0
exit(1);
#endif
])], [hdf5_version_ok=yes], [AC_MSG_ERROR(hdf5 must be >= 1.12)])
AC_MSG_RESULT($hdf5_version_ok)

dnl check if HDF5 is compiled with needed symbols
hdf5_has_needed_symbols=no
AC_MSG_CHECKING([if hdf5 contains needed symbols])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([
#include <H5Apublic.h>
#include <H5Dpublic.h>
#include <H5Epublic.h>
#include <H5Gpublic.h>
#include <H5Lpublic.h>
#include <H5Opublic.h>
#include <H5Rpublic.h>
],[
#define GLUE(a,b) __GLUE(a,b)
#define __GLUE(a,b) a ## b

    typedef void (*fptr_t)(void);
    fptr_t fun;
    
    fun = (fptr_t) H5Acreate2;
    fun = (fptr_t) H5Aiterate2;
    fun = (fptr_t) H5Dcreate2;
    fun = (fptr_t) H5Dopen2;
    fun = (fptr_t) H5Eset_auto2;
    fun = (fptr_t) H5Gcreate2;
    fun = (fptr_t) H5Gopen2;
    fun = (fptr_t) H5Lget_info_by_idx2;
    fun = (fptr_t) H5Lget_info2;
    fun = (fptr_t) H5Literate2;
    fun = (fptr_t) H5Oget_info_by_idx3;
    fun = (fptr_t) H5Oget_info_by_name3;
    fun = (fptr_t) H5Oget_info3;
    fun = (fptr_t) H5Rdereference2;
    fun = (fptr_t) H5Tget_array_dims2;
    fun = (fptr_t) H5Topen2;
])], [hdf5_has_needed_symbols=yes], [AC_MSG_ERROR(hdf5 must be compiled with deprecated symbols for hdf5 > 1.10)])
AC_MSG_RESULT($hdf5_has_needed_symbols)

dnl set symbols version if HDF5 config as set an API_DEFAULT (Debian case)
FORCE_HDF_API="-DH5_USE_112_API=1"

hdf5_has_default_api_set=no
AC_MSG_CHECKING([if hdf5 has expected default API])
m4_define([HDF5_API_VERS_PROGRAM],[AC_LANG_PROGRAM([
#include <H5Apublic.h>
#include <H5Dpublic.h>
#include <H5Epublic.h>
#include <H5Gpublic.h>
#include <H5Lpublic.h>
#include <H5Opublic.h>
#include <H5Rpublic.h>
],[
// https://stackoverflow.com/a/807586
// combine arguments (after expanding arguments)
#define GLUE(a,b) __GLUE(a,b)
#define __GLUE(a,b) a ## b

#define CVERIFY(expr, msg) typedef char GLUE (compiler_verify_, msg) [(expr) ? (+1) : (-1)]
#define COMPILER_VERIFY(exp, id) CVERIFY (exp, GLUE(id ## _, __LINE__))
#define HDF5_VERIFY(fun, ver) COMPILER_VERIFY(fun ## _vers == ver, fun)

HDF5_VERIFY(H5Acreate, 2);
HDF5_VERIFY(H5Aiterate, 2);
HDF5_VERIFY(H5Dcreate, 2);
HDF5_VERIFY(H5Dopen, 2);
HDF5_VERIFY(H5Eset_auto, 2);
HDF5_VERIFY(H5Gcreate, 2);
HDF5_VERIFY(H5Gopen, 2);
HDF5_VERIFY(H5Lget_info_by_idx, 2);
HDF5_VERIFY(H5Lget_info, 2);
HDF5_VERIFY(H5Literate, 2);
HDF5_VERIFY(H5Oget_info_by_idx, 3);
HDF5_VERIFY(H5Oget_info_by_name, 3);
HDF5_VERIFY(H5Oget_info, 3);
HDF5_VERIFY(H5Rdereference, 2);
HDF5_VERIFY(H5Tget_array_dims, 2);
HDF5_VERIFY(H5Topen, 2);

])])
AC_COMPILE_IFELSE([HDF5_API_VERS_PROGRAM], [hdf5_has_default_api_set=yes], [hdf5_has_default_api_set="no"; HDF5_CFLAGS="$HDF5_CFLAGS $FORCE_HDF_API"])
AC_MSG_RESULT($hdf5_has_default_api_set)

if test "x$hdf5_has_default_api_set" != "xyes"; then
AC_MSG_CHECKING([if hdf5 compile with $FORCE_HDF_API])
AC_COMPILE_IFELSE([HDF5_API_VERS_PROGRAM], [AC_MSG_RESULT([yes])], [AC_MSG_ERROR([failed, check config.log])])
fi

CFLAGS="$save_CFLAGS"
LIBS="$save_LIBS"

AC_SUBST(HDF5_LIBS)
AC_SUBST(HDF5_CFLAGS)

AC_DEFINE([WITH_HDF5], [], [With the HDF5 library])

# Gets compilation and library flags
])
