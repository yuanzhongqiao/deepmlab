// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan SIMON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 5508 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5508
//
// <-- Short Description -->
// When loading a xcos project, hdf5 files are stored into /tmp/
// but it should be done in TMPDIR instead.



//xcos('SCI/modules/xcos/demos/bounce.zcos');
// Check that no hdf5 files are present in /tmp



