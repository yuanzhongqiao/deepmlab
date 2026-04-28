// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16064 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16064
//
// <-- Short Description -->
// tbx_make(Dir, "localization") = tbx_build_localization(Dir)
// never updated .mo files after changing .po files

dest = TMPDIR+"/bug_16064";
rmdir(dest, "s");
copyfile(SCI+"/contrib/toolbox_skeleton", dest);

tbx_make(dest, "localization");
addlocalizationdomain("toolbox_skeleton", dest+"/locales");
setlanguage fr;
assert_checkequal(_("toolbox_skeleton","Outline"), "Contour");

// Initial state of the .mo files:
fd = mopen(dest+"/locales/fr_FR/LC_MESSAGES/toolbox_skeleton.mo", "rb");
x0_fr = mgeti(4096, 'c', fd);
mclose(fd);
fd = mopen(dest+"/locales/en_US/LC_MESSAGES/toolbox_skeleton.mo", "rb");
x0_en = mgeti(4096, 'c', fd);
mclose(fd);

// We change the fr_FR.po translated file:
txt = mgetl(dest+"/locales/fr_FR.po");
txt(grep(txt, "msgid ""Outline""") + 1) = "msgstr ""CONTOUR""";
mputl(txt, dest+"/locales/fr_FR.po");
sleep(2, "s")

// Rebuild the toolbox:
tbx_make(dest, "localization");

// Updated state of the .mo files:
fd = mopen(dest+"/locales/fr_FR/LC_MESSAGES/toolbox_skeleton.mo", "rb");
x1_fr = mgeti(4096, 'c', fd);
mclose(fd);
fd = mopen(dest+"/locales/en_US/LC_MESSAGES/toolbox_skeleton.mo", "rb");
x1_en = mgeti(4096, 'c', fd);
mclose(fd);

// The fr_FR .mo file must have been updated:
assert_checkfalse(and(x1_fr == x0_fr));
// But not the en_US one:
assert_checktrue(and(x1_en == x0_en));

// to reload, copy the locales into a different directory
new_locales = dest + "/locales_edited";
copyfile(dest + "/locales", new_locales);
addlocalizationdomain("toolbox_skeleton", new_locales);
// the updated message is displayed
assert_checkequal(_("toolbox_skeleton","Outline"), "CONTOUR");

rmdir(dest,"s");
