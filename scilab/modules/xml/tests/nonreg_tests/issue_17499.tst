// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17499 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17499
//
// <-- Short Description -->
// Issue with line property of XML element when line is bigger than 65535
//

// generate an XML document larger than 65535 lines
fd = mopen("TMPDIR/issue_17499.xml", "wt");
mputl("<bigDocument><lineNode>" + string(1) + "</lineNode>", fd);
for lineNum=2:120000
    mputl("<lineNode>" + string(lineNum) + "</lineNode>", fd);
end
mputl("</bigDocument>", fd);
mclose(fd);

d = xmlRead("TMPDIR/issue_17499.xml");

// Line smaller than 65535, check line and content
assert_checkequal(d.root.children(58947).line, 58947);
assert_checkequal(strtod(d.root.children(58947).content), 58947);

// Line bigger than 65535, check line and content
assert_checkequal(d.root.children(88420).line, 88420);
assert_checkequal(strtod(d.root.children(88420).content), 88420);
