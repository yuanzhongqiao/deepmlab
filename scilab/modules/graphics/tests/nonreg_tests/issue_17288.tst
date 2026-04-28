// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17288 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17288
//
// <-- Short Description -->
// graypolarplot failed when called with 4 or 5 input arguments

rho=1:0.1:4;theta=(0:0.02:1)*2*%pi;
z=30+round(theta'*(1+rho.^2));
f=gcf();
f.color_map= hot(128);
clf();
graypolarplot(theta,rho,z, "020");
assert_checkequal(gca().isoview, "off");

clf()
graypolarplot(theta,rho,z, "030", [-5 -5 5 5]);
assert_checkequal(gca().isoview, "on");
assert_checkequal(gca().data_bounds, [-5 -5; 5 5]);

