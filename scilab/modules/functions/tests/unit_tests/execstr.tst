// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->

execstr('a=1') // sets a=1.
if isdef('a')<> %t then pause,end
if a<> 1 then pause,end

execstr('1+1');
if evstr('1+1')<> 2 then pause,end

execstr(['if %t then';
         '  a=1';
         '  b=a+1';
         'else'
         ' b=0'
         'end'])

ierr = execstr('a=zzzzzzz','errcatch');
if ierr == 0 then pause,end

ierr = execstr('a=1?02','errcatch');
if ierr == 0 then pause,end

ierr = execstr('a=[1 2 3)','errcatch');
if ierr == 0 then pause,end

// variable1 does not exist
if execstr('variable1;','errcatch')<>0 then disp("Trigger an error"),end

// variable2 exists ... no error is triggered by execstr
variable2 = [2,3];
if execstr('variable2;','errcatch')<>0 then
   disp("Trigger an error");
else
   disp("execstr is happy");
end

// errormsg & callstack
[a b c] = execstr("acosd(""q"");", "errcatch");
assert_checktrue(a <> 0);
assert_checktrue(typeof(b) == "string");
assert_checktrue(length(b) <> 0);
assert_checktrue(typeof(c) == "string");
assert_checktrue(length(c) <> 0);
