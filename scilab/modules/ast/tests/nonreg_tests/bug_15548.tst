// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15548 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15548
//
// <-- Short Description -->
// [%t %t]./[%f %f] crashes Scilab

assert_checkequal([%t %t]./[%f %f],[%inf %inf]);
