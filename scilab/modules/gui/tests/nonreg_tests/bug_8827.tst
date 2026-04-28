// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- Non-regression test for bug 8827 -->
//
// <-- TEST WITH GRAPHIC -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8827
//
// <-- Short Description -->
// userdata property for a menu crashed Scilab
//

if execstr("uimenu(""Parent"", gcf(), ""Label"", ""test"", ""userdata"", list());", "errcatch") <> 0 then pause, end

delete(gcf());
