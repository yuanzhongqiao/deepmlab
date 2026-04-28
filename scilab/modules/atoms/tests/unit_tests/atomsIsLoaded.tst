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

//force official ATOMS repository
// Load the 1st scenario : See scene12.test.atoms.scilab.org.txt
// =============================================================================
atomsLoadTestScene("scene12");

// Install toolbox N°2
atomsInstall(["toolbox_2V6","2.1"],"user");

// Check installation
if ~ atomsIsInstalled(["toolbox_1V6","1.0","user"]) then pause, end
if ~ atomsIsInstalled(["toolbox_2V6","2.1","user"]) then pause, end

atomsLoad(["toolbox_2V6","2.1","user"]);

if ~ atomsIsLoaded("toolbox_2V6")                  then pause, end
if ~ atomsIsLoaded(["toolbox_2V6","2.1"])          then pause, end
if ~ atomsIsLoaded(["toolbox_2V6","2.1","user"])   then pause, end

if ~ atomsIsLoaded("toolbox_1V6")                  then pause, end
if ~ atomsIsLoaded(["toolbox_1V6","1.0"])          then pause, end
if ~ atomsIsLoaded(["toolbox_1V6","1.0","user"])   then pause, end

if atomsIsLoaded(["toolbox_1V6","1.0","allusers"]) then pause, end
if atomsIsLoaded(["toolbox_2V6","2.1","allusers"]) then pause, end

A = [ "toolbox_1V6" "1.0" "user"     ; ..
"toolbox_2V6" "2.1" "user"     ; ..
"toolbox_2V6" ""    "user"     ; ..
"toolbox_2V6" "2.1" ""         ; ..
"toolbox_2V6" ""    ""         ; ..
"toolbox_2V6" "2.1" "allusers" ];

if or(atomsIsLoaded(A) <> [%T ; %T ; %T ; %T ; %T ; %F]) then pause, end

// Remove toolbox_2
// =============================================================================
atomsRemove("toolbox_2V6","user");
