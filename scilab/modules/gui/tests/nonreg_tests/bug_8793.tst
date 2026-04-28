// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for bug 8793 -->
//
// <-- TEST WITH GRAPHIC -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8793
//
// <-- Short Description -->
// 'waitbar' function crashes when the handle is not initialized.

winId=waitbar("This is an example");
realtimeinit(0.3);

for j=0:0.1:1,
  realtime(3*j);
  waitbar(j,winId);
end

delete(winId);

if execstr("waitbar(1,winId);", "errcatch")==0 then pause; end
if execstr("waitbar(""This is an example"",winId);", "errcatch")==0 then pause; end
