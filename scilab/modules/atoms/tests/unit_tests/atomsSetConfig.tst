// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Simon GARESTE <simon.gareste@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- TEST WITH ATOMS -->

// Start config
// =============================================================================
ref=struct("useProxy", "False","autoloadAddAfterInstall","False","Verbose","False");
assert_checkequal(atomsGetConfig(), ref);

// CamelCase test
// =============================================================================
ref=struct("useProxy", "False","autoloadAddAfterInstall","False","Verbose","True");
assert_checkequal(string(atomsSetConfig("Verbose","True")),"1");
assert_checkequal(atomsGetConfig(),ref);
assert_checkequal(string(atomsSetConfig("verbose","true")),"0");
assert_checkequal(atomsGetConfig(),ref);
assert_checkequal(string(atomsSetConfig("verbose","True")),"0");
assert_checkequal(atomsGetConfig(),ref);
assert_checkequal(string(atomsSetConfig("Verbose","true")),"0");
assert_checkequal(atomsGetConfig(),ref);
assert_checkequal(string(atomsSetConfig("Verbose","True")),"0");
assert_checkequal(atomsGetConfig(),ref);

// Wrong key/value test
// =============================================================================
assert_checkerror("atomsSetConfig(""verbose"",""scilab"")","scilab: Wrong value for input configuration argument: True or False expected.");
assert_checkequal(atomsGetConfig(),ref);
assert_checkerror("atomsSetConfig(""scilab"",""true"")","scilab: Wrong key for input configuration argument.");
assert_checkequal(atomsGetConfig(),ref);

// Exhaustive key list test
// =============================================================================
ref=struct("useProxy","False",..
"proxyUser","scilab",..
"proxyPort","42",..
"proxyPassword","scilab",..
"proxyHost","myproxy",..
"offline","False",..
"autoloadAddAfterInstall","False",..
"autoload","True",..
"Verbose","True");

assert_checkequal(string(atomsSetConfig("useProxy","False")),"0");
assert_checkequal(string(atomsSetConfig("proxyHost","myproxy")),"1");
assert_checkequal(string(atomsSetConfig("proxyPort","42")),"1");
assert_checkequal(string(atomsSetConfig("proxyUser","scilab")),"1");
assert_checkequal(string(atomsSetConfig("proxyPassword","scilab")),"1");
assert_checkequal(string(atomsSetConfig("offline","False")),"1");
assert_checkequal(string(atomsSetConfig("autoload","True")),"1");
assert_checkequal(atomsGetConfig(),ref);
