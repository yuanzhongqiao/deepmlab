// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17339 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17339
//
// <-- Short Description -->
// insertion of string in table failed 

t = table(["A" ; "B" ; "A" ; "B"], ...
    ["%t" ; "%t" ; "%f" ; "%f"], ...
    ["" ; "" ; "" ; ""], ...
    "VariableNames", ["Categorie", "Value", "Comment"]);

t(t.Categorie == "A", :).Comment = "Check";

assert_checkequal(t.Comment, ["Check"; ""; "Check"; ""]);

t.Comment([2;4]) = "toto";
assert_checkequal(t.Comment, ["Check"; "toto"; "Check"; "toto"]);

t = timeseries(hours(1:4)', ...
    ["A" ; "B" ; "A" ; "B"], ...
    [1;2;3;4], ...
    ["%t" ; "%t" ; "%f" ; "%f"], ...
    ["" ; "" ; "" ; ""], ...
    "VariableNames", ["Time", "Categorie", "Value", "Boolean","Comment"]);

t(t.Categorie == "A", :).Comment = "Check";

assert_checkequal(t.Comment, ["Check"; ""; "Check"; ""]);

t.Comment([2;4]) = "toto";
assert_checkequal(t.Comment, ["Check"; "toto"; "Check"; "toto"]);