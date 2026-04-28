// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Pierre-Aimé AGNEL
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK ERROR OUTPUT -->
// <-- ENGLISH IMPOSED -->

// Test the compilation of a simple toolbox with tbx_make()
// Copying the testing toolbox from the test environment
function reset_test_module(source, destDir)
    if isdir(destDir)
        removedir(destDir);
    end
    status = copyfile(source, destDir);
    assert_checkequal(status, 1);
endfunction

// Testing default overall compilation (all sections)
// --------------------------------------------------
// 1)
source = SCI + "/modules/modules_manager/tests/tbx/foobox/";
mytb_dir = TMPDIR + "/foobox";
reset_test_module(source, mytb_dir);
tbx_make(mytb_dir);

exec(mytb_dir + "/loader.sce");
b = foo("testing it works", 42);
baz("World");
assert_checktrue(b);

// 2)
source = SCI + "/modules/modules_manager/tests/tbx/testbox/";
mytb_dir = TMPDIR + "/testbox";
reset_test_module(source, mytb_dir);
tbx_make(mytb_dir);

exec(mytb_dir + "/loader.sce");
b = csum6(2, 40);
assert_checkequal(b, 42);

