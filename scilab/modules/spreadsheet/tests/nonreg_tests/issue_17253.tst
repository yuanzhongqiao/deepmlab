// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17253 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17253
//
// <-- Short Description -->
// detectDelimiter detected space instead of tab in some cases.

a = [1:10]';
b = floor(rand(10, 1)*5)+1;
c = strsplit(ascii(floor(rand(10,1)*5)+65));
d = datetime(2024,5,1:10, 11, 0:6:59,5:5:50)';
varnames = ["D a t e" "r e s u l t 1", "r e s u l t 2", "r e s u l t 3"];
M = [varnames; string(d), string(a), string(b), c];
filename = fullfile(TMPDIR, "17253.csv");

// delimiter: ascii(9) or tab
csvWrite(M, filename, ascii(9));
opts = detectImportOptions(filename);
assert_checkequal(opts.delimiter, ascii(9));

// delimiter: space
varnames = strsubst(varnames, " ", ascii(9));
M(1,:) = varnames;

csvWrite(M, filename, " ");
opts = detectImportOptions(filename);
assert_checkequal(opts.delimiter, " ");