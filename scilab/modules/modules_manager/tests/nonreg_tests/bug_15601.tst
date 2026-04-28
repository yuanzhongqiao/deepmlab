// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - ESI-Group - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
// avoid check of xgettext warnings
// <-- NO CHECK ERROR OUTPUT -->
//
// <-- Non-regression test for bug 15601 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15601
//
// <-- Short Description -->
// tbx_generate_pofile(..) fails generating the file when the toolbox absolute path has some spaces, or when the toolbox has no XML files

dest = TMPDIR+"/test space";
copyfile(SCI+"/contrib/toolbox_skeleton", dest);
assert_checkequal(tbx_generate_pofile(dest), fullfile(TMPDIR, "test space/locales/en_US.po"));
removedir(dest);
