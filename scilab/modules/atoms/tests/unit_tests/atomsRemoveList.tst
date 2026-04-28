// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- TEST WITH ATOMS -->

exec("SCI/modules/atoms/tests/unit_tests/atomsTestUtils.sce");

// Load the 1st scenario : See scene10.test.atoms.scilab.org.txt
// =============================================================================
atomsLoadTestScene("scene10");

// Install toolbox_5 & toolbox_3
// =============================================================================
atomsInstall("toolbox_5V6","user");
atomsInstall("toolbox_3V6","user");

// -----------------------------------------------------------------------------

ref = [ "-" "U" "toolbox_1V6" "1.0-1" "user" ;
"-" "P" "toolbox_5V6" "1.0-1" "user" ;
"-" "P" "toolbox_4V6" "1.0-1" "user" ;
"-" "P" "toolbox_2V6" "1.0-1" "user" ;
"-" "P" "toolbox_3V6" "1.0-1" "user" ;
"-" "P" "toolbox_2V6" "2.0-1" "user" ];

if or(atomsRemoveList(["toolbox_1V6"]      ,"user")<>ref) then pause, end
if or(atomsRemoveList(["toolbox_1V6" "1.0"],"user")<>ref) then pause, end

// -----------------------------------------------------------------------------

ref = [ "-" "U" "toolbox_2V6" "1.0-1" "user" ;
"-" "P" "toolbox_5V6" "1.0-1" "user" ;
"-" "P" "toolbox_4V6" "1.0-1" "user" ;
"~" "C" "toolbox_1V6" "1.0-1" "user" ];

if or(atomsRemoveList(["toolbox_2V6" "1.0"],"user")<>ref) then pause, end

// -----------------------------------------------------------------------------

ref = [ "-" "U" "toolbox_2V6" "2.0-1" "user" ;
"-" "P" "toolbox_3V6" "1.0-1" "user" ;
"~" "C" "toolbox_1V6" "1.0-1" "user" ];

if or(atomsRemoveList(["toolbox_2V6" "2.0"],"user")<>ref) then pause, end

// -----------------------------------------------------------------------------

ref = [ "-" "U" "toolbox_2V6" "2.0-1" "user" ;
"-" "U" "toolbox_2V6" "1.0-1" "user" ;
"-" "P" "toolbox_3V6" "1.0-1" "user" ;
"-" "C" "toolbox_1V6" "1.0-1" "user" ;
"-" "P" "toolbox_5V6" "1.0-1" "user" ;
"-" "P" "toolbox_4V6" "1.0-1" "user" ];

if or(atomsRemoveList(["toolbox_2V6"],"user")<>ref) then pause, end

// -----------------------------------------------------------------------------

ref = [ "-" "U" "toolbox_2V6" "2.0-1" "user" ;
"-" "U" "toolbox_2V6" "1.0-1" "user" ;
"-" "U" "toolbox_4V6" "1.0-1" "user" ;
"-" "P" "toolbox_3V6" "1.0-1" "user" ;
"-" "C" "toolbox_1V6" "1.0-1" "user" ;
"-" "P" "toolbox_5V6" "1.0-1" "user" ];

if or(atomsRemoveList(["toolbox_2V6";"toolbox_4V6"],"user")<>ref) then pause, end


// Remove toolbox_5 & toolbox_3
// =============================================================================
atomsRemove("toolbox_5V6","user");
atomsRemove("toolbox_3V6","user");

// no module should be installed
if ~isempty( atomsGetInstalled() ) then pause, end
