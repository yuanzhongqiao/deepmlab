// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// empty
assert_checkequal(fromJSON("{}"), struct());
assert_checkequal(fromJSON("[]"), []);
assert_checkequal(fromJSON(""""""), "");

// number
assert_checkequal(fromJSON("1.23"), 1.23);
assert_checkequal(fromJSON("[1,2,3]"), [1,2,3]);
assert_checkequal(fromJSON("[[1],[2],[3]]"), [1;2;3]);
assert_checkequal(fromJSON("[[1,2,3], [4,5,6]]"), [1,2,3; 4,5,6]);
assert_checkequal(fromJSON("[[[1,3,5],[2,4,6]], [[7,9,11],[8,10,12]]]"), matrix(1:12, [2, 3, 2]));
assert_checkequal(fromJSON("[1e+30, 1e-30]"), [1e+30, 1e-30]);
assert_checkequal(fromJSON("[NaN, Infinity, -Infinity]"), [%nan, %inf, -%inf]);

// bool
assert_checkequal(fromJSON("true"), %t);
assert_checkequal(fromJSON("false"), %f);
assert_checkequal(fromJSON("[true, false]"), [%t, %f]);

// string
assert_checkequal(fromJSON("""∀"""), "∀");
assert_checkequal(fromJSON("""foo"""), "foo");
assert_checkequal(fromJSON(""""+SCI+""""), SCI);
assert_checkequal(fromJSON("[""f"", ""o"", ""o""]"), ["f","o","o"]);

// struct
assert_checkequal(fromJSON("{""array"": [1,2,3]}"), struct("array", [1,2,3]));
assert_checkequal(fromJSON("{""array"": [1,2,3], ""bool"": true, ""path"": """+SCI+"""}"), struct("array", [1,2,3], "bool", %t, "path", SCI));
expected = list(struct("bool", %t), struct("path", SCI), struct("array", [1,2,3]));
computed = fromJSON("[{""bool"": true}, {""path"": """+SCI+"""}, {""array"": [1,2,3]}]");
assert_checkequal(computed, expected);
st = struct("bool", %t, "path", SCI, "array", [1,2,3]);
expected = [st,st;st,st];
computed = fromJSON("[[{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""},{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}],[{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""},{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}]]");
assert_checkequal(computed, expected);
// change one field name
expected = list([st,st], list(st, st));
expected(2)(2).test = 42;
expected(2)(2).path = null();
computed = fromJSON("[[{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""},{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}],[{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""},{""array"":[1,2,3],""bool"":true,""test"":42}]]");
assert_checkequal(computed, expected);
// add an extra field
expected = list(list(st, st), [st,st]);
expected(1)(2).test = 42;
computed = fromJSON("[[{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""},{""test"":42,""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}],[{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""},{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}]]");
assert_checkequal(computed, expected);
// remove one field
expected = list([st,st], list(st, st));
expected(2)(1).path = null();
computed = fromJSON("[[{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""},{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}],[{""array"":[1,2,3],""bool"":true},{""array"":[1,2,3],""bool"":true,""path"":"""+SCI+"""}]]");
assert_checkequal(computed, expected);
// empty field name
expected = struct("", 42);
computed = fromJSON("{"""":42}");
assert_checkequal(computed, expected);
expected = struct("", struct("value",42));
computed = fromJSON("{"""":{""value"":42}}");
assert_checkequal(computed, expected);

// null
assert_checkequal(fromJSON("[null, 1, 2]"), [%nan, 1, 2]);
assert_checkequal(fromJSON("[1, 2, null]"), [1, 2, %nan]);

assert_checkequal(fromJSON("null"), []);
assert_checkequal(fromJSON("[null]"), %nan);
assert_checkequal(fromJSON("{""f"": null}"), struct("f", []));
assert_checkequal(fromJSON("{""f"": [null]}"), struct("f", %nan));
assert_checkequal(fromJSON("[1, ""toto"", null]"), list(1, "toto", []));
assert_checkequal(fromJSON("[1, null, ""toto""]"), list(1, [], "toto"));
assert_checkequal(fromJSON("[null, 1, ""toto""]"), list([], 1, "toto"));
assert_checkequal(fromJSON("[null, ""toto"", 1]"), list([], "toto", 1));
assert_checkequal(fromJSON("[null, ""1"", ""2""]"), list([], "1", "2"));
assert_checkequal(fromJSON("[""1"", ""2"", null]"), list("1", "2", []));
assert_checkequal(fromJSON("[true, false, null]"), list(%t, %f, []));

// mixed array, type and size differ
assert_checkequal(fromJSON("[1, ""string"", true]"), list(1, "string", %t));
assert_checkequal(fromJSON("[[1], [""string""], [true]]"), list(1, "string", %t));
assert_checkequal(fromJSON("[[1,2,3],""string""]"), list([1,2,3], "string"));
assert_checkequal(fromJSON("[[[1],2,3],""string""]"), list(list(1,2,3), "string"));
assert_checkequal(fromJSON("[1,2,""string"", {""path"":"""+SCI+"""}]"), list(1, 2, "string", struct("path", SCI)));
expected = list([1,2,3;4,5,6], list(list(7, "8", 9),[10,11,12]), [%f,%t,%t;%t,%t,%f]);
computed = fromJSON("[[[1,2,3], [4,5,6]],[[7, ""8"", 9],[10, 11, 12]], [[false, true, true],[true, true, false]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], list(["7", "8", "9"],[10,11,12]), [%f,%t,%t;%t,%t,%f]);
computed = fromJSON("[[[1,2,3], [4,5,6]],[[""7"", ""8"", ""9""],[10, 11, 12]], [[false, true, true],[true, true, false]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], "7", "8", "9");
computed = fromJSON("[[[1,2,3], [4,5,6]],""7"", ""8"", ""9""]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], ["7", "8", "9"]);
computed = fromJSON("[[[1,2,3], [4,5,6]],[""7"", ""8"", ""9""]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], ["7","8","9";"10","11","12"], [%f,%t,%t;%t,%t,%f]);
computed = fromJSON("[[[1,2,3], [4,5,6]],[[""7"", ""8"", ""9""],[""10"", ""11"", ""12""]], [[false, true, true],[true, true, false]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], [10,11,12]);
computed = fromJSON("[[[1,2,3], [4,5,6]], [10,11,12]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], [10,11]);
computed = fromJSON("[[[1,2,3], [4,5,6]], [10,11]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], [70,80,90;20,30,50;10,20,30], [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]);
computed = fromJSON("[[[1,2,3],[4,5,6]],[[70,80,90],[20,30,50],[10,20,30]],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], [7,8,9;2,3,5], [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]);
computed = fromJSON("[[[1,2,3],[4,5,6]],[[7,8,9],[2,3,5]],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], list([7,8,9], []), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]);
computed = fromJSON("[[[1,2,3],[4,5,6]],[[7,8,9],[]],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], list([1,2,3], [4,5,6,7]));
computed = fromJSON("[[[1,2,3], [4,5,6]], [[1,2,3], [4,5,6,7]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], list([1,2,3], [4,5]));
computed = fromJSON("[[[1,2,3], [4,5,6]], [[1,2,3], [4,5]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], list([7,8,9], "string"), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]);
computed = fromJSON("[[[1,2,3],[4,5,6]],[[7,8,9],""string""],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], "string", [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]);
computed = fromJSON("[[[1,2,3],[4,5,6]],[""string""],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
computed = fromJSON("[[[1,2,3],[4,5,6]],""string"",[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], struct("field", %t), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]);
computed = fromJSON("[[[1,2,3],[4,5,6]],{""field"": true},[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
computed = fromJSON("[[[1,2,3],[4,5,6]],[{""field"": true}],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);
expected = list([1,2,3;4,5,6], list([7,8,9], struct()), [13,14,15;16,17,18], [19,20,21;22,23,24], [25,26,27]);
computed = fromJSON("[[[1,2,3],[4,5,6]],[[7,8,9],{}],[[13,14,15],[16,17,18]],[[19,20,21],[22,23,24]],[[25,26,27]]]");
assert_checkequal(computed, expected);

// error
msgerr = msprintf(_("%s: %s\n"), "fromJSON", "Missing a closing quotation mark in string at offset 15");
assert_checkerror("fromJSON(""[""""tt"""",""""yy"""",""""ee]"")", msgerr);
msgerr = msprintf(_("%s: %s\n"), "fromJSON", "Missing a comma or '']'' after an array element at offset 46 near `}]`");
assert_checkerror("fromJSON(""[{""""msg"""":""""hello!""""}, {""""val"""":42}, {""""array"""":[1,2,3}]"")", msgerr);
msgerr = msprintf(_("%s: %s\n"), "fromJSON", "Missing a name for object member at offset 1 near `no_quote: `");
assert_checkerror("fromJSON(""{no_quote: 42}"")", msgerr);
msgerr = msprintf(_("%s: %s\n"), "fromJSON", "Invalid value at offset 13 near `string}`");
assert_checkerror("fromJSON(""{""""no_quote"""": string}"")", msgerr);