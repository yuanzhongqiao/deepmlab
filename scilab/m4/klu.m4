dnl
dnl Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
dnl Copyright (C) INRIA - 2008 - Sylvestre Ledru
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
dnl KLU detection
dnl ------------------------------------------------------
dnl Check if KLU is usable and working
dnl
AC_DEFUN([AC_KLU], [

BLAS_LIBS="$1"

KLU_OK=no
SUITESPARSE=no

AC_ARG_WITH(klu_library,
		AS_HELP_STRING([--with-klu-library=DIR],[Set the path to the KLU libraries]),
		[with_klu_library=$withval],
		[with_klu_library='yes']
		)

AC_ARG_WITH(klu_include,
		AS_HELP_STRING([--with-klu-include=DIR],[Set the path to the KLU headers]),
		[with_klu_include=$withval],
		[with_klu_include='yes']
		)

# Include provided... check if you set it as -I/path/ if it can find the header
if test "x$with_klu_include" != "xyes"; then
	save_CFLAGS="$CFLAGS"
	CFLAGS="-I$with_klu_include"
	AC_CHECK_HEADER([suitesparse/klu.h],
	[KLU_CFLAGS="$CFLAGS"; SUITESPARSE=yes],
	[AC_CHECK_HEADER(
				[klu.h],
				[KLU_CFLAGS="$CFLAGS"; SUITESPARSE=no],
				[AC_MSG_ERROR([Cannot find headers (klu.h) of the library KLU. Please install the dev package (Debian : libsuitesparse-dev)])
	])
	])
	CFLAGS="$save_CFLAGS"
fi

# Look in the default paths
if test "x$KLU_INCLUDE" = "x" ; then
    if $WITH_DEVTOOLS; then # Scilab thirparties
        KLU_CFLAGS="-I$DEVTOOLS_INCDIR"
    else
        AC_CHECK_HEADER([suitesparse/klu.h],
            [SUITESPARSE=yes],
            [AC_CHECK_HEADER(
                [klu.h],
                [SUITESPARSE=no],
                [AC_MSG_ERROR([Cannot find headers (klu.h) of the library KLU. Please install the dev package (Debian : libsuitesparse-dev)])
                ])
            ])
    fi
fi

# --with-klu-library set then check in this dir
if test "x$with_klu_library" != "xyes"; then
	AC_MSG_CHECKING([for klu_l_solve in $with_klu_library])
	save_LIBS="$LIBS"
	LIBS="$BLAS_LIBS -L$with_klu_library -lm $LIBS"
	# We need -lm because sometimes (ubuntu 7.10 for example) does not link libamd against lib math

	AC_CHECK_LIB([klu], [klu_l_solve],
			[KLU_LIBS="-L$with_klu_library -lklu $KLU_LIBS"; KLU_OK=yes],
            [AC_MSG_ERROR([libklu : Library missing. (Cannot find klu_l_solve). Check if libklu is installed and if the version is correct (also called lib suitesparse)])]
			)

#	AC_TRY_LINK_FUNC(klu_l_solve, [KLU_OK=yes; BLAS_TYPE="Using BLAS_LIBS environment variable"], [KLU_LIBS=""])
	AC_MSG_RESULT($KLU_OK)
	LIBS="$save_LIBS"
fi

# check in the default path
if test $KLU_OK = no; then
    if $WITH_DEVTOOLS; then # Scilab thirparties
        KLU_LIBS="-L$DEVTOOLS_LIBDIR -lklu -lamd"
    else
        save_LIBS="$LIBS"
        LIBS="$BLAS_LIBS $LIBS -lm" # libamd* is mandatory to link klu
        # We need -lm because sometimes (ubuntu 7.10 for example) does not link libamd against lib math

        AC_CHECK_LIB([amd], [amd_info],
            [KLU_LIBS="-lamd"],
            [AC_MSG_ERROR([libamd: Library missing (Cannot find symbol amd_info). Check if libamd (sparse matrix minimum degree ordering) is installed and if the version is correct])]
            )
        LIBS="$KLU_LIB $LIBS"
        AC_CHECK_LIB([klu], [klu_l_solve],
            [KLU_LIBS="-lklu $KLU_LIBS"; KLU_OK=yes],
            [AC_MSG_ERROR([libklu: Library missing. (Cannot find symbol klu_l_solve). Check if libklu is installed and if the version is correct (also called lib suitesparse)])]
            )
        LIBS="$save_LIBS"
    fi
fi

AC_SUBST(KLU_LIBS)
AC_SUBST(KLU_CFLAGS)
if test $SUITESPARSE = yes; then
   AC_DEFINE_UNQUOTED([KLU_SUITESPARSE],[] , [If it is KLU/Suitesparse or KLU standalone])
fi

AC_DEFINE([WITH_KLU], [], [With the KLU library])

])
