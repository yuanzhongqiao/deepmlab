// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17224 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17224
//
// <-- Short Description -->
// When used with bounds, optim returns wrong values for iter and evals
//

/*** test from the issue ***/
function [f, g, ind]=cost(x, ind)
    xref = [1; 2; 3];
    f = 0.5 * norm(x - xref)^2;
    g = x - xref;
endfunction

// Simplest call
x0 = [1; -1; 1];
[fopt, xopt, gopt, work, iters, evals] = optim(cost, x0);
assert_checkequal(iters, 4);
assert_checkequal(evals, 6);

// Upper and lower bounds on x
x0 = [1; -1; 1];
[fopt, xopt, gopt, work, iters, evals] = optim(cost, "b", [-1;0;2], [0.5;1;4], x0);
assert_checkequal(iters, 2);
assert_checkequal(evals, 1);
