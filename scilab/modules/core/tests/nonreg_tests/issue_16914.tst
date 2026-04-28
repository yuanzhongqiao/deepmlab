// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16914 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// Wrong line number with t/mlist extraction overload

// MList
ml = mlist(["test", "field"], 1);

function out = %test_e(varargin)
    out = 42;
    [l,fun]=where();
    assert_checkequal(l(1:2), [3;2]);
    assert_checkequal(fun(1:2), ["%test_e"; "issue_16914"]);
endfunction

function issue_16914(ml)
    ml(1);
end

issue_16914(ml);


// TList
tl = tlist(["test", "field"], 1);

function out = %test_e(varargin)
    out = 42;
    [l,fun]=where();
    assert_checkequal(l(1:2), [3;2]);
    assert_checkequal(fun(1:2), ["%test_e"; "issue_16914"]);
endfunction

function issue_16914(tl)
    tl("bad field");
end

issue_16914(tl);
