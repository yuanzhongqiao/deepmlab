// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 16941 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16941
//
// <-- Short Description -->
// fplot3d() ignored any explicit theta value

deff('z=f(x,y)','z=x^4-y^4')
x = -3:0.2:3;
y = x ;
// fplot3d(xr,yr,f,[theta,alpha,leg,flag,ebox])
// gca().rotation_angles = [alpha, theta]
clf()
fplot3d(x,y,f)
assert_checkequal(gca().rotation_angles, [35 45]);

clf()
fplot3d(x,y,f,20)
assert_checkequal(gca().rotation_angles, [35 20]);

clf()
fplot3d(x,y,f,20, 10)
assert_checkequal(gca().rotation_angles, [10 20]);

clf()
fplot3d(x,y,f,, 10)
assert_checkequal(gca().rotation_angles, [10 45]);

clf()
fplot3d(x,y,f, alpha=30)
assert_checkequal(gca().rotation_angles, [30 45]);

clf()
fplot3d(x,y,f, alpha=30, theta=15)
assert_checkequal(gca().rotation_angles, [30 15]);
