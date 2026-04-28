// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17360 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17360
//
// <-- Short Description -->
// CDATA is not supported on XML Element "content"
//

xml=["<root><a att=""foo"" rib=""bar""><b>Hello</b></a></root>"];
expected=["<?xml version=""1.0""?>";"<root><![CDATA[this is unsafe content]]></root>"];

doc = xmlReadStr(xml);
doc.root.content = "<![CDATA[" + "this is unsafe content" + "]]>";
result=xmlDump(doc);
xmlDelete(doc);

assert_checkequal(expected, result);
