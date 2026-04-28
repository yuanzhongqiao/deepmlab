// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
function res = test_arrayfun(f, M)
    res = [];
    for k = 1:size(M, '*')
        res($ + 1) = f(M(k))
    end
end

function res = test_concatSize(M)
    f = #(x) -> (size(x, '*'))
    res = test_arrayfun(f, M)
end

reportDir = fullfile(TMPDIR, "coverage");
reportFile = "test_concatSize.html"

covStart(test_concatSize)
test_concatSize(rand(1,5))
test_concatSize({[1,2,3], rand(5,5), {1,"2"}})
test_concatSize("hello")
covWrite("html", reportDir)
covStop()

txt = mgetl(fullfile(reportDir, reportFile))