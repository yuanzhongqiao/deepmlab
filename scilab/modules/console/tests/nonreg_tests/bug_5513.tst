// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 5513 -->
// <-- INTERACTIVE TEST -->
// <-- NOT FIXED -->  6.0.2 -> 6.1.1
//
// <-- Short Description -->
// input("message") interrupted with CTRL-C + resume did not restore
// the original prompt after resuming
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5513
//


c = input("Give a string : ","string")
// press ctrl+C to put Scilab in pause
// type resume
// and put a value
// c must be correct

d = input("Give a value : ")
// press ctrl+C to put Scilab in pause
// type resume
// and put a value
// d must be correct
