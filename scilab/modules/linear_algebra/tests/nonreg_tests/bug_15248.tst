// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15248 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15248
//
// <-- Short Description -->
// lsq() is leaking memory

a = rand(100,100);
b = rand(100,100);
for i=1:200
    x = lsq(a,b);
end
clear i a b x

