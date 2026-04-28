// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16867-->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16867
//
// <-- Short Description -->
// macr2tree() now encodes .' (transpose) as ' (conjugate transpose)
//

function conjugate()
    a = a'
endfunction
code = macr2tree(conjugate).statements(2).expression
assert_checkequal(code.operator, "''")

function transpose()
    a = a.'
endfunction
code = macr2tree(transpose).statements(2).expression
assert_checkequal(code.operator, ".''")
