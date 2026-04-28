// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 7181 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7181
//
// <-- Short Description -->
// The display of a struct having no fields does not work.

// Create a struct
s = struct("txt","Hello","num",%pi,"pol",%z^2+1);

// Remove all fields
s.txt = null();
s.num = null();
s.pol = null();

s