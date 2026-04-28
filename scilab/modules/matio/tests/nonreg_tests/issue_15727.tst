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
// <-- Non-regression test for issue 15727 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15727
//
// <-- Short Description -->
// savematfile() for a cell or structure including some booleans yields an error

caref = {%t};
cvref = {%t, %f, %t};
cmref = {%t, %f, %t; %f, %t, %f};
cmatref = {[%t, %f, %t; %f, %t, %f]};

stref.a = %t;
stref.v = [%t, %f, %t];
stref.m = [%t, %f, %t; %f, %t, %f];
stref.ce = {[%t, %f, %t; %f, %t, %f]};

for filever = ["-v6", "-v7", "-v7.3"]

    // Init variables to be saved
    ca = caref;
    cv = cvref;
    cm = cmref;
    cmat = cmatref;
    st = stref;

    // Save variables
    savematfile(fullfile(TMPDIR, "issue_15727.mat"), filever, "ca", "cv", "cm", "cmat", "st");

    // Clear variables to be sure the are well reloaded
    clear ca cv cm cmat st
    
    // Load variables from file
    loadmatfile(fullfile(TMPDIR, "issue_15727.mat"));

    // Check values
    assert_checkequal(ca, caref);
    assert_checkequal(cv, cvref);
    assert_checkequal(cm, cmref);
    assert_checkequal(cmat, cmatref);
    assert_checkequal(st, stref);

end
