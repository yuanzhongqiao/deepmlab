//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->


tab_ref = [
"азеазея",
"เฮลโลเวิลด์",
"حريات وحقوق",
"תוכנית"];


for i = 1:size(tab_ref, "*");
    targetFile = TMPDIR + filesep() + "README_" + tab_ref(i);
    myFile = http_get("https://gitlab.com/scilab/scilab/-/raw/minor/README.md?ref_type=heads", targetFile);
    assert_checkequal(targetFile, myFile);
    assert_checkequal(isfile(targetFile), %t);
end
