// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for issue 463 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/463
//
// <-- Short Description -->
// Invalid format leads to crash for write function
//

msg = "Incorrect file or format.";
assert_checkerror("write(%io(2),[1,2],""(F8.3)"")", msg);
assert_checkerror("write(%io(2), 1:10, ""(I4)"")", msg);