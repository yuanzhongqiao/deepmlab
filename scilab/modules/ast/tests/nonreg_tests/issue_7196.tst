// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 7196 -->
//
// <-- CLI SHELL MODE -->
//
// <-- Short Description -->
// try/catch: returned value assigned in `catch` is not displayed

function ret = issue_7196()
    try
        error("issue 7196 error")
        ret=0;
    catch
        // failed to display ret if this is the unique statement here
        ret=1;
    end
endfunction

issue_7196()