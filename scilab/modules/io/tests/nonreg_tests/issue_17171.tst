// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17171 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17171
//
// <-- Short Description -->
// file("last", unit) does not work in Scilab 2024.0.0

file_name=fullfile(TMPDIR, "vector.txt");

// Write first line
header = "header test file";
oid = file("open", file_name, "unknown");
write(oid, header, "(a)");
file("close", oid);

// Write data (100 lines)
vector=linspace(1,10,10);
for i=1:100
    format("v", 20);
    oid = file("open", file_name, "old");
    file("last", oid);
    str = string(i) + "   " + strcat(string(vector(1, :)), " ");
    write(oid, str, "(a)");
    file("close", oid);
end

// Check file contents
txt = mgetl(file_name);
assert_checkequal(size(txt), [101 1]);
assert_checkequal(txt(1), header);
assert_checkequal(txt($), str);
