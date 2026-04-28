// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 15790 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15790
//
// <-- Short Description -->
// The label of a datatip customized with polyline.display_function
// and created in a batch session opened with the -quit option is not rendered

// -quit option is used by test_run() when running test so test case given is issue report has been simplified

plot2d();
pl=gce().children(1);
function str = mytip(h)
    str = "issue 15790";
endfunction
pl.display_function = "mytip";
d = datatipCreate(pl, 50);
assert_checkequal(d.text, "issue 15790");
