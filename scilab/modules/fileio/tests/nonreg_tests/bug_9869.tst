// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 9869 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9869
//
// <-- Short Description -->
// fscanf did not check number of input arguments
// fscanf is the same function than mfscanf.

msgError = gettext("%s: Wrong number of input argument(s): %d to %d expected.\n");
assert_checkerror ("mfscanf()", msgError , [] , "mfscanf" , 2, 3);

msgError = gettext("%s: Wrong number of input argument(s): %d to %d expected.\n");
assert_checkerror ("mfscanf(TMPDIR + ""/bug_9869.dat"")", msgError , [] , "mfscanf" , 2, 3);

mputl(string(1:4), TMPDIR + "/bug_9869.dat");
fd = mopen(TMPDIR + "/bug_9869.dat");
R = mfscanf(fd,"%d");
assert_checkequal(R, 1);
