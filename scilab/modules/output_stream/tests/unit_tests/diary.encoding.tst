// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//<-- CLI SHELL MODE -->
//<-- NO CHECK REF -->

tab_ref = [
"世界您好",
"азеазея",
"ハロー・ワールド",
"เฮลโลเวิลด์",
"حريات وحقوق",
"תוכנית"];

for i = 1 : size(tab_ref,'*')
  dia_file = fullfile(TMPDIR, tab_ref(i)+'.diary');
  diary(dia_file);
  1+1;
  diary(dia_file, "close");
  assert_checkfalse(fileinfo(dia_file) == []);
end
