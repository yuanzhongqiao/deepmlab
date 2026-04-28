// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17279-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17279
//
// <-- Short Description -->
// Extraction of an unknown field from a struct (or library) created inside a function makes Scilab crash.
// 

msg = msprintf(_("Unknown field : %ls.\n"), "doesnotexist");

function test()
    st = struct()
    st.doesnotexist
endfunction
assert_checkerror("test()", msg);
clear test;

function test()
    st = lib("SCI/modules/elementary_functions/macros/")
    st.doesnotexist
endfunction
assert_checkerror("test()", msg);
clear test;

st = struct()
function test()
    st.doesnotexist
endfunction
assert_checkerror("test()", msg);
