// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16883 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16883
// <-- Short Description -->
// After h=cat(3, [1 2], [3 4]), mprintf("%d %d\n", h); crashes Scilab (idem with msprintf())

h=cat(3, [1 2], [3 4]);

refMsg = msprintf(_("Function not defined for given argument type(s),\n"));

funcMsg = msprintf(_("  check arguments or define function %s for overloading.\n"), "%hm_mprintf");
assert_checkerror("mprintf(""%d %d\n"", h);", [refMsg; funcMsg]);

funcMsg = msprintf(_("  check arguments or define function %s for overloading.\n"), "%hm_msprintf");
assert_checkerror("msprintf(""%d %d\n"", h);", [refMsg; funcMsg]);

funcMsg = msprintf(_("  check arguments or define function %s for overloading.\n"), "%hm_mfprintf");
assert_checkerror("mfprintf(1, ""%d %d\n"", h);", [refMsg; funcMsg]);

