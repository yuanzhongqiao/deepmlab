// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 17121 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17121
//
// <-- Short Description -->
// Overload of display function must be called with no expected output argument.

function %user_p(x) 
	disp(argn(1)) 
end

function str = %user_string(x) 
	str = sprintf("%d", argn(1));
end

t = tlist("user","x",1)
string(t)
