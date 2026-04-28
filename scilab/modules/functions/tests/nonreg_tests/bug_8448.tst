// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- INTERACTIVE TEST -->
// interactive because it requires ATOMS and there are some outputs (not managed)
//
// <-- Non-regression test for bug 8448 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8448
//
// <-- Short Description -->
//  'whereis' function with a string as input argument did not work on some ATOMS functions.


atomsInstall("fmincon");
atomsLoad("fmincon");
bOK1 = whereis("fmincon") <> [];
bOK2 = whereis("fmincon_ipopt") <> [];
atomsRemove("fmincon");
if ~bOK1 | ~bOK2 then pause,end
