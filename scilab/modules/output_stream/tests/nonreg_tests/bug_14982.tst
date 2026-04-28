// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2017 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 14982 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14982
//
// <-- Short Description -->
// passing incorrect arguments to msprintf (too many data with respect to the
// format) made Scilab crash

z=[-1.7;-1.7];
wn=[1;1];
msprintf(_("Compensator pole\nDamping: %.3g\nNatural pulsation: %.3grd/s"),z,wn)

