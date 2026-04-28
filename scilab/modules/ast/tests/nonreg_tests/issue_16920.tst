// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E.
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16920-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16920
//
// <-- Short Description -->
// MatrixExp insertion in an empty matrix and using colon crashes Scilab
//

a = []; a(:) = ["a", "a"];
assert_checkequal(a, ["a", "a"]);