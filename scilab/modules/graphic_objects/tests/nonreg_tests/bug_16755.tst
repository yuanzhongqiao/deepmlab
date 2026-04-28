// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16755 -->
//
// <-- Bugzilla URL -->
// http://bugzilla.scilab.org/show_bug.cgi?id=16755
//
// <-- Short Description -->
// plot3d polygon facets face wrong way when exactly in horizontal or vertical plane

function h=plotTetra(x,y,z,ind,c)
    it = 1+[0 2 1;0 1 3;2 3 1;3 2 0]';
    plot3d(x(1+ind(it)),y(1+ind(it)),z(1+ind(it)))
    h=gce()
    h.color_flag=0;
    h.color_mode=c
endfunction

x=[0 1 1 0 0 1 1 0];
y=[0 0 1 1 0 0 1 1];
z=[0 0 0 0 1 1 1 1];

f1 = scf(1)
clf
h=[
plotTetra(x,y,z, [3,2,1,7],2)
plotTetra(x,y,z, [1,7,0,3],3)
plotTetra(x,y,z, [7,1,6,2],4)
plotTetra(x,y,z, [7,1,0,4],5)
plotTetra(x,y,z, [5,4,1,7],6)
plotTetra(x,y,z, [5,7,1,6],7)
];

gca().rotation_angles=[135,45]
h.hiddencolor=0

f2 = scf(2)
clf
h=[
plotTetra(x,y,z, [3,2,1,7],2)
plotTetra(x,y,z, [1,7,0,3],3)
plotTetra(x,y,z, [7,1,6,2],4)
plotTetra(x,y,z, [7,1,0,4],5)
plotTetra(x,y,z, [5,4,1,7],6)
plotTetra(x,y,z, [5,7,1,6],7)
];

gca().rotation_angles=[135,45]
h.hiddencolor=1;

// bitmap images should be bitwise equal
xs2png(f1,fullfile(TMPDIR,"bug_1755_1.png"))
xs2png(f2,fullfile(TMPDIR,"bug_1755_2.png"))
res1 = getmd5(fullfile(TMPDIR,"bug_1755_1.png"));
res2 = getmd5(fullfile(TMPDIR,"bug_1755_2.png"));
assert_checkequal(res1,res2)
