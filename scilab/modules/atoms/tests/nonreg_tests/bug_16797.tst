// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 16797 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16797
//
// <-- Short Description -->
// atomsGui: after File=>Update list of packages, clicking on a
// category that has a new package (or version) triggered an error

// We assume that you have write access to SCI (all_users mode).
//
//  * Get the date of the last ATOMS update:
p = fullfile(SCI,".atoms", "packages");
if isfile(p) then
    copyfile(p, p+"_save");               // save the original file
    getdate(fileinfo(p)(6))([6 2 1 7 8])  // display its modification date
end

// * Go to https://atoms.scilab.org/?order=when_update&direction=DESC
//   Have a look to a module recently added or with a very recent new version.
//   Take note of its name / id
//
// * Prevent automatic update:
atomsSetConfig offline True;

//  * run the ATOMS GUI, with the current (outdated) list of packages
atomsGui

// * Enable updating
atomsSetConfig offline False

//  * in the GUI: run the menu File => Update the list of packages.
//
//  * Then click on "all Modules" or on a category containing a
//    new module or a new version
//
// EXPECTED RESULT:
// 1) No error should be displayed in the console
// 2) Browsing within the ATOMS GUI should be possible as usual
// 3) The description of new modules or modules with a new version
//    should be displayed in the right pannel, without having to quit
//    and restart atomsGui.

// * Quit the GUI
close(get("atomsFigure"))
// * Restore the former package (to run once again this test)
    copyfile(p+"_save", p)                //  save the file
