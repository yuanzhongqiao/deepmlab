// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 6891 -->
//
// <-- CLI SHELL MODE -->
//
// <-- ENGLISH IMPOSED -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6891
//
// <-- Short Description -->
// whos did not display global variables

whos -name %modalWarning
whos -type polynomial
