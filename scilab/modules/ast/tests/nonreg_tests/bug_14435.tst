// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 14435 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14435
//
// <-- Short Description -->
// Errors not well handled in overloaded functions

t = tlist(["user","x"],0);
m = mlist(["user","x"],0);

message = [msprintf(_("Function not defined for given argument type(s),\n")); msprintf(_("  check arguments or define function %s for overloading.\n"), "%l_e")];
assert_checkerror("t.z",message);
assert_checkerror("m.z",message);
assert_checkerror("t(""z"")",message);
assert_checkerror("m(""z"")",message);

function varargout = %user_e(i,x)
    if or(i==["a" "b"])
        varargout(1) = i + "1"
        varargout(2) = i + "2"
        return;
    end

    if i == "no_output" then
        return;
    end

    error(msprintf("Error: field %s is undefined !",i));
end

assert_checkequal(t.a, "a1");
assert_checkequal(t("a"), "a1");

message = "Error: field z is undefined !";
assert_checkerror("t.z",message);
assert_checkerror("m.z",message);
assert_checkerror("t(""z"")",message);
assert_checkerror("m(""z"")",message);

msg = msprintf(_("%ls: Extraction must have at least one output.\n"), "%user_e");
assert_checkerror("t.no_output", msg);
assert_checkerror("t(""no_output"")", msg);


// check call without defined overload
t = tlist(["useruseruser","x"],0);
message = [msprintf(_("Function not defined for given argument type(s),\n")); msprintf(_("  check arguments or define function %s for overloading.\n"), "%l_e")];
assert_checkerror("t.z", message);

// call a function that returns an error 
// and check that the list extraction return the good error about overload
function test(), error("error !"), end;
execstr("test();", "errcatch");
assert_checkerror("t.z", message);

// check truncated overload call (Scilab 5 compatibility)
// call without error
function ret=%useruser_e(varargin), ret=2, end;
assert_checkequal(t.z, 2);
// call with error
function ret=%useruser_e(varargin), error("overload 8 char ERR"),ret=2, end;
assert_checkerror("t.z", "overload 8 char ERR");

// check overload call
function ret=%useruseruser_e(varargin), ret=42, end
assert_checkequal(t.z, 42);
function ret=%useruseruser_e(varargin), error("overload 12 char ERR"),ret=42, end;
assert_checkerror("t.z", "overload 12 char ERR");
