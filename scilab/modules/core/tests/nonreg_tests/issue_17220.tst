// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17220 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17220
//
// <-- Short Description -->
// TMPDIR not deleted on windows when Scilab quits

if getos() == "Windows" then
    scilabBin = """" + WSCI + "\bin\scilab.bat""";
else
    scilabBin = strsplit(SCI, "share/scilab")(1) + "/bin/scilab";
end

// Run another Scilab with Java to be sure there is no Java process/thread which locks TMPDIR
[_, rep] = host(scilabBin + " -nw -e ""disp(TMPDIR)"" -quit");
rep(rep=="") = []; // Remove empty lines to be sure TMPDIR value is on last line

// Extract root of TMPDIR of Scilab launched using unix_g()
tmpdir = evstr(rep($));
tmpdirRoot = part(tmpdir, 1:max(strindex(tmpdir, filesep())));

// Get root of TMPDIR of this Scilab (to check that what we read in 'rep' seems to be a valid TMPDIR)
scilabTmpdirRoot = part(TMPDIR, 1:max(strindex(TMPDIR, filesep())));
assert_checkequal(tmpdirRoot, scilabTmpdirRoot);

// Check that TMPDIR of Scilab launched using unix_g() has been deleted
assert_checkfalse(isdir(tmpdir));