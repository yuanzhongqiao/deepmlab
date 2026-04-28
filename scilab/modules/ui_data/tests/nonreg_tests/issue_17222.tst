// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for issue 17222 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17222
//
// <-- Short Description -->
// Wrong default option proposed when exporting a variable to CSV

// 1 - Export to CSV
// Create a variable: a = 1:10;
// Right click on variable "a" in variable browser, then "Export to CSV"
// Check that default file extension is set to "*.csv"
// Enter a file name & click on "Save" button
// Check the file contents

// 2 - Export to CSV & Cancel
// Right click on variable "a" in variable browser, then "Export to CSV"
// Click on "Cancel" button
// Check there is no "__export__csv__" variable listed in variable browser

// 3 - Unsupported types
// Create a polynomial variable: b = %s
// Right click on variable "b" in variable browser, then "Export to CSV"
// Check that a (error) messagebox is displayed
// Switch to french: setlanguage("fr_FR")
// Check the error message is displayed too
