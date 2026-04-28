// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Bugzilla URL -->
// http://bugzilla.scilab.org/8917
//
// write(filename,..) could not overwrite an existing file

File = fullfile(TMPDIR, "test.txt");
mputl(["This" "is" "a" "test"]',File);

a = [%pi 0 ; 0 %e];
err = execstr("write(File,a)", "errcatch")
assert_checkequal(err, 0);

deletefile(File)
