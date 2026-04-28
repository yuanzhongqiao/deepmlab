// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->

tbx_package_workdir_test = TMPDIR + filesep() + "toolbox_skeleton";

assert_checkequal(copyfile("SCI/contrib/toolbox_skeleton", tbx_package_workdir_test), 1);

// build 
exec(tbx_package_workdir_test + filesep() + "builder.sce", -1);

// package
[package1, _, desc] = tbx_package(tbx_package_workdir_test);
assert_checkequal(typeof(desc), "st");
assert_checktrue(isfield(desc, "packages"));
assert_checktrue(isfield(desc.packages, "toolbox_skeleton"));

atomsInstall(package1);
assert_checktrue(atomsIsInstalled("toolbox_skeleton"));
atomsRemove("toolbox_skeleton");
assert_checkfalse(atomsIsInstalled("toolbox_skeleton"));

packaged_files1 = decompress(package1);
[path, fname, extension] = fileparts(packaged_files1);

// packaged files should not contains source files
if or(extension == ".c") then pause, end
if or(extension == ".cpp") then pause, end
if or(extension == ".java") then pause, end

// do not remove, rename and load it for testing
movefile(packaged_files1(1), "test_loading_" + packaged_files1(1));
test_loading_packaged_files1 = "test_loading_" + packaged_files1;
[path, fname, extension] = fileparts(test_loading_packaged_files1);
exec(test_loading_packaged_files1(extension == ".start"), 1);
deletefile(package1);

// package with a build number should produce the same files
package2 = tbx_package(tbx_package_workdir_test, "42")
packaged_files2 = decompress(package2);
rmdir(packaged_files2(1), "s");

assert_checkequal(packaged_files1, packaged_files2);
deletefile(package2);

// package with a lambda to remove tests
package3 = tbx_package(tbx_package_workdir_test, "without_tests", #(workdir) -> (rmdir(fullfile(workdir, "/tests"), "s")))
packaged_files3 = decompress(package3);
assert_checkequal(grep("tests", packaged_files3(1)), []);
rmdir(packaged_files3(1), "s");
deletefile(package3);
