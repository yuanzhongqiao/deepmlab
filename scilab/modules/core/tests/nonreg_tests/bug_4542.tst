//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2009 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4542 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4542
//
// <-- Short Description -->
// unexpected  interpreter warning.

function foo1()
for i=1
 disp('abcdefghijklmonoprstuvwxyz')
end
endfunction 


function foo2()
while 1
 disp('abcdefghijklmonoprstuvwxyz')
end
endfunction 
