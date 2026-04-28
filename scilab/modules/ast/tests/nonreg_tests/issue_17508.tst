// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17508 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17508
//
// <-- Short Description -->
// Wrong callstack in object method

classdef Issue_17508
    properties
        line,
        name
    end
    methods
        function Issue_17508_meth()
            [this.line, this.name] = where();
        end
    end
end
a = Issue_17508();
a.Issue_17508_meth();
assert_checkequal(a.name(1), "Issue_17508_meth");
assert_checkequal(a.line(1), 2);