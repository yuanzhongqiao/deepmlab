// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- ENGLISH IMPOSED -->

errmsg = ["end";
          "^~~^";
          "Error: 3.1->3.4 syntax error, unexpected end, expecting end of file"];
assert_checkerror("execstr([""function y=f(c)"" ; ""end"" ; ""end""])", errmsg);

errmsg = ["[1,2,3}";
          "      ^^";
          "Error: 1.7->1.8 syntax error, unexpected }"];
assert_checkerror("execstr(""[1,2,3}"")", errmsg);

errmsg = ["if then else end";
          "   ^~~~^";
          "Error: 1.4->1.8 syntax error, unexpected then"];
assert_checkerror("execstr(""if then else end"")", errmsg);

errmsg = ["select x, case if end";
          "               ^~^";
          "Error: 1.16->1.18 syntax error, unexpected if"];
assert_checkerror("execstr(""select x, case if end"")", errmsg);

errmsg = ["if (true) case 42 end";
          "          ^~~~^";
          "Error: 1.11->1.15 syntax error, unexpected case"];
assert_checkerror("execstr(""if (true) case 42 end"")", errmsg);

errmsg = ["function 42 end";
          "         ^~^";
          "Error: 1.10->1.12 syntax error, unexpected integer, expecting [ or identifier"];
assert_checkerror("execstr(""function 42 end"")", errmsg);
