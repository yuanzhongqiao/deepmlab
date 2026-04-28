// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for bug 7924 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7924
//
// <-- Short Description -->
//  pathconvert failed conversion to cygwin format.
//

if getos() == "Windows" then
  sciPath = WSCI;
else
  sciPath = SCI;
end

r1 = pathconvert(sciPath + "/etc/scilab.start", %F, %T, "u");
r2 = pathconvert("SCI/etc/scilab.start", %F, %T, "u");
if r1 <> r2 then pause, end
