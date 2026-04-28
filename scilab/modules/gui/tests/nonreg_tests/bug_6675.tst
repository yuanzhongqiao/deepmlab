// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

//
// <-- Non-regression test for bug 6675 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/6675
//
// <-- Short Description -->
// x_mdialog crashed scilab with some incorrect input arguments


ierr = execstr("x_mdialog(''toto'',[''titi'';''tata''],''plop'')","errcatch");
if ierr <> 999 then pause,end

ierr = execstr("x_mdialog(''toto'',[''titi'';''tata''],[''plop'',''re''])","errcatch");
if ierr <> 999 then pause,end
