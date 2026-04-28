// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for nat function
// =============================================================================


function nat_checkstring(in, str)
    assert_checkequal(%datetime_string(in), str)
endfunction

nat_checkstring(NaT(), "NaT");
nat_checkstring(NaT(1), "NaT");
nat_checkstring(NaT(1, 1), "NaT");
nat_checkstring(NaT(1, 2), ["NaT", "NaT"]);
nat_checkstring(NaT(2, 1), ["NaT"; "NaT"]);
nat_checkstring(NaT(2, 2), ["NaT" "NaT"; "NaT" "NaT"]);

dt1 = NaT(3, 3);
dt1(1:4:9) = datetime(2022, 1, 1);
nat_checkstring(dt1, ["2022-01-01" "NaT" "NaT"; "NaT" "2022-01-01" "NaT"; "NaT" "NaT" "2022-01-01"]);

// with outputformat
dt2 = NaT(2, 2, "OutputFormat", "dd/MM/yyyy");
nat_checkstring(dt2, ["NaT" "NaT"; "NaT" "NaT"]);
dt2([1 4]) = datetime("2022-12-31");
nat_checkstring(dt2, ["31/12/2022" "NaT"; "NaT" "31/12/2022"]);

// isnat
assert_checktrue(isnat(NaT()));
assert_checktrue(isnat(NaT(1)));
assert_checktrue(isnat(NaT(3, 3)));
assert_checkequal(isnat(dt1), [%f %t %t; %t %f %t; %t %t %f]);
assert_checktrue(isnat(NaT(2, 2, "OutputFormat", "dd/MM/yyyy")));
assert_checkequal(isnat(dt2), [%f %t; %t %f]);

// error
msg = msprintf(_("%s: Wrong number of input argument: %d to %d expected.\n"), "NaT", 1, 4);
assert_checkerror("NaT(2022, 10, 1, 2, 3)", msg);
msg = msprintf(_("%s: Wrong value for input argument #%d: ""%s"" expected.\n"), "NaT", 3, "OutputFormat");
assert_checkerror("NaT(2022, 10, 1, 2)", msg);
assert_checkerror("NaT(2022, 10, ""toto"", 2)", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"), "NaT", 4);
assert_checkerror("NaT(2022, 10, ""OutputFormat"", 2)", msg);

msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "isnat", 1);
assert_checkerror("isnat()", msg);
msg = msprintf(_("Wrong number of input arguments.\n"));
assert_checkerror("isnat(NaT(1), NaT(2))", msg);
msg = msprintf(_("Wrong number of output arguments.\n"));
assert_checkerror("[r,b] = isnat(NaT(1,2));", msg);
