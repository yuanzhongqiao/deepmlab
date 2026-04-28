// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16535 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- WINDOWS ONLY -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16535
//
// <-- Short Description -->
// host command does not execute .bat file

batfile = TMPDIR+"\file_host.bat";
outfile = TMPDIR+"\out_host.txt";
mputl("echo scilab test > " + outfile, batfile);
assert_checkequal(host(batfile), 0);

str = mgetl(outfile);
assert_checkequal(str, "scilab test ");
