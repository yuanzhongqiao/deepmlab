/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2009 - DIGITEO - Allan CORNET
*
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
*
*/
/*--------------------------------------------------------------------------*/
#ifndef __COPYFILE_H__
#define __COPYFILE_H__

#include <wchar.h>
#include "dynlib_fileio.h"

// copyfile options can be used to mimic Unix "cp" command line options, recursive is always set
enum CopyFileOptions {
    // copy links as links on Linux, copy file content on Windows
    COPYFILE_OS_DEFAULT = 1,
    // copy symbolic links
    COPYFILE_PRESERVE,
    // copy file content
    COPYFILE_RESOLVE,
};

/**
* copy a file
* @param[in] destination filename
* @param[in] source filename
* @return error number
*/
FILEIO_IMPEXP int CopyFileFunction(wchar_t *DestinationFilename, wchar_t *SourceFilename, int CopyFileOptions);

/**
* copy a directory
* @param[in] destination directory
* @param[in] source directory
* @return error number
*/
FILEIO_IMPEXP int CopyDirectoryFunction(wchar_t *DestinationDirectory, wchar_t *SourceDirectory, int CopyFileOptions);

#endif /* __COPYFILE_H__ */
/*--------------------------------------------------------------------------*/
