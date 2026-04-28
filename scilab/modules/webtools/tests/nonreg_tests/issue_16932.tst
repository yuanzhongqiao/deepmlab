// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 16849 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16932
//
// <-- Short Description -->
//   toJSON() does not escape TABs properly

str = "string" + ascii(9) + "with" + ascii(9) + "tabs";

//string
json = toJSON(str);
str2 = fromJSON(json);
assert_checkequal(ascii(str), ascii(str2));

//string in struct
json = toJSON(struct("foo", str));
str2 = fromJSON(json);
assert_checkequal(ascii(str), ascii(str2.foo));

//string in list
json = toJSON(list(1, str));
str2 = fromJSON(json);
assert_checkequal(ascii(str), ascii(str2(2)));

//string in fieldname
json = toJSON(struct(str, 1));
str2 = fromJSON(json);
assert_checkequal(ascii(str), ascii(fieldnames(str2)));

// check all characters to escape
invalidJSONChar = ["0022"    // \"
                   "005C"    // \\
                   "002F"    // \/
                   "0008"    // \b
                   "000C"    // \f
                   "000A"    // \n
                   "000D"    // \r
                   "0009"];  // \t

for u=invalidJSONChar'
    disp("checking char U+"+u);
    str = "str with char U+"+u+" as "+ascii(hex2dec(u));
    
    json = toJSON(str)
    str2 = fromJSON(json)
    assert_checkequal(ascii(str), ascii(str2));
    
    //string in struct
    json = toJSON(struct("foo", str))
    str2 = fromJSON(json)
    assert_checkequal(ascii(str), ascii(str2.foo));
    
    //string in list
    json = toJSON(list(1, str))
    str2 = fromJSON(json)
    assert_checkequal(ascii(str), ascii(str2(2)));
    
    //string in fieldname
    json = toJSON(struct(str, 1))
    str2 = fromJSON(json)
    assert_checkequal(ascii(str), ascii(fieldnames(str2)));
end

str = "this is a JSON string";
for u=invalidJSONChar'
    str = str + ", with char U+"+u+" as "+ascii(hex2dec(u));
end

json = toJSON(str)
str2 = fromJSON(json)
assert_checkequal(ascii(str), ascii(str2));

//string in struct
json = toJSON(struct("foo", str))
str2 = fromJSON(json)
assert_checkequal(ascii(str), ascii(str2.foo));

//string in list
json = toJSON(list(1, str))
str2 = fromJSON(json)
assert_checkequal(ascii(str), ascii(str2(2)));

//string in fieldname
json = toJSON(struct(str, 1))
str2 = fromJSON(json)
assert_checkequal(ascii(str), ascii(fieldnames(str2)));
