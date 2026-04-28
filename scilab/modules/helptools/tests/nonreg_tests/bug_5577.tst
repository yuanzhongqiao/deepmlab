//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 5577 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5577
//
// <-- Short Description -->
// help_skeleton macros encoded the generated xml file in ISO-8859-1 and not in UTF-8.


function [y,z]=foo(a,b),y=a+b,z=1,endfunction
p = help_skeleton('foo',TMPDIR);
r = mgetl(p);

if grep(r,'UTF-8') <> 1 then pause,end