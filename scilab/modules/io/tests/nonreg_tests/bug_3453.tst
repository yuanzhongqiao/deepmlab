//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 3453 -->
//
// <-- Short Description -->
//    write(6,1) or write(6,[1 2;4 5]) crashs scilab
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3453
//

write(%io(2),'toto');
A = 1;
write(%io(2),A);
B = [1 2];
write(%io(2),B);