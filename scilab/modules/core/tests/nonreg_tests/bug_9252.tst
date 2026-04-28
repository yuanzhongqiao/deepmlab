// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Charlotte HECQUET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 9252 -->
//
// <-- CLI SHELL MODE -->
// 
// <-- INTERACTIVE TEST -->
// 
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9252
//
// <-- Short Description -->
// Some error prototypes produce screwed display

function bugme()
    error(666,"My freaking error")
endfunction

bugme

// Check that the error message is this one:
// !--error 666 
//My freaking error
//at line       2 of function bugme called by :  
//bugme

// and not this one:
// !--error 666 
//My freaking errorat line       2 of function bugme called by :  
//bugme()
