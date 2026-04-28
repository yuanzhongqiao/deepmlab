// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Author: Ishit Mehta (ibm)
// Copyright (C) 2015
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->

// <-- Non-regression test for bug 13733 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13733
//
// <-- Short Description -->
// Optional arguments did not work properly. e.g colorbar(1,10,fmt="%d").

colorbar(1,10,fmt="%d");
colorbar(1,10,[1,10],fmt="%d");
colorbar(1,10,fmt="%d", colminmax=[1,10]);