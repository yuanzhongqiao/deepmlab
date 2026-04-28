// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4030 -->
//
// <-- INTERACTIVE TEST -->
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4030
//
// <-- Short Description -->
// unix_w('dir /s') displays strange matrix 

host('dir /s', echo=%t)

// see output 
