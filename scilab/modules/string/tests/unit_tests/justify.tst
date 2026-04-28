// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
//    Unitary tests of justify()

// https://gitlab.com/scilab/scilab/-/issues/12639
assert_checkequal(justify([], "l"), []);
assert_checkequal(justify([], "r"), []);
assert_checkequal(justify([], "c"), []);

//
assert_checkequal(justify("", "l"), "");
assert_checkequal(justify("", "r"), "");
assert_checkequal(justify("", "c"), "");

t = ["" ""];
assert_checkequal(justify(t, "l"), t);
assert_checkequal(justify(t, "r"), t);
assert_checkequal(justify(t, "c"), t);
assert_checkequal(justify(t', "l"), t');
assert_checkequal(justify(t', "r"), t');
assert_checkequal(justify(t', "c"), t');

assert_checkequal(justify(t'+" ", "l"), t');
assert_checkequal(justify(t'+"  ", "r"), t');
assert_checkequal(justify(t'+"   ", "c"), t');

t = ["" "a" "bc" "def"];
assert_checkequal(justify(t, "l"), t);
assert_checkequal(justify(t, "r"), t);
assert_checkequal(justify(t, "c"), t);

assert_checkequal(justify(t', "l"), ["   " "a  " "bc " "def"]');
assert_checkequal(justify(t', "r"), ["   " "  a" " bc" "def"]');
assert_checkequal(justify(t', "c"), ["   " " a " "bc " "def"]');

t = "  " + t' + "    ";
assert_checkequal(justify(t, "l"), ["   " "a  " "bc " "def"]');
assert_checkequal(justify(t, "r"), ["   " "  a" " bc" "def"]');
assert_checkequal(justify(t, "c"), ["   " " a " "bc " "def"]');

// Matrix
ref = ["abcd" "jk " "o    "
       "ef  " "   " "pqrst"
       "ghi " "lmn" "uvw  "];
m = stripblanks(ref);
assert_checkequal(justify(m), ref);
assert_checkequal(justify("  "+m+"   "), ref);

ref = ["abcd" " jk" "    o"
       "  ef" "   " "pqrst"
       " ghi" "lmn" "  uvw"];
assert_checkequal(justify(m, "r"), ref);
assert_checkequal(justify("  "+m+"   ", "r"), ref);

ref = ["abcd" "jk " "  o  "
       " ef " "   " "pqrst"
       "ghi " "lmn" " uvw "];
assert_checkequal(justify(m, "c"), ref);
assert_checkequal(justify("  "+m+"   ", "c"), ref);

// Hypermatrices: https://gitlab.com/scilab/scilab/-/issues/16868
m = ["abcd" "" ; "ef" "ghi" ; "klm" "op"];
h = cat(3, m, m);

hj = justify(h, "l");
ref = matrix(["abcd","ef  ","klm ","   ","ghi","op ","abcd","ef  ","klm ","   ","ghi","op "], [3,2,2]);
assert_checkequal(hj, ref);

hj = justify(h, "r");
ref = matrix(["abcd","  ef"," klm","   ","ghi"," op","abcd","  ef"," klm","   ","ghi"," op"], [3,2,2]);
assert_checkequal(hj, ref);

hj = justify(h, "c");
ref = matrix(["abcd"," ef ","klm ","   ","ghi","op ","abcd"," ef ","klm ","   ","ghi","op "], [3,2,2]);
assert_checkequal(hj, ref);
