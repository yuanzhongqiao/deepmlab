// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16708 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16708
//
// <-- Short Description -->
// mgetl cannot read from stdin

SCI_BIN = fullfile(SCI, "bin", "scilab")
if getos() <> "Windows" && ~isfile(SCI_BIN) then
    // non-windows binary scilab version
    SCI_BIN = fullfile(SCI, "..", "..", "bin", "scilab")
end

cmd = msprintf("echo success| %s -ns -nwni -nb -e %s", SCI_BIN, """str=mgetl(%io(1));mprintf(str)""");
[_, result] = host(cmd);
assert_checkequal(result,"success");