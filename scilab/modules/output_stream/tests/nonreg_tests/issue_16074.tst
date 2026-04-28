// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 16074 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16074
//
// <-- Short Description -->
// msprintf("%ld\n",i) and mprintf("%ld\n",i) append some "d" for int64 or uint64 inputs

i = int64(2).^int64(grand(3,5,"uin",0,60))
mprintf("%ld\n",i(:))
for j = int64(1:60)
    mprintf("%ld\n", int64(2).^j);
end
ui = uint64(2).^uint64(grand(3,5,"uin",0,60))
mprintf("%lu\n", ui(:))
