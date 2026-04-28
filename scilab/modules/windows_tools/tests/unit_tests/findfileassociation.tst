// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- INTERACTIVE TEST -->
// <-- WINDOWS ONLY -->
// <-- NO CHECK REF -->

// Please be sure that current scilab is associated with .sce & .sci extensions

r = findfileassociation(".sce");
assert_checktrue(convstr(part(r, ($-10):$), "l") == "wscilex.exe");

r = findfileassociation(".sci");
assert_checktrue(convstr(part(r, ($-10):$), "l") == "wscilex.exe");
