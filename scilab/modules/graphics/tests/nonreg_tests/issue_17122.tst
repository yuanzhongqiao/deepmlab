// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17122 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17122
//
// <-- Short Description -->
// Save on polyline free (x/y/z)shift

scf();
colors = ['scilabblue4' 'scilabgreen4' 'scilabcyan4' 'scilabred4' 'scilabbrown4' 'scilabmagenta4'];
y= [68;69;58;62;70;65];

for m = 1:6
    bar(m, y(m),0.5, colors(m));
end

xsave(TMPDIR+'bartest_xsave.scg');
delete(gcf());
