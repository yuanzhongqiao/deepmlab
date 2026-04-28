// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17380-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17380
//
// <-- Short Description -->
// fminsearch can not be called with an anonymous function as cost function.
// Analysis shows it was due to wrong scope access to varargout while using lambda
// no link at all with optimization 
// 
function y = stdFunction(x)
    y = 2 * x;
end

lambdaFunction = #(x) -> (2 * x)

function res = callMe(f, x)
    res = f(x)
endfunction

function varargout = callMeVarargout(f, x)
    res = f(x)
    varargout(1) = res
endfunction

v1 = callMe(stdFunction, 21)
assert_checkequal(v1, 42)

v2 = callMe(lambdaFunction, 21)
assert_checkequal(v2, 42)

v3 = callMeVarargout(stdFunction, 21)
assert_checkequal(v3, 42)

v4 = callMeVarargout(lambdaFunction, 21)
assert_checkequal(v4, 42)
