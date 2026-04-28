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
// <-- Non-regression test for bug 15321 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15321
//
// <-- Short Description -->
// lu() is leaking memory

a = rand(100,100);
for i=1:30
    [l,u] = lu(a);
end
clear i a l u

