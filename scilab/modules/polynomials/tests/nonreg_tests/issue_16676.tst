// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16911 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// sfact([%s %s ; %s %s]) crashes Scilab after "sfact: Wrong value for input argument #1: singular or asymmetric problem." message 

msgerr = msprintf(gettext("%s: Wrong value for input argument #%d: Maximum degree must be even.\n"), "sfact", 1);
assert_checkerror("sfact([%s %s ; %s %s])", msgerr);

msgerr = msprintf(gettext("%s: Wrong value for input argument #%d: Convergence problem.\n"), "sfact", 1);
assert_checkerror("sfact(1+%s+%s^2)", msgerr);
