// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- JVM MANDATORY -->
// <-- NO CHECK REF -->

chdir(TMPDIR);

exec(SCI+"/modules/localization/tests/unit_tests/CreateDir.sce", -1);


tab_ref = [
"世界您好",
"азеазея",
"ハロー・ワールド",
"เฮลโลเวิลด์",
"حريات وحقوق",
"프로그램",
"프로그램",
"תוכנית"];

sleep(2);

if(fileinfo("test_time") <> [])
	deletefile("test_time");
end

f = mopen("test_time", "w");
mclose(f);

ref = 0;
FileNameList = ["test_time"];
for i = 1 : size(tab_ref,'*')
	FileNameList(i+1) = "dir_" + tab_ref(i) + filesep() + "file_" + tab_ref(i);
end

a = newest(FileNameList);
assert_checkequal(a, 1);

a=dir('SCI\bin');
f1=a(2);
r1=newest(f1);
clear a f1 r1

realtimeinit(2);
realtime(0);

tab_ref = [
"世界您好",
"азеазея",
"ハロー・ワールド",
"حريات وحقوق",
"תוכנית"];


for k=1 : size(tab_ref,"*")
	realtime(k);
	mputl("",TMPDIR+"/newest_"+tab_ref(k));
end

assert_checkequal(newest([]), []);
assert_checkequal(newest(), []);

assert_checkequal(newest("SCI/etc/scilab.start"), 1);
assert_checkequal(newest("SCI/nofile.txt"), 1);

for i = 1 : size(tab_ref,"*")
	for j = size(tab_ref,"*") : -1 : 1
		if(i <> j) then
			ref = max(i,j);
			if(ref == i) then
				ref = 1;
			else;
				ref = 2;
			end
			assert_checkequal(newest(TMPDIR+"/newest_"+tab_ref(i), TMPDIR+"/newest_"+tab_ref(j)), ref);
			assert_checkequal(newest([TMPDIR+"/newest_"+tab_ref(i), TMPDIR+"/newest_"+tab_ref(j)]), ref),
			assert_checkequal(newest([TMPDIR+"/newest_"+tab_ref(i); TMPDIR+"/newest_"+tab_ref(j)]), ref),
			assert_checkequal(newest(TMPDIR+"/newest_"+tab_ref(i), TMPDIR+"/no_file"), 1);
			assert_checkequal(newest([TMPDIR+"/newest_"+tab_ref(i), TMPDIR+"/no_file"]), 1);
			assert_checkequal(newest([TMPDIR+"/newest_"+tab_ref(i); TMPDIR+"/no_file"]), 1);
		end
	end
end
