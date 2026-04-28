// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 4968 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4968
//
// <-- Short Description -->
// part() or strsubst() problem with UTF-8 when exec ???
// =============================================================================
URL = "https://www.scilab.org/abc.htm";
// =============================================================================
tmp = strsubst(URL, "//", "§");
if tmp <> "https:§www.scilab.org/abc.htm" then pause,end
// =============================================================================
i = strcspn(tmp, "/");
if length("https:§www.scilab.org") <> 21 then pause, end
if i <> 21 then pause,end
// =============================================================================
server = strsubst(part(tmp, 1:i), "§", "//");
if part(tmp, 1:i) <> 'https:§www.scilab.org' then pause, end
if server <> 'https://www.scilab.org' then pause, end
// =============================================================================
