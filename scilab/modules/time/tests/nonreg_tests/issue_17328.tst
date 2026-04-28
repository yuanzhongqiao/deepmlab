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
// <-- Non-regression test for issue 17328 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17328
//
// <-- Short Description -->
// datetime("2024-10-29T07:45:59.898Z", "InputFormat","yyyy-MM-ddTHH:mm:ss.SSSZ") returned an error

d = datetime("2024-10-29T07:45:59.898Z", "InputFormat", "yyyy-MM-ddTHH:mm:ss.SSSZ");
assert_checkequal(d, datetime(2024, 10, 29, 7, 45, 59.898));

d = datetime("2024-10-29T07:59:59.898Z", "InputFormat", "yyyy-MM-ddTHH:mm:ss.SSSZ");
assert_checkequal(d, datetime(2024, 10, 29, 7, 59, 59.898));

d = datetime("2024-10-29T23:59:59.898Z", "InputFormat", "yyyy-MM-ddTHH:mm:ss.SSSZ");
assert_checkequal(d, datetime(2024, 10, 29, 23, 59, 59.898));

d = datetime("2024-10-29T07:59", "InputFormat", "yyyy-MM-ddTHH:mm");
assert_checkequal(d, datetime(2024, 10, 29, 7, 59, 0));

d = datetime("2024-10-29T23:59", "InputFormat", "yyyy-MM-ddTHH:mm");
assert_checkequal(d, datetime(2024, 10, 29, 23, 59, 0));
