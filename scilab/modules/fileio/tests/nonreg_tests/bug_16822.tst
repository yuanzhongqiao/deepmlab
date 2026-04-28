// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16822 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16822
//
// <-- Short Description -->
// getrelativefilename returns incorrect value in case of same beginning of directory names


if getos() == "Windows"
    relpath = getrelativefilename(TMPDIR + '\scilab\bin', TMPDIR + '\scilabX\modules\helptools\readme.txt');
    assert_checkequal(relpath,"..\..\scilabX\modules\helptools\readme.txt")
else
    relpath = getrelativefilename(TMPDIR + '/scilab/bin', TMPDIR + '/scilabX/modules/helptools/readme.txt');
    assert_checkequal(relpath,"../../scilabX/modules/helptools/readme.txt")
end