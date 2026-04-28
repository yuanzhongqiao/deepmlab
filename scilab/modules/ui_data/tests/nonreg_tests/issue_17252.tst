// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for issue 17252 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17252
//
// <-- Short Description -->
// uiimport export code failed with some variableNames in timeseries

// uiimport load a CSV/TXT file. This file must have a time column (datetime or 
// duration) whose column name contains spaces.
// Click on "Create a function" button. 
// The function code must contain 
// data(variableName with spaces in quote).format = outputformat