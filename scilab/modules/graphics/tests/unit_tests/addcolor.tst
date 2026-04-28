// ===================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Vincent COUVERT
//
// This file is distributed under the same license as the Scilab package.
// ===================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

assert_checkerror("addcolor([]);", msprintf(_("%s: Wrong type for input argument #%d: Real vector nx3 expected.\n"), "addcolor", 1));

assert_checkerror("addcolor([255 255 255]);", msprintf(_("%s: Wrong value for input argument #%d: Must be between 0.0 and 1.0.\n"), "addcolor", 1));

// Test index returned for black 
assert_checkequal(addcolor([0 0 0]), 1);

// Re-add current colormap: indices must be 1:size(cmap, 1) 
assert_checkequal(addcolor(gcf().color_map), 1:32);
assert_checkequal(size(gcf().color_map, 1), 32); 

// Add jet() colors: Color are added after existing colormap
assert_checkequal(addcolor(jet(32)), 33:64);
assert_checkequal(size(gcf().color_map, 1), 64); 

// Re-Add jet() colors: same indices are returned
assert_checkequal(addcolor(jet(32)), 33:64);
assert_checkequal(size(gcf().color_map, 1), 64); 
