// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- NO CHECK ERROR OUTPUT --> (error output displays nomber of generated pages...)
//
// <-- Non-regression test for bug 17070 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17070
//
// <-- Short Description -->
// Wrong title for xlabel web help
// - https://help.scilab.org/xlabel => Browser tab displays "xlabel - Sets or updates the z-axis label or/and its properties"
// - https://help.scilab.org/ => Graphics / annotation => Toc displays "zlabel — sets or updates the z-axis label or/and its properties"
// 

path = fullfile(TMPDIR, "issue_17070", "help");
mkdir(path);

// Create fake xlabel.xml help page
xml = [
"<?xml version=""1.0"" encoding=""UTF-8""?>";
"<refentry xmlns=""http://docbook.org/ns/docbook"" xmlns:xlink=""http://www.w3.org/1999/xlink""";
"          xmlns:svg=""http://www.w3.org/2000/svg"" xmlns:ns3=""http://www.w3.org/1999/xhtml""";
"          xmlns:mml=""http://www.w3.org/1998/Math/MathML"" xmlns:db=""http://docbook.org/ns/docbook""";
"          xmlns:scilab=""http://www.scilab.org""  xml:id=""xlabel"" xml:lang=""en"">";
"    <refnamediv>";
"        <refname>xlabel</refname>";
"        <refpurpose>sets or updates the x-axis label or/and its properties</refpurpose>";
"    </refnamediv>";
"    <refnamediv xml:id=""ylabel"">";
"        <refname>ylabel</refname>";
"        <refpurpose>sets or updates the y-axis label or/and its properties</refpurpose>";
"    </refnamediv>";
"    <refnamediv xml:id=""zlabel"">";
"        <refname>zlabel</refname>";
"        <refpurpose>sets or updates the z-axis label or/and its properties</refpurpose>";
"    </refnamediv>";
"</refentry>"
];
mputl(xml, fullfile(path, "xlabel.xml"))

// Generate HTML version
indexfile = xmltohtml(path);
html = mgetl(fullfile(fileparts(indexfile, "path"), "xlabel.html"));

// Check title
titleline = grep(html, "<title>");
assert_checkequal(stripblanks(html(titleline)), "<title>xlabel sets or updates the x-axis label or/and its properties</title>");

// Check toc entry
index = mgetl(indexfile);
tocline = grep(index, "xlabel.html");
assert_checktrue(grep(index(tocline), ">xlabel<") <> []);
assert_checktrue(grep(index(tocline), "sets or updates the x-axis label or/and its properties") <> []);
