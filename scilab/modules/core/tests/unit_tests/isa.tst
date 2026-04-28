// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

//<-- CLI SHELL MODE -->
//<-- NO CHECK REF -->

tests = list(...
    1, "str", int8(1), int16(1), int32(1), ...
    int64(1), uint8(1), uint16(1), uint32(1), uint64(1), ...
    %t, %s, list(1,2), tlist(["a", "b"], 1, 2), mlist(["a", "b"], 1, 2), ...
    sparse(1), sparse(%t), corelib, {1}, cos);

results = {"double" "string" "int8" "int16" "int32", ...
    "int64" "uint8" "uint16" "uint32" "uint64", ...
    ["bool" "boolean"] ["poly" "polynom" "polynomial"] "list" "tlist" "mlist" "sparse", ...
    ["bsparse" "booleansparse"] ["lib" "library"] ["ce" "cell"] ["function", "fptr" "builtin"] };

for i = 1:size(tests) //values
    for j = 1:size(tests) //types
        if i == j then
            for k = 1:size(results{j}, "*")
                //disp(tests(i))
                //disp(results{j}(k))
                //printf("\n");
                assert_checktrue(isa(tests(i), results{j}(k)));
            end
        else
            for k = 1:size(results{j}, "*")
                printf("%d %d %d\n", i, j, k);
                assert_checkfalse(isa(tests(i), results{j}(k)));
            end
        end
    end
end

//some other tests
assert_checktrue(isa(int8(1), "int"));
assert_checktrue(isa(int8(1), "integer"));
assert_checktrue(isa(int8(1), "signed"));

assert_checktrue(isa(int16(1), "int"));
assert_checktrue(isa(int16(1), "integer"));
assert_checktrue(isa(int16(1), "signed"));

assert_checktrue(isa(int32(1), "int"));
assert_checktrue(isa(int32(1), "integer"));
assert_checktrue(isa(int32(1), "signed"));

assert_checktrue(isa(int64(1), "int"));
assert_checktrue(isa(int64(1), "integer"));
assert_checktrue(isa(int64(1), "signed"));

assert_checktrue(isa(uint8(1), "int"));
assert_checktrue(isa(uint8(1), "integer"));
assert_checktrue(isa(uint8(1), "unsigned"));

assert_checktrue(isa(uint16(1), "int"));
assert_checktrue(isa(uint16(1), "integer"));
assert_checktrue(isa(uint16(1), "unsigned"));

assert_checktrue(isa(uint32(1), "int"));
assert_checktrue(isa(uint32(1), "integer"));
assert_checktrue(isa(uint32(1), "unsigned"));

assert_checktrue(isa(uint64(1), "int"));
assert_checktrue(isa(uint64(1), "integer"));
assert_checktrue(isa(uint64(1), "unsigned"));

//object
classdef test
    methods
        function test()
        end
    end
end
a = test();
assert_checktrue(isa(a, "object"));
assert_checktrue(isa(a, "test"));
