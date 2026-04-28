// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16953 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16953
//
// <-- Short Description -->
// mgetl does not trigger correctly stream status end-of-file (unix/macos)
//

ref = ["a";"b"];
name = fullfile(TMPDIR, "issue_16953.txt");
mputl(ref, name);
fd = mopen(name);
txt = [];
while ~meof(fd)
    txt = [txt; mgetl(fd, 1)];
end

mclose(fd);

assert_checkequal(txt, ref);