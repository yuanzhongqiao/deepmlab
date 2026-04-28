//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 6874 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6874
//
// <-- Short Description -->
// exit(23) kills caller app when we do :
// sendScilabJob("exit(23)")
// example scilab called by excel
// sendScilabJob("exit(23)") kills excel with exit code 23
// now we do only a quit in this case
