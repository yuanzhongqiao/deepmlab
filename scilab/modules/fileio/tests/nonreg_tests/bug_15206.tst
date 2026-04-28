// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- WINDOWS ONLY -->
//
// <-- Non-regression test for bug 15206 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15206
//
// <-- Short Description -->
// wrong writing with mput

filename = fullfile(TMPDIR,'test.bin');
fid = mopen(filename,'w+');
mput (int16([1:10]), 's', fid ) ;
offset = mtell(fid) ;
mclose(fid);
deletefile(filename);
assert_checkequal(offset,20);

