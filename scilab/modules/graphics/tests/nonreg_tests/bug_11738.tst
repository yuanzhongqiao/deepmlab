// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - Scilab Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 11738 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11738
//
// <-- Short Description -->
// xsave + xload : bad and very slow rendering

scf(0);
clf;
plot();
f=gcf();
nbrChild = size(f.children());
xsave(fullfile(TMPDIR, "bug_11738.scg"),0);
close(0);
xload(fullfile(TMPDIR, "bug_11738.scg"));

f=gcf();
assert_checkequal(size(f.children), nbrChild);
delete(gcf());
