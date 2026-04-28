// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->
//
// <-- Non-regression test for bug 15632 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15632
//
// <-- Short Description -->
// x=[];x()=1 crashes Scilab

assert_checkerror("x=[];x()=1","Wrong insertion : Cannot insert without arguments.");
