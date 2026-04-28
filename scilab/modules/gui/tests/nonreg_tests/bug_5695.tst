// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

//
// <-- Non-regression test for bug 5695 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5695
//
// <-- Short Description -->
// "uigetfile" fails when we use 'multiple selection' input 4th argument.

// launch scilab and try each case:

fic = uigetfile(["*.txt";"*.csv"],"C:/", "Choose a file name 1",%f);

fic = uigetfile(["*.txt";"*.csv"],"C:/", "Choose a file name 2",%t);

fic = uigetfile(["*.txt";"*.csv"],"C:/", "Choose a file name 3");


