// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

classdef test
    properties
        value = 0
    end

    methods
        function test(val)
            arguments
                val = 10;
            end

            this.value = val;
        end
    end
end

assert_checkequal(test().value, 10);
