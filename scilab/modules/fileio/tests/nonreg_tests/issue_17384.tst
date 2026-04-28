// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 17384 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17384
//
// <-- Short Description -->
// msscanf makes Scilab crash

filename = fullfile(SCI, "modules","fileio","tests","nonreg_tests", "issue_17384.txt")
format_scan = "%s %lf %lf %lf %lf";

data_str = mgetl(filename);
for iter = 1:20
  L1 = msscanf(-1, data_str, format_scan);
end 

fd = mopen(filename);
for iter = 1:20
    L2 = mfscanf(-1, fd, format_scan);
    mseek(0, fd);
end

assert_checkequal(L1, L2);