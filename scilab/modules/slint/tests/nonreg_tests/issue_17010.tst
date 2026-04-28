// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17010 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17010
//
// <-- Short Description -->
// Slint was overwriting the configuration file.

slint_folder = fullfile(SCI, "modules/slint");
config_file = fullfile(slint_folder, "etc/slint.xml");
copyfile(config_file, TMPDIR);
configFile = fullfile(TMPDIR, "slint.xml");
out = slint(fullfile(slint_folder, "tests/unit_tests/files/slint_sample.sci"), configFile);
assert_checkequal(mgetl(config_file), mgetl(configFile));
