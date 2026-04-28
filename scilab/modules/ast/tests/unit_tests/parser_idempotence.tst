// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->


function files = getsubfiles(path, ext)
	files = [];
	folders = ls(path + filesep() + "*");
	for i = 1:size(folders, "*")
		if isdir(folders(i)) then
			files = [files; getsubfiles(folders(i), ext)];
		end
	end

	files = [files; ls(path + filesep() + ext)];
endfunction

function files = getfiles(subpath, ext)
	//modules = getmodules();
	modules = ls(fullfile(SCI, "modules"));
	path = sprintf(strsubst(fullfile(SCI, "modules", "%s", subpath), "\", "\\") + "\n", modules);
	
	
	files = getsubfiles(path, ext);

	files(grep(files, "parser_idempotence.tst")) = [];

	toremove = [];
	for i = 1:size(files, "*")
		txt = mgetl(files(i));
		if grep(txt, "<-- " + "INTERACTIVE TEST" + " -->") <> [] then
			toremove = [toremove;i];
		elseif grep(txt, "<-- " + "NOT FIXED" + " -->") <> [] then
			toremove = [toremove;i];
		end
	end

	files(toremove) = [];
endfunction

totalsize = 0;
// macros
files = getfiles("macros", "*.sci");
parser_idempotence(files);
totalsize = totalsize + size(files, "*");

// start
files = getfiles("etc", "*.start");
parser_idempotence(files);
totalsize = totalsize + size(files, "*");

// quit
files = getfiles("etc", "*.quit");
parser_idempotence(files);
totalsize = totalsize + size(files, "*");

// demos
files = getfiles("demos", "*.sci");
parser_idempotence(files);
totalsize = totalsize + size(files, "*");

// demos
files = getfiles("demos", "*.sce");
parser_idempotence(files);
totalsize = totalsize + size(files, "*");

// unit_tests
files = getfiles("tests" + filesep() + "unit_tests", "*.tst");
parser_idempotence(files);
totalsize = totalsize + size(files, "*");

// nonreg_tests
files = getfiles("tests" + filesep() + "nonreg_tests", "*.tst");
parser_idempotence(files);
totalsize = totalsize + size(files, "*");

disp(totalsize);