// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Allan CORNET <allan.cornet@inria.fr>
// Copyright (C) 2005-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- INTERACTIVE TEST -->
// <-- WINDOWS ONLY -->
// <-- NO CHECK REF -->

// Please be sure that current scilab is associated with .cosf, .xcos, .zcos & .ssp extensions
// The following lines should nor produce any error

res = winqueryreg("HKEY_CLASSES_ROOT","Scilab5.cosf");
res = winqueryreg("HKEY_CLASSES_ROOT","Scilab5.xcos");
res = winqueryreg("HKEY_CLASSES_ROOT","Scilab5.zcos");
res = winqueryreg("HKEY_CLASSES_ROOT","Scilab5.ssp");

