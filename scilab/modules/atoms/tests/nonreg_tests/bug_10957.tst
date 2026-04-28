// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH ATOMS -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 10957 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/10957
//
// <-- Short Description -->
// atomsInstall required a network connection to install a local package.

// download a module on hard drive
// disable your network connection 

// disable your network connection 
atomsSetConfig('offline', 'True')

// be sure that you have no internet connection
atomsInstall('~/grocer_1.52-1.bin.zip')

