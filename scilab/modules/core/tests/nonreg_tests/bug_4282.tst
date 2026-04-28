//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4282 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4282
//
// <-- Short Description -->
// If scilab is launched from a symbolic link, the current directory (in scilab) is always "SCI" instead of the
// path from which scilab is launched
//

// <-- INTERACTIVE TEST -->
// ln -s <SCI>/bin/scilab /tmp/scilab
// cd /tmp
// ./scilab -nwni -nb
// pwd() should return "/tmp"
