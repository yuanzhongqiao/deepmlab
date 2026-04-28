// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA - Vincent COUVERT <vincent.couvert@inria.fr>
// Copyright (C) 2005-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 979 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/979
//
// <-- Short Description -->
//    Matlab comments like %blabla are translated to
//    part(comment,"blabla") [!?]

MFILECONTENTS=["comment=1;";"%This line is a comment line"];

MFILE=TMPDIR+"/bug979.m";
SCIFILE=TMPDIR+"/bug979.sci";

mputl(MFILECONTENTS,MFILE);
sleep(200);
mfile2sci(MFILE,TMPDIR);
sleep(200);
SCIFILECONTENTS=mgetl(SCIFILE);

SCIFILECONTENTSREF = [
    "";
    "comment = 1;";
    "//This line is a comment line"];

if or(SCIFILECONTENTSREF<>SCIFILECONTENTS) then pause,end
