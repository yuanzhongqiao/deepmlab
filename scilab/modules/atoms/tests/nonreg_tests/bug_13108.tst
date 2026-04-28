// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- TEST WITH ATOMS -->
//
// <-- Non-regression test for bug 13108 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13108
//
// <-- Short Description -->
// The time between two updates can now be configured thanks to atomsSetConfig("updateTime", time)

// Set Atoms update time to the default value
atomsSetConfig("updateTime", "30");

assert_checkequal(strtod(atomsGetConfig("updateTime")), 30);
