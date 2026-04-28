// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 1200 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1200
//
// <-- Short Description -->
//    Incoherence dans le format d'un nombre.
//    En prenant par exemple j=0.001, on obtient un affichage 
//    incoherent avec format :
//    format("v",6) => 0.001
//    format("v",7) => 1.E-3
//    format("v",8) => 0.001

dia_file = fullfile(TMPDIR,"bug1200.dia");
J=0.001;
format("v",7);
diary(dia_file);
disp(J);
diary(dia_file, "close");

expected = ["";
prompt()+"disp(J);";
"";
"   0.001";
"";
prompt()+"diary(dia_file, ""close"");"];
  
assert_checkequal(mgetl(dia_file), expected);