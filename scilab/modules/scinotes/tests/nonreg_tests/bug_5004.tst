// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Sylvestre KOUMAR
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- TEST WITH SCINOTES -->
//
// <-- Non-regression test for bug 5004 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5004
//
// <-- Short Description -->
//    Opening a file with accented characters with text-editor crashes Scilab very frequently.


//(With a terminal encoded into UTF-8)

//[$SHELL] echo 'éééééé' > with_accent.txt
//[$SHELL] echo 'eeeeee' > without_accent.txt

//--> editor("without_accent.txt"); // Open/Close editor ten times → Never crash
//--> editor("with_accent.txt"); // Open/Close editor ten times








