// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

chdir(TMPDIR);

warning("off");

tab_ref = [
"世界您好",
"азеазея",
"ハロー・ワールド",
"เฮลโลเวิลด์",
"حريات وحقوق",
"프로그램",
"프로그램",
"תוכנית"];

for i = 1 : size(tab_ref,'*')
	sz = "dir_" + tab_ref(i);
	a = createdir(sz);
	assert_checktrue(a);
	b = cd(TMPDIR + filesep() + sz);
	assert_checkequal(b, TMPDIR + filesep() + sz);
	cd(TMPDIR);
	removedir(sz);
end
