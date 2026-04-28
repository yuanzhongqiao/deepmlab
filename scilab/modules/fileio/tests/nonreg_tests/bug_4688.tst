// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) DIGITEO - 2009 - Pierre MARECHAL
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4688 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4688
//
// <-- Short Description -->
// listfiles('/') returns an error.

if getos() <> 'Windows' then 
    ierr = execstr("listfiles(""/"");","errcatch");
    if ierr<>0 then pause, end
end
