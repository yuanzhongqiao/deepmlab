// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17496 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17496
//
// <-- Short Description -->
// reload a classdef may crash Scilab

classdef A
    properties
        x = 1
    end
end

classdef B < A
    properties
        x = 2
        z = 12
    end
end

b = B();
z = b.z;

classdef B < A
    properties
        x = 10
    end
end

assert_checkequal(b.x, 2);
msg = sprintf(_("Attempt to reference field of non-structure array.\n"));
assert_checkerror("b.z", msg);
