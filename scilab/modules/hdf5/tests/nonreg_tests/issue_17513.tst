// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17513 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17513
//
// <-- Short Description -->
// loadobj must receive the serialized payload returned by saveobj when
// reloading a classdef object saved in a SOD file.

classdef issue_17513
    properties
        a
        b
        gotStruct
    end

    methods
        function issue_17513(a, b)
            this.a = a;
            this.b = b;
            this.gotStruct = %f;
        end

        function st = saveobj()
            st = struct();
            st.a = this.a;
            st.b = this.b;
        end

        function loadobj(st)
            this.gotStruct = isstruct(st);
            if ~this.gotStruct then
                error("loadobj received wrong input type");
            end

            this.a = st.a;
            this.b = st.b;
        end
    end
end

sample = issue_17513(12, "toto");
filename = fullfile(TMPDIR, "issue_17513.sod");

save(filename, "sample");
clear sample;

load(filename);

assert_checkequal(sample.a, 12);
assert_checkequal(sample.b, "toto");
assert_checktrue(sample.gotStruct);

deletefile(filename);
clear sample;
