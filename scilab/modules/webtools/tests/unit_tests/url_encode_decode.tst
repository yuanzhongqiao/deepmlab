// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020-2023 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// Unitary tests for url_encode() and url_decode()

assert_checkequal(url_encode([]), []);
assert_checkequal(url_encode(""), "");

url = "µ€T%Â";
ref = "%C2%B5%E2%82%ACT%25%C3%82";
assert_checkequal(url_encode(url), ref);
assert_checkequal(url_decode(ref), url);

url = "µزあ字"; // greck, arabic, japanese, chinese
ref = "%C2%B5%D8%B2%E3%81%82%E5%AD%97";
assert_checkequal(url_encode(url), ref);
assert_checkequal(url_decode(ref), url);

url = " +-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_~";
ref = "%20%2B-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_~";
assert_checkequal(url_encode(url), ref);
assert_checkequal(url_decode(ref), url);

url = "https://abc.org/joël/test.php?r=3&c=30%&q=%t";
ref = "https%3A%2F%2Fabc.org%2Fjo%C3%ABl%2Ftest.php%3Fr%3D3%26c%3D30%25%26q%3D%25t";
assert_checkequal(url_encode(url), ref);
assert_checkequal(url_decode(ref), url);

assert_checkequal(url_decode("ab%F46"), "abô6");

// Sizes
// -----
url = ["a"      "â"     "à"       " "   "%"
       "ë"      "é"     "e"       "~"   "+" ];
ref = ["a"      "%C3%A2" "%C3%A0" "%20" "%25"
       "%C3%AB" "%C3%A9" "e"      "~" "%2B" ];
assert_checkequal(url_encode(url), ref);
assert_checkequal(url_decode(ref), url);

// ERRORS MESSAGES
// ---------------
msg = sprintf(_("%s: Argument #%d(%d): Wrong character encoding.\n"), "url_decode", 1, 2);
assert_checkerror("url_decode([""ab%301"" ""a%G34""])", msg);
assert_checkerror("url_decode([""ab%301"" ""a%3G4""])", msg);
