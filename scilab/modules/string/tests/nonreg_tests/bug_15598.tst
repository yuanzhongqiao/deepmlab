// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 15598 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15598
//
// <-- Short Description -->
// string(handle) returns "" instead of calling %h_string()  (regression)

deff('out=%h_string(hdl)','out=hdl.type')
assert_checkequal(string(gcf()),'Figure');
assert_checkequal(string(gca()),'Axes');
