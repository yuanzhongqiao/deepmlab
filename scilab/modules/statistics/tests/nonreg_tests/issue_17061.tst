// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17061 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17061
//
// <-- Short Description -->
// cdf*() crashed Scilab under macOS/arm64

[P,Q]=cdfbet("PQ",.5,.5,1,1);
[P,Q]=cdfbin("PQ",2,10,.5,.5);
[P,Q]=cdfchi("PQ",.5,1);
[P,Q]=cdfchn("PQ",1,2,1);
[P,Q]=cdff("PQ",0.1,2,2);
[P,Q]=cdffnc("PQ",1,2,4,.5);
[P,Q]=cdfgam("PQ",0.1,0.1,1);
[P,Q]=cdfnbn("PQ",2,3,0.7,0.3);
[P,Q]=cdfnor("PQ",0.1,0,1);
[P,Q]=cdfpoi("PQ",3,2);
[P,Q]=cdft("PQ",5,2);
