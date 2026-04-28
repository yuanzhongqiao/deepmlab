// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//<-- CLI SHELL MODE -->
//<-- NO CHECK REF -->

//interactive mode
clear a b
try
    a=1;
catch
    b=2+1;
end
assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 0);
assert_checkequal(a, 1);

clear a b
try  a=1+1;
catch
    b=2;
end

assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 0);
assert_checkequal(a, 2);

clear a b
try  a=1;
catch  b=2;
end
assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 0);
assert_checkequal(a, 1);

clear a b
try  a=1;catch  b=2;end
assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 0);
assert_checkequal(a, 1);

clear a b
try,  a=1;catch,  b=2;end
assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 0);
assert_checkequal(a, 1);


clear a b xxxx
try
    a=xxxx;
catch
    b=2;
end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);

clear a b xxxx
try   a=xxxx;
catch
    b=2;
end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);

clear a b xxxx
try
    a=xxxx;
catch b=2;
end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);

clear a b xxxx
try   a=xxxx;
catch b=2;
end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);


clear a b xxxx
try   a=xxxx;catch b=2;end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);

clear a b xxxx
assert_checktrue(execstr("try a=xxxx catch b=2;end","errcatch") == 0);
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);


clear a b xxxx
assert_checktrue(execstr("try a=1 catch b=2;end","errcatch") == 0);
assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 0);
assert_checkequal(a, 1);


clear a b xxxx

try,  a=xxxx;catch, b=2;end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);

clear a  xxxx
try a=xxxx;catch end
assert_checkequal(exists("a"), 0);

clear a  xxxx
try,  a=xxxx;end
assert_checkequal(exists("a"), 0);

clear a b xxxx
assert_checktrue(execstr("try;catch, b=2;end", "errcatch") > 0);
assert_checkequal(exists("b"), 0);

assert_checktrue(execstr("try,end", "errcatch") > 0);

clear a b xxxx
u=1;try,  a=xxxx;catch, b=2;end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);

clear a b xxxx
try, if %t then  a=xxxx;end;catch, b=2;end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);

//nested try catch
clear a b xxxx
try
    a=xxxx;
catch
    try
        b=xxx,
    catch
        b=2;
    end;
    b=b+1;
end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 3);

clear a b xxxx
try   a=xxxx;catch try b=xxx,catch b=2;end;end
assert_checkequal(exists("a"), 0);
assert_checkequal(exists("b"), 1);
assert_checkequal(b, 2);


clear a b xxxx
try a=2;try a=xxxx; catch a=a+1; end;catch;b=2;end
assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 0);
assert_checkequal(a, 3);


clear a b xxxx
try a=2;try a=xxxx; catch a=a+1; end;b=2;end
assert_checkequal(exists("a"), 1);
assert_checkequal(exists("b"), 1);
assert_checkequal(a, 3);
assert_checkequal(b, 2);

//catch in  functions
funcprot(0);
clear a b
deff("r=test()",[
"try"
"  a=1;"
"catch "
"  b=2+1;"
"end"
"r=exists(''a'')==0|exists(''b'')==1 "
"r=r|a<>1"])
assert_checkfalse(test());

deff("r=test()",[
"try  a=1;"
"catch "
"  b=2;"
"end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>1"])
assert_checkfalse(test());

deff("r=test()",[
"try  a=1;"
"catch  b=2;"
"end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>1"])
assert_checkfalse(test());

deff("r=test()",[
"try  a=1;catch  b=2;end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>1"])
assert_checkfalse(test());

deff("r=test()",[
"try,  a=1;catch,  b=2;end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>1"])
assert_checkfalse(test());

clear a b xxxx
deff("r=test()",[
"try"
"  a=xxxx;"
"catch "
"  b=2;"
"end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try a=xxxx;"
"catch "
"  b=2;"
"end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try"
"  a=xxxx;"
"catch b=2;"
"end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try a=xxxx;"
"catch b=2;"
"end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try a=xxxx;catch b=2;end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"if execstr(''try a=xxxx catch b=2;end'',''errcatch'')<>0 then pause,end"
"r=exists(''a'')==1|exists(''b'')==0 "])
assert_checkfalse(test());

deff("r=test()",[
"try a=xxxx catch b=2;end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checktrue(execstr("test()","errcatch")==0)

deff("r=test()",[
"if execstr(''try a=1 catch b=2;end'',''errcatch'')<>0 then pause,end"
"r=exists(''a'')==0|exists(''b'')==1 "])
assert_checkfalse(test());

deff("r=test()",[
"try a=1, catch b=2;end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>1"])
assert_checktrue(execstr("r=test()","errcatch")==0);
assert_checkfalse(r);

deff("r=test()",[
"try b=xxxx, catch a=1;end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>1"])
assert_checktrue(execstr("r=test()","errcatch")==0);
assert_checkfalse(r);

deff("r=test()",[
"try a=1 catch b=2;end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>1"])
assert_checktrue(execstr("r=test()","errcatch")==0);



deff("r=test()",[
"try,  a=xxxx;catch, b=2;end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try,  a=xxxx;catch end"
"r=exists(''a'')==1"])
assert_checkfalse(test());

deff("r=test()",[
"try,  a=1;end"
"r=exists(''a'')==0"
"r=r|a<>1"])
assert_checkfalse(test());


deff("r=test()",[
"try,  a=xxxx;end"
"r=exists(''a'')==1"])
assert_checkfalse(test());


assert_checktrue(execstr("deff(""r=test()"",[""try;catch, b=2;end"" ""r=exists(""""b"""")==1""])" ,"errcatch") <> 0);
assert_checktrue(execstr("deff(""r=test()"",[""try;end"" ""r=%f""])", "errcatch") <> 0);


deff("r=test()",[
"try, if %t then  a=xxxx,end;catch, b=2;end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

//nested try catch
deff("r=test()",[
"try   "
"  a=xxxx;"
"catch "
"  try "
"    b=xxx,"
"  catch "
"    b=2;"
"  end;"
"  b=b+1;"
"end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>3"])
assert_checkfalse(test());

deff("r=test()",[
"try   a=xxxx;catch try b=xxx,catch b=2;end;end"
"r=exists(''a'')==1|exists(''b'')==0"
"r=r|b<>2"])
assert_checkfalse(test());

deff("test()",["try a=2; try a=xxxx; catch a=a+1,end; catch;b=2;end"])
tree2code(macr2tree(test))

deff("r=test()",[
"try a=2;try a=xxxx+33; catch a=a+1,end;catch;b=2;end"
"r=exists(''a'')==0|exists(''b'')==1"
"r=r|a<>3"])
assert_checkfalse(test());


deff("r=test()",[
"try a=2;try a=xxxx; catch a=a+1,end;b=2;end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>3|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try a=2;if %t then try a=xxxx; catch a=a+1,end;end;b=2;end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>3|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try a=2;if %t then try a=xxxx; catch a=a+1,end;b=2;end;end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>3|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try a=2;try a=xxxx; catch if %t then a=a+1,end,end;b=2;end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>3|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"if %t then try a=2;try a=xxxx; catch a=a+1,end;b=2;end;end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>3|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"try a=2;try a=xxxx; catch for k=1:2,a=a+1,end,end;b=2;end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>4|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"for k=1:3,try a=2;if %t then try a=xxxx; catch a=a+1,end;end;b=2;end,end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>3|b<>2"])
assert_checkfalse(test());

deff("r=test()",[
"for k=1:3,try a=2;if %t then try a=xxxx; catch for k=1:2,a=a+1,end,end;end;b=2;end,end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>4|b<>2"])
assert_checkfalse(test());



deff("r=test()",[
"b=0;while b==0,try a=2;if %t then try a=xxxx; catch a=a+1,end;end;b=2;end,end"
"r=exists(''a'')==0|exists(''b'')==0"
"r=r|a<>3|b<>2"])
assert_checkfalse(test());


deff("b=test1()",[
"  try "
"    b=xxx,"
"  catch "
"    b=2;"
"  end;"])

deff("r=test()",[
"try"
"  a=xxxx;"
"catch"
"  b=test1()"
"  b=b+1"
"end"
"r=exists(''b'')==0"
"r=r|b<>3"])
assert_checkfalse(test());

