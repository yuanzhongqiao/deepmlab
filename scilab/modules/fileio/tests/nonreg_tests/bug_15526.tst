// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - ESI Group - Paul Bignier
// Copyright (C) 2018 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15526 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15526
//
// <-- Short Description -->
// fscanfMat failed with a large text file

//generate file
a = 0.8:1.6:800.8;
a = a';
loop = 90;
filename = fullfile(TMPDIR, "bug_15526.tst");

//binary mode to keep LF endings even on Windows.
f = mopen(filename, "wb");
for i = 1:loop
    mfprintf(f, "%.1f\n", a);
end

mclose(f);


X = fscanfMat(filename);
assert_checkequal(size(X), [45090 1]);

deletefile(filename);
