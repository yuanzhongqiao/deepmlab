// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2014 - Scilab Enterprises - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH ATOMS -->
// <-- CLI SHELL MODE -->
// <-- LINUX ONLY -->
// <-- NO CHECK REF -->
// <-- INTERACTIVE TEST -->
//
// <-- Non-regression test for bug 13674 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/13674
//
// <-- Short Description -->
// atomsSystemUpdate() failed if USER has it's own wgetrc config file
// using proxy settings

// Save user .wgetrc file for test
restoreUserConfig = %f;
if isfile("~/.wgetrc") then
    copyfile("~/.wgetrc", "~/.wgetrc.bak");
    restoreUserConfig = %t;
end

fd = mopen("~/.wgetrc", "w+");
mputl("use_proxy = on", fd);
mputl("http_proxy = https://proxy_name:1234/", fd);
mputl("https_proxy = https://proxy_name:1234/", fd);
mputl("ftp_proxy = https://proxy_name:1234/", fd);
mclose(fd);

status = atomsGetConfig("useProxy");
atomsSetConfig("useProxy", "False");

atomsSystemUpdate();

// Restore values
atomsSetConfig("useProxy", status);
if restoreUserConfig then
    copyfile("~/.wgetrc.bak", "~/.wgetrc");
else
    mdelete("~/.wgetrc");
end
