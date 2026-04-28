//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Yann COLLETTE <yann.collette@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 2588 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2588
//
// <-- Short Description -->
// Calling a function (with no input arugment) contained in an mlist
// generate an error.

function a=fun(),a=123,endfunction

x=mlist(['foo', 'y'],fun);

if execstr('x.y()','errcatch')<>0 then pause,end
if execstr('x.y(1)','errcatch')==0 then pause,end
