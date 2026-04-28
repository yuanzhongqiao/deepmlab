// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent COUVERT 
// 
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

// This test check save and load functions used with uimenus
// The following functions are tested:
//  - SCI/modules/graphics/macros/%h_save.sci
//  - SCI/modules/graphics/macros/%h_load.sci

// Create an uimenu
f = scf(0);
h = uimenu("parent", f);
// Change value of each property to be sure it is saved and loaded correctly
h.enable = "off"; // Default is "on"
h.foregroundcolor = [1 1 1]; // Default is [0.0627451,0.0627451,0.0627451]
h.label = "My uimenu"; // Default is ""
h.visible = "off"; // Default is "on"
h.callback = "disp(1)"; // Default is ""
h.callback_type = 1; // Default is 0
h.tag = "My uimenu tag"; // Default is ""
h.tooltipstring = "My uimenu tooltipstring"; // Default is ""

// Save figure contents
save(TMPDIR + "/uimenu.scg", "h");

hsaved = h;
clear h;

// Load saved handle
load(TMPDIR + "/uimenu.scg");

// Check if properties are equal
assert_checkequal(h.enable, hsaved.enable);
assert_checkequal(h.foregroundcolor, hsaved.foregroundcolor);
assert_checkequal(h.label, hsaved.label);
assert_checkequal(h.visible, hsaved.visible);
assert_checkequal(h.callback, hsaved.callback);
assert_checkequal(h.callback_type, hsaved.callback_type);
assert_checkequal(h.tag, hsaved.tag);
assert_checkequal(h.tooltipstring, hsaved.tooltipstring);
