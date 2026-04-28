// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->

ierr = execstr("a=zzzzzzz", "errcatch");

assert_checkequal(lasterror(), msprintf(_("Undefined variable: %s\n"), "zzzzzzz"));

ierr = execstr("a=zzzzzzz", "errcatch");

[str, n] = lasterror();

assert_checkequal(str, msprintf(_("Undefined variable: %s\n"), "zzzzzzz"));

ierr = execstr("a=zzzzzzz", "errcatch");

[str, n, l] = lasterror();

assert_checkequal(l, 1);
assert_checkequal(str, msprintf(_("Undefined variable: %s\n"), "zzzzzzz"));

ierr = execstr("a=zzzzzzz", "errcatch");

[str, n, l, f] = lasterror();

assert_checkequal(l, 1);
assert_checkequal(f, 'execstr');
assert_checkequal(str, msprintf(_("Undefined variable: %s\n"), "zzzzzzz"));

ierr = execstr("a=zzzzzzz", "errcatch");
[str2, n2, l2, f2] = lasterror(%f);
assert_checkequal(n2, n);
assert_checkequal(l2, l);
assert_checkequal(f2, f);
assert_checkequal(str2, str);

[str3, n3, l3, f3] = lasterror(%t);
assert_checkequal(n3, n2);
assert_checkequal(l3, l2);
assert_checkequal(f3, f2);
assert_checkequal(str3, str2);

[str4, n4, l4, f4] = lasterror(%t);
assert_checkequal(n4, 0);
assert_checkequal(l4, 0);
assert_checkequal(f4, '');
assert_checkequal(str4, []);


ierr = execstr('a = lasterror(2);','errcatch');
assert_checkequal(ierr, 999);


ierr = execstr('a = lasterror([%t, %f]);','errcatch');
assert_checkequal(ierr, 999);


function test()
    subtest();
end

function subtest()
    error("lasterror test");
end

execstr("test()", "errcatch");
[str5, n5, l5, f5] = lasterror();
assert_checkequal(str5, "lasterror test");
assert_checkequal(n5, 10000);
assert_checkequal(l5, 2);
assert_checkequal(f5, "subtest");