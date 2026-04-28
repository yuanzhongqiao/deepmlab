// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 3258 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3258
//
// <-- Short Description -->
// Incompatibility detected between scilab4 and 5
// xpolys creates a compound objects the order of the handles in the compound
// is inverted compared to Scilab5

xpolys(1:3,1:3)

// get handle of the compound
e = gce();

if (e.children(1).data <> [3,3]) then pause; end
if (e.children(2).data <> [2,2]) then pause; end
if (e.children(3).data <> [1,1]) then pause; end
