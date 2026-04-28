// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 2656 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/2656
//
// <-- Short Description -->
//    M2sci doesn't convert "carriage return" inside a loop.

MFILECONTENTS=["a = 1;"
                "while ( a == 1)";
                "  a = 2;";
                "end";
                "a = 3"];

MFILE=TMPDIR+"/bug2656.m";
SCIFILE=TMPDIR+"/bug2656.sci";
mputl(MFILECONTENTS,MFILE);
mfile2sci(MFILE,TMPDIR);
SCIFILECONTENTS=mgetl(SCIFILE);

SCIFILECONTENTSREF=[
        ""
        "a = 1;"
        "while a==1"
        "  a = 2;"
        "end"
        "a = 3"];

if or(SCIFILECONTENTSREF<>SCIFILECONTENTS) then pause,end
