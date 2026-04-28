// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// empty
assert_checkequal(toJSON(struct()), "{}");
assert_checkequal(toJSON([]), "[]");
assert_checkequal(toJSON(""), """""");

// number
assert_checkequal(toJSON(1.23), "1.23");
assert_checkequal(toJSON([1,2,3.3]), "[1,2,3.3]");
assert_checkequal(toJSON(int8([1,2,3])), "[1,2,3]");
assert_checkequal(toJSON([1;2;3]), "[[1],[2],[3]]");
assert_checkequal(toJSON([1,2,3; 4,5,6]), "[[1,2,3],[4,5,6]]");
assert_checkequal(toJSON(matrix(1:12, [2, 3, 2])), "[[[1,3,5],[2,4,6]],[[7,9,11],[8,10,12]]]");
assert_checkequal(toJSON([1e30, 1e-30]), "[1e30,1e-30]");
assert_checkequal(toJSON([[%nan, 1]; [1e+380, 1e-380]; [%inf, -%inf]], convertInfAndNaN=%t), "[[null,1],[null,0],[null,null]]");
assert_checkequal(toJSON([[%nan, 1]; [1e+380, 1e-380]; [%inf, -%inf]], convertInfAndNaN=%f), "[[NaN,1],[Infinity,0],[Infinity,-Infinity]]");

// bool
assert_checkequal(toJSON(%t), "true");
assert_checkequal(toJSON(%f), "false");
assert_checkequal(toJSON([%t, %f]), "[true,false]");

// string
assert_checkequal(toJSON("∀"), """∀""");
assert_checkequal(toJSON("foo"), """foo""");
assert_checkequal(toJSON(SCI), """"+SCI+"""");
assert_checkequal(toJSON(["f","o","o"]), "[""f"",""o"",""o""]");

// struct
assert_checkequal(toJSON(struct("array", [1,2,3])), "{""array"":[1,2,3]}");
assert_checkequal(toJSON(struct("array", [1,2,3], "bool", %t, "path", SCI)), "{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}");
st = struct("bool", %t);
st(2).path = SCI;
st(3).array = [1,2,3];
assert_checkequal(toJSON(st'), "[{""bool"":true,""path"":[],""array"":[]},{""bool"":[],""path"":"""+SCI+""",""array"":[]},{""bool"":[],""path"":[],""array"":[1,2,3]}]");
l = list(struct("array", [1,2,3]), struct("bool", %t), struct("path", SCI));
assert_checkequal(toJSON(l), "[{""array"":[1,2,3]},{""bool"":true},{""path"":"""+SCI+"""}]");

// mixed array, type and size differ
assert_checkequal(toJSON(list(1, "string", %t)), "[1,""string"",true]");
assert_checkequal(toJSON(list(list(1), list("string"), list(%t))), "[[1],[""string""],[true]]");
assert_checkequal(toJSON(list([1,2,3], "string")), "[[1,2,3],""string""]");
assert_checkequal(toJSON(list(list(list(1),2,3), "string")), "[[[1],2,3],""string""]");
assert_checkequal(toJSON(list(1, 2, "string", struct("path", SCI))), "[1,2,""string"",{""path"":"""+SCI+"""}]");
computed = toJSON(list([1,2,3;4,5,6], list(list(7, "8", 9),[10,11,12]), [%f,%t,%t;%t,%t,%f]));
expected = "[[[1,2,3],[4,5,6]],[[7,""8"",9],[10,11,12]],[[false,true,true],[true,true,false]]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list(["7", "8", "9"],[10,11,12]), [%f,%t,%t;%t,%t,%f]));
expected = "[[[1,2,3],[4,5,6]],[[""7"",""8"",""9""],[10,11,12]],[[false,true,true],[true,true,false]]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6],"7","8","9"));
expected = "[[[1,2,3],[4,5,6]],""7"",""8"",""9""]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], ["7", "8", "9"]));
expected = "[[[1,2,3],[4,5,6]],[""7"",""8"",""9""]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], ["7","8","9";"10","11","12"], [%f,%t,%t;%t,%t,%f]));
expected = "[[[1,2,3],[4,5,6]],[[""7"",""8"",""9""],[""10"",""11"",""12""]],[[false,true,true],[true,true,false]]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], [10,11,12]));
expected = "[[[1,2,3],[4,5,6]],[10,11,12]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], [10,11]));
expected = "[[[1,2,3],[4,5,6]],[10,11]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], [70,80,90;20,30,50;10,20,30], [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],[[70,80,90],[20,30,50],[10,20,30]],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], [7,8,9;2,3,5], [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],[[7,8,9],[2,3,5]],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list([7,8,9], []), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],[[7,8,9],[]],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list([1,2,3], [4,5,6,7])));
expected = "[[[1,2,3],[4,5,6]],[[1,2,3],[4,5,6,7]]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list([1,2,3], [4,5])));
expected = "[[[1,2,3],[4,5,6]],[[1,2,3],[4,5]]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list([7,8,9], "string"), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],[[7,8,9],""string""],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list("string"), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],[""string""],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], "string", [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],""string"",[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], struct("field", %t), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],{""field"":true},[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list(struct("field", %t)), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],[{""field"":true}],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);
computed = toJSON(list([1,2,3;4,5,6], list([7,8,9], struct()), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]));
expected = "[[[1,2,3],[4,5,6]],[[7,8,9],{}],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[25,26,27]]";
assert_checkequal(computed, expected);

