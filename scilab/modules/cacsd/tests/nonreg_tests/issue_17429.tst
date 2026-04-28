// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- TEST WITH GRAPHICS -->

// <-- Non-regression test for issue 17429 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17429
//
// <-- Short Description -->
// Colors of multiple graphics in bode() plots are reversed wrt colors shown in the legend

s = poly(0, 's');
h1 = syslin('c', (s^2+2*0.9*10*s+100)/(s^2+2*0.3*10.1*s+102.01));
h2 = syslin('c', 1/(s+1));
clf(); bode([h1; h2], 0.01, 100, ['h1'; 'h2']);
h = findobj(gcf(),"type","Legend");
assert_checkequal(h(1).links(1).foreground,1)