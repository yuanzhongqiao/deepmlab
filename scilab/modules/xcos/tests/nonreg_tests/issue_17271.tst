// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- WINDOWS ONLY -->
//
// <-- Non-regression test for issue 17271 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17271
//
// <-- Short Description -->
// Bug trying to run any modelica or coselica exemple from a fresh installation
// Actually an issue with modelicat, modelicac and XML2modelica binaries
// which were 32-bits executables embedded in Scilab x64 hence needing SDK which can be missing on user machine

if ~exists("dynamic_linkwindowslib") then
    load("SCI/modules/dynamic_link/macros/windows/lib");
end

exe = ["modelicac.exe";"modelicat.exe";"XML2modelica.exe"]
cmd = "dumpbin /HEADERS " + fullfile(SCI, "bin", exe);
[_, txt] = host(dlwWriteBatchFile(cmd));

fileheader = grep(txt, "FILE HEADER VALUES");
for h = fileheader
    assert_checktrue(strindex(txt(h + 1), "machine (x64)") <> []);
end

fileoptional = grep(txt, "OPTIONAL HEADER VALUES");
for o = fileoptional
    assert_checktrue(strindex(txt(o + 1), "magic # (PE32+)") <> []);
end
