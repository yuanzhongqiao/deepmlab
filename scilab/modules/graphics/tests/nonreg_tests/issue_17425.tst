// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17425 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17425
//
// <-- Short Description -->
// Matplot1 is broken for RGB images

imagepath = fullfile(TMPDIR,"issue_17425.png")
x = [];
t = linspace(0,1,480);
u = linspace(0,1,640);
for i=1:3
    x(:,:,i)=uint8(t'*u*256*i);
end

driver PNG
xinit(imagepath)
Matplot1(x,[0 0 1 1]);
xend
assert_checkequal(getmd5(imagepath),"24f57b7575d044eeb83b1925355061a4");


