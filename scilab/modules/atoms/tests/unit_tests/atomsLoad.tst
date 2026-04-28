// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
// <-- TEST WITH ATOMS -->

exec("SCI/modules/atoms/tests/unit_tests/atomsTestUtils.sce");

atomsLoadTestScene("scene12");

// 1st test-case : Just install the toolbox 5
// =============================================================================
atomsInstall("toolbox_5V6");

// Check if the module is really installed

if ~ and( atomsIsInstalled( ["toolbox_5V6" "1.0" ; ..
    "toolbox_4V6" "1.1" ; ..
    "toolbox_2V6" "1.0" ; ..
"toolbox_1V6" "1.0"])) then pause, end

atomsLoad("toolbox_5V6");

if ~ atomsIsLoaded("toolbox_5V6") then pause, end
if ~ atomsIsLoaded(["toolbox_5V6" "1.0"]) then pause, end

if ~ and(atomsIsLoaded(["toolbox_5V6"; ..
    "toolbox_2V6"; ..
    "toolbox_1V6"; ..
"toolbox_4V6"])) then pause, end

if ~ and(atomsIsLoaded(["toolbox_5V6" "1.0"; ..
    "toolbox_2V6" "1.0"; ..
    "toolbox_1V6" "1.0"; ..
"toolbox_4V6" "1.1"])) then pause, end

if or( t5_version() <> ["Toolbox 5 -> version = 1.0"; ..
    "Toolbox 4 -> version = 1.1"; ..
    "Toolbox 2 -> version = 1.0"; ..
"Toolbox 1 -> version = 1.0" ] ) then pause, end

atomsRemove("toolbox_5V6");
