// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16181
//
// <-- Short Description -->
// Unit tests for replacing the "end" index

// Load mandatory functions
exec("SCI/modules/m2sci/macros/kernel/isacomment.sci", -1);
exec("SCI/modules/m2sci/macros/kernel/isinstring.sci", -1);
exec("SCI/modules/m2sci/macros/kernel/sciparam.sci", -1);
exec("SCI/modules/m2sci/macros/kernel/m2sci_syntax.sci",-1);

txt = mgetl("SCI/modules/m2sci/tests/unit_tests/conversion/END_index_syntax.m");

fnam = "END_index_syntax"; // Set by mfile2sci in standard case
[_, txt, _] = m2sci_syntax(txt);
txt($+1) = "endfunction"; // Force function closure (done by mfile2sci in standard case)

printf("%s\n",txt);
execstr(txt);

