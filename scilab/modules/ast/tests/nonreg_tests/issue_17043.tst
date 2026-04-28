// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17043 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17043
//
// <-- Short Description -->
// Scilab callstack fixed with warning mode 'stop'.
warning("stop")
function sub_issue_17043()

    warning("stop on warning !")
end

function issue_17043()
    sub_issue_17043()
end

execstr("issue_17043()", "errcatch");
[msg, n, l, f] = lasterror();
assert_checkequal(l, 3)
assert_checkequal(f, "sub_issue_17043")
