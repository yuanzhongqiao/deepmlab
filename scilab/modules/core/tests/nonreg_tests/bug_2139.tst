//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2139 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2139
//
// <-- Short Description -->
//    Reshaping a global matrix can produce an invalid error

function reshapeA
global A
A=matrix(A,[2 2 2])
endfunction

global A

A=zeros(2,4);

if execstr("reshapeA", "errcatch")<>0 then pause,end



