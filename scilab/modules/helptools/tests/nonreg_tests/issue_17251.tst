// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 17251 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17251
//
// <-- Short Description -->
// The generated HTML help pages (in the jar) should be XML compliant.
//

if isfile("SCI/modules/helptools/jar/scilab_en_US_help.jar") then
    d = TMPDIR + "/issue_17251";

    assert_checkequal(mkdir(d), 1);
    files = decompress("SCI/modules/helptools/jar/scilab_en_US_help.jar", d);

    errors = [];
    for f=files'
        [path, fname, extension] = fileparts(f);
        if extension == ".html" then
            // will throw an error if the HTML is not XML compliant
            try
                xmlRead(f);
            catch
                e = lasterror();
                errors = [ errors ; fname+".xml" ; strcat(e, ascii(10)) ];
            end
        end
    end

    disp(errors)
    assert_checkequal(errors, []);
    assert_checkequal(rmdir(d, 's'), 1);
end
