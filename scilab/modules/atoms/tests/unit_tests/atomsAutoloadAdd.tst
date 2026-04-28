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
atomsLoadTestScene("scene10");

// 1st test case
// =============================================================================

// Install toolbox_5 in the user section
atomsInstall("toolbox_5V6","user");

// atomsAutoloadAdd just after install is disable,
// → atomsAutoloadList should return an empty matrix
if ~ isempty(atomsAutoloadList()) then pause, end

if atomsAutoloadAdd("toolbox_5V6"               ,"user") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0"]       ,"user") <> 0 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0" "user"],"user") <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_4V6" "1.0" "user"],"user") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_4V6" "1.0"]       ,"user") <> 0 then pause, end
if atomsAutoloadAdd("toolbox_4V6"               ,"user") <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_2V6" "1.0"]       ,"user") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_2V6" "1.0" "user"],"user") <> 0 then pause, end
if atomsAutoloadAdd("toolbox_2V6"               ,"user") <> 0 then pause, end

ref = ["toolbox_5V6" "1.0-1" "user" "user" ; ..
"toolbox_4V6" "1.0-1" "user" "user" ; ..
"toolbox_2V6" "1.0-1" "user" "user"];


if or(atomsAutoloadList()<>ref) then pause, end


atomsRemove("toolbox_5V6");

// no module should be installed
if ~isempty( atomsGetInstalled() ) then pause, end
if ~isempty( atomsAutoloadList() ) then pause, end

// 2nd test case
// =============================================================================

// Install toolbox_5 in both user and allusers sections
atomsInstall("toolbox_5V6","allusers");

// atomsAutoloadAdd just after install is disable,
// → atomsAutoloadList should return an empty matrix
if ~ isempty(atomsAutoloadList()) then pause, end

if atomsAutoloadAdd("toolbox_5V6"                   ,"allusers") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0"]           ,"allusers") <> 0 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0" "allusers"],"allusers") <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_4V6" "1.0" "allusers"],"allusers") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_4V6" "1.0"]           ,"allusers") <> 0 then pause, end
if atomsAutoloadAdd("toolbox_4V6"                   ,"allusers") <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_2V6" "1.0"]           ,"allusers") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_2V6" "1.0" "allusers"],"allusers") <> 0 then pause, end
if atomsAutoloadAdd("toolbox_2V6"                   ,"allusers") <> 0 then pause, end

ref = ["toolbox_5V6" "1.0-1" "allusers" "allusers" ; ..
"toolbox_4V6" "1.0-1" "allusers" "allusers" ; ..
"toolbox_2V6" "1.0-1" "allusers" "allusers"];

if or(atomsAutoloadList()<>ref) then pause, end

atomsAutoloadDel( ["toolbox_5V6";"toolbox_4V6";"toolbox_2V6"] );
if ~isempty( atomsAutoloadList() ) then pause, end

if atomsAutoloadAdd("toolbox_5V6"                   ,"user") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0"]           ,"user") <> 0 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0" "allusers"],"user") <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_4V6" "1.0" "allusers"],"user") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_4V6" "1.0"]           ,"user") <> 0 then pause, end
if atomsAutoloadAdd("toolbox_4V6"                   ,"user") <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_2V6" "1.0"]           ,"user") <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_2V6" "1.0" "allusers"],"user") <> 0 then pause, end
if atomsAutoloadAdd("toolbox_2V6"                   ,"user") <> 0 then pause, end

ref = ["toolbox_5V6" "1.0-1" "allusers" "user" ; ..
"toolbox_4V6" "1.0-1" "allusers" "user" ; ..
"toolbox_2V6" "1.0-1" "allusers" "user"];

if or(atomsAutoloadList()<>ref) then pause, end

atomsAutoloadDel( ["toolbox_5V6";"toolbox_4V6";"toolbox_2V6"] );
if ~isempty( atomsAutoloadList() ) then pause, end


if atomsAutoloadAdd("toolbox_5V6"                   ) <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0"]           ) <> 0 then pause, end
if atomsAutoloadAdd(["toolbox_5V6" "1.0" "allusers"]) <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_4V6" "1.0" "allusers"]) <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_4V6" "1.0"]           ) <> 0 then pause, end
if atomsAutoloadAdd("toolbox_4V6"                   ) <> 0 then pause, end

if atomsAutoloadAdd(["toolbox_2V6" "1.0"]           ) <> 1 then pause, end
if atomsAutoloadAdd(["toolbox_2V6" "1.0" "allusers"]) <> 0 then pause, end
if atomsAutoloadAdd("toolbox_2V6"                   ) <> 0 then pause, end

ref = ["toolbox_5V6" "1.0-1" "allusers" "allusers" ; ..
"toolbox_4V6" "1.0-1" "allusers" "allusers" ; ..
"toolbox_2V6" "1.0-1" "allusers" "allusers"];

if or(atomsAutoloadList()<>ref) then pause, end

atomsRemove("toolbox_5V6");
