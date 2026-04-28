// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16149 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16149
//
// <-- Short Description -->
// fullpath does not support symbolic links

cd(TMPDIR)
mkdir("testdir")
if getos() <> "Windows" then
    host("ln -sf "+TMPDIR+"/testdir tmp");
else
    host("mklink /j tmp "+TMPDIR+"\testdir");
end

// symbolic link
assert_checkequal(fullpath("tmp/hello.txt"),strcat([TMPDIR "testdir" "hello.txt"], filesep()));

// symbolic link (recursive)
assert_checkequal(fullpath("tmp/../tmp/hello.txt"),strcat([TMPDIR "testdir" "hello.txt"], filesep()));

// delete the symbolic link
if getos() <> "Windows" then
    deletefile("tmp");
else
    host("rmdir tmp");
end

// raw path when tmp is not a symbolic link
assert_checkequal(fullpath("tmp/hello.txt"),strcat([TMPDIR "tmp" "hello.txt"], filesep()));
assert_checkequal(fullpath("tmp/../tmp/hello.txt"),strcat([TMPDIR "tmp" "hello.txt"], filesep()));
assert_checkequal(fullpath("tmp/tmp/../../hello.txt"),strcat([TMPDIR "hello.txt"], filesep()));

