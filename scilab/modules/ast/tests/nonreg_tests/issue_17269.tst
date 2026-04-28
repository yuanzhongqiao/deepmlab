// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17269 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17269
//
// <-- Short Description -->
// Allow arguments block to check dims over dims of input argument

function check(x)
    arguments
        x (:, :, [1 3])
    end
end

check(rand(2, 2))
check(rand(2, 2, 3))
assert_checkerror("check(rand(2, 2, 2))", [], 999);
