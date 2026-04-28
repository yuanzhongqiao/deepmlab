// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16960 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// write() no longer prints empty line when empty string is given.

F = fullfile(TMPDIR,"test.txt"); deletefile(F); 
write(F, ["" "ABC" "" "def" ""]); 
r = mgetl(F); 
s = size(r);
assert_checkequal(s, [5 1]);

// this test uses diary() instead of the test_run check ref
// because test_run removes empty lines before the comparison.
f = fullfile(TMPDIR, "_issue_16960.dia");
id = diary(f, "new");
write(%io(2), ["" "ABC" "" "def" ""])
diary(id, "close");
mgetl(f)
// 3:$-2 : skip the call of write and diary close when executed with test_run
assert_checkequal(mgetl(f)(3:$-2), [""; "ABC"; ""; "def"; ""]);
