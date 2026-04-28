// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan SIMON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 4883 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4883
//
// <-- Short Description -->
// "Menu→Document→Auto Indent" preference is not saved.


//scinotes()
//uncheck "Menu→Document→Auto Indent"
//close scinotes
//scinotes()
//=> "Menu→Document→Auto Indent" should stay unchecked

