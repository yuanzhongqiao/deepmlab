// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17502 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17502
//
// <-- Short Description -->
// Extraction on variable from temporary objects crashes Scilab

classdef object
    properties
        var = []
    end

    methods
        function object(var)
            this.var = var
        end

        function b = extract(i, j)
            b = object(this.var(i, j))
        end

        function a = test()
            a = sum(this.var);
        end
    end
end

a = object([1 2; 3 4]);
v = a(2,2).var; // gave segmentation fault
assert_checkequal(v, 4);
t = a(2,2).test;
assert_checkequal(t(), 4);



