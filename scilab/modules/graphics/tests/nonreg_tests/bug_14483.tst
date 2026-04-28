// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Nikhil Goel
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 14483 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14483
//
// <-- Short Description -->
// figure("Name" ...) should be an alias to figure("Figure_name" ...)
// =============================================================================

// Check if Name is working
f1 = figure("name", "nikhil");

// Check if Figure_name is working
f2 = figure("figure_name", "nikhil");
