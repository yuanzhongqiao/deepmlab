// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

//
// <-- Non-regression test for issue 15568 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15568
//
// <-- Short Description -->
// savematfile() does not support boolean/logical variables with version>4

baref = %t;
bvref = rand(1,5)<0.5;
bmref = rand(2,3)<0.5;

for filever = ["-v6", "-v7", "-v7.3"]

    // Init variables to be saved
    ba = baref;
    bv = bvref;
    bm = bmref;

    // Save variables
    savematfile(fullfile(TMPDIR, "issue_15568.mat"),filever,"ba","bv","bm");

    // Clear variables to be sure the are well reloaded
    clear ba bv bm
    
    // Load variables from file
    loadmatfile(fullfile(TMPDIR, "issue_15568.mat"));

    // Check values
    assert_checkequal(ba, baref);
    assert_checkequal(bv, bvref);
    assert_checkequal(bm, bmref);

end
