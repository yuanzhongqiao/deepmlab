// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 8097 -->
// <-- TEST WITH GRAPHIC -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8097
//
// <-- Short Description -->
// Scilab crashed when plotting on a figure with "Units" property set to "pixels".

f = gcf();

ierr = execstr("set(f, ""units"", ""pixels"")", "errcatch");
msg = lasterror();

if ierr==0 | msg<>msprintf(_("''%s'' property does not exist for this handle.\n"), "Units") then pause; end

delete(f);
