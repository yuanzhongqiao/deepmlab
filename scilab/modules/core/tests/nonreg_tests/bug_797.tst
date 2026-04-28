// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- Non-regression test for bug 797 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/797
//
// <-- Short Description -->
//    Toutes les versions
//
//    Objet : Comportemment �trange avec format
//    REF  01062004-1545
//
//    voici un comportement �trange avec format (test� sous la
//    2.7.2 sur Win 2000), celui-ci est il volontaire ?
//
//    ----------------------------------------------------------
//    -->J=0.001
//    J =
//
//    .001
//
//
//    -->format("v",6)
//    -->J
//    J =
//
//    .001 <- OK c'est bien ce qu'on souhaite 
// ...

dia_file = fullfile(TMPDIR,"bug797.dia");

J=0.001;
format("v",7);
diary(dia_file);
disp(J);
diary(dia_file, "close");

expected=[  "";
  prompt()+"disp(J);";
  "";
  "   0.001";
  "";
  prompt()+"diary(dia_file, ""close"");"];

assert_checkequal(mgetl(dia_file), expected);