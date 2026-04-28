// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - DIGITEO - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
// <-- Non-regression test for bug 3572 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3572
//
// <-- Short Description -->
// When using grayplot, you cannot have different dimensions in entry.
//

x=1:2000; y=1:1000; m=rand(1000,2000);
grayplot(x,y,m');

// used to crash violently
