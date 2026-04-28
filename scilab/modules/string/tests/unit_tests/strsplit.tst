// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2007-2008 - INRIA
// Copyright (C) 2009 - DIGITEO - Allan CORNET
// Copyright (C) 2014 - Scilab Enterprises - Anais AUBERT
// Copyright (C) 2021 - Samuel GOUGEON
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

//===============================
// unit tests strsplit
//===============================
STR_SPLITED = ["strsplit splits";"a string";"into";"a vector of strings"];
STR = "strsplit splits a string into a vector of strings";
INDICES = [15 25 30];
R = stripblanks(strsplit(STR,INDICES));
assert_checkequal(R, STR_SPLITED);
assert_checkequal(strsplit([],[1 1 1]), []);
assert_checkequal(strsplit([],[3 2 1]), []);
assert_checkequal(execstr("strsplit('''',[0 1])","errcatch"), 999);
assert_checkequal(execstr("strsplit([])","errcatch"), 0);
assert_checkequal(strsplit([]), []);
//===============================
ref_1 = ["toto"];
ref_2 = [];
[r_1, r_2] = strsplit("toto","a");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
// request 663
ref_1 = ["a";"b";"c";"d";"e";"f"];
ref_2 = ["";"";"";"";"";""];
[r_1, r_2] = strsplit("abcdef");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
assert_checkequal(strcat(r_1, ""), "abcdef");
//===============================
[r_1, r_2] = strsplit("abcdef","");
[r_3, r_4] = strsplit("abcdef");
assert_checkequal(r_1, r_3);
assert_checkequal(r_2, r_4);
//===============================
ref_1 = ["a";"bcdef"];
ref_2 = [""];
[r_1, r_2] = strsplit("abcdef","",1);
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
assert_checkequal(strcat(r_1,""), "abcdef");
//===============================
ref_1 = ["abcdef";"ghijkl";"mnopqr";"stuvw";"xyz"];
ref_2 = [",";",";",";","];
[r_1, r_2] = strsplit("abcdef,ghijkl,mnopqr,stuvw,xyz",",");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
assert_checkequal(strcat(r_1,","), "abcdef,ghijkl,mnopqr,stuvw,xyz");
//===============================
ref_1 = ["abc";"";"";"def";"";"ghijkl";"";"mno"];
ref_2 = [":";":";":";":";":";":";":"];
[r_1, r_2] = strsplit("abc:::def::ghijkl::mno",":");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
assert_checkequal(strcat(r_1,":"), "abc:::def::ghijkl::mno");
//===============================
ref_1  = ["abcdef";"ghijkl";"mnopqr";"stuvw";"xyz"];
ref_2  = ["~~~";"~~~";"~~~";"~~~"] ;
[r_1, r_2] = strsplit("abcdef~~~ghijkl~~~mnopqr~~~stuvw~~~xyz","~~~");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
assert_checkequal(strcat(r_1,"~~~"), "abcdef~~~ghijkl~~~mnopqr~~~stuvw~~~xyz");
//===============================
ref_1 = ["abcdef";"ghijkl";"mnopqr";"stuvw";"xyz"];
ref_2 = ["2";"3";"6";"7"];
[r_1, r_2] = strsplit("abcdef2ghijkl3mnopqr6stuvw7xyz","/\d+/");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
ref_2 = ["scilab";"scilab"];
ref_1 = ["";" a numerical tools ";"oraty"];
[r_1, r_2] = strsplit("scilab a numerical tools scilaboraty","/scilab/");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
ref_1  = ["abcdef";"ghijkl";"mnopqr";"stuvw";"xyz"];
ref_2  = [ascii(9);ascii(9);ascii(9);ascii(9)];
[r_1, r_2] = strsplit("abcdef"+ascii(9)+"ghijkl" + ascii(9)+"mnopqr"+ascii(9)+"stuvw" + ascii(9)+"xyz","/\t/") ;
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
assert_checkequal(strcat(r_1,ascii(9)), "abcdef" + ascii(9) + "ghijkl" + ascii(9) + "mnopqr" + ascii(9) + "stuvw" + ascii(9) + "xyz");
//===============================
ref_1  = ["server.name";"scilab.org"];
ref_2  = "       = ";
linestr = "server.name       = scilab.org";
[r_1, r_2] = strsplit(linestr, "/\s*=\s*/");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
assert_checkequal(strcat(r_1,r_2), "server.name       = scilab.org");
//===============================
ierr = execstr("strsplit(''root:x:0:0:root:/root:/bin/bash'','':'',0)","errcatch");
assert_checkequal(ierr, 999);
//===============================
ref_1 = ["root";"x:0:0:root:/root:/bin/bash"];
ref_2 = ":";
[r_1, r_2] = strsplit("root:x:0:0:root:/root:/bin/bash",":",1);
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
ref_1 = ["root";"x";"0";"0";"root";"/root:/bin/bash"];
ref_2 = [":";":";":";":";":"];
[r_1, r_2] = strsplit("root:x:0:0:root:/root:/bin/bash",":",5);
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
[r_1, r_2] = strsplit("root:x:0:0:root:/root:/bin/bash",":",7);
[r_3, r_4] = strsplit("root:x:0:0:root:/root:/bin/bash",":",50);
assert_checkequal(r_1, r_3);
assert_checkequal(r_2, r_4);

//=================================
// Haystack ending with the pattern
// ================================
ref_1 = ["abc";""];
ref_2 = ",";
[r_1, r_2] = strsplit("abc,",",");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//-------------------------------
ref_1 = ["abc";""];
ref_2 = ",";
[r_1, r_2] = strsplit("abc,",",",1);
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//-------------------------------
[r_1, r_2] = strsplit("abc,",",",1);
[r_3, r_4] = strsplit("abc,",",",10);
assert_checkequal(r_1, r_3);
assert_checkequal(r_2, r_4);
//-------------------------------
// https://gitlab.com/scilab/scilab/-/issues/16686
r = strsplit("c","c")
assert_checkequal(r, ["";""]);
r = strsplit("cd","cd")
assert_checkequal(r, ["";""]);
r = strsplit("cd",["ab" "cd"])
assert_checkequal(r, ["";""]);
r = strsplit("cc","c")
assert_checkequal(r, ["";"";""]);
r = strsplit("abcd","cd");
assert_checkequal(r, ["ab";""]);
r = strsplit("abcd","cd",2);
assert_checkequal(r, ["ab";""]);
r = strsplit("abcdcd","cd");
assert_checkequal(r, ["ab";"";""]);
r = strsplit("abcdcd","cd",1);
assert_checkequal(r, ["ab";"cd"]);
r = strsplit("cdcd","cd")
assert_checkequal(r, ["";"";""]);
//-------------------------------

//===============================
ref_1 = ["abc";"def";"ijk";"";"lmo"];
ref_2 = [",";":";",";":"];
[r_1, r_2] = strsplit("abc,def:ijk,:lmo","/:|,/");
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
ref_1 = ["abc";"def";"ijk";"";"lmo"];
ref_2 = [",";":";",";":"];
[r_1, r_2] = strsplit("abc,def:ijk,:lmo",[":";","]);
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
ref_1 = ["abc";"def";"ijk,:lmo"];
ref_2 = [",";":"];
[r_1, r_2] = strsplit("abc,def:ijk,:lmo",[":";","],2);
assert_checkequal(ref_1, r_1);
assert_checkequal(ref_2, r_2);
//===============================
v = "世界您好";
c = "您";
[r_1,r_2] = strsplit(v,c);
assert_checkequal(strcat(r_1,r_2), v);
//===============================
v = "азеаея";
c = "з";
[r_1,r_2] = strsplit(v,c);
assert_checkequal(strcat(r_1,r_2), v);
//===============================
v = "ድቅስድስግ";
c = "ቅ";
[r_1,r_2] = strsplit(v,c);
assert_checkequal(strcat(r_1,r_2), v);
//===============================
v = "ハロー・ワールド";
c = "ド";
[r_1,r_2] = strsplit(v,c);
assert_checkequal(strcat(r_1,r_2), v);
//===============================
v = "תוכנית";
c = "י";
[r_1,r_2] = strsplit(v,c);
assert_checkequal(strcat(r_1,r_2), v);
//===============================
// splitting a multi-line text
text = strcat(STR_SPLITED, ascii(10));
assert_checkequal(strsplit(text, ascii(10)), STR_SPLITED);
// with regexp
text = strcat(STR_SPLITED, ascii(10));
assert_checkequal(strsplit(text, "/(*ANYCRLF)\n/"), STR_SPLITED);

//After PCRE2 migration, strsubst and strsplit were not escaping $ properly.
// single char search
assert_checkequal(strsplit("this is a $string$", "$"), ["this is a ";"string";""]);
// string search
assert_checkequal(strsplit("this is a $€£string$€£", "$€£"), ["this is a ";"string";""]);
// string pattern search
assert_checkequal(strsplit("this is a $€£string$€£", "/\$€£/"), ["this is a ";"string";""]);
// multi-string search (will trigger the overload and convert to a regexp)
assert_checkequal(strsplit("this is a $€£string$€£", ["$€£" " "]), ["this";"is";"a";"";"string";""]);
