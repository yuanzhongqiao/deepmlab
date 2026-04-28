//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 8682 -->
//
// <-- ENGLISH IMPOSED -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8682
//
// <-- Short Description -->
// funcprot did not return the previous value when called with an argument.

deff('x = myplus(y, z)', 'x = y + z');
prot = funcprot(0); // one-line protection
deff('x=myplus(y,z)','x = y + z');
funcprot(prot);