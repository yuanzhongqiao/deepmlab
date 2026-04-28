// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2016 - Scilab Enterprises - Clement David
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

//<-- CLI SHELL MODE -->
//<-- NO CHECK REF -->

// parse all the macros in core
funs = libraryinfo("corelib");
for i=1:size(funs, "*")
    macr2tree(evstr(funs(i)));
end

// parse all the tests in ast
parsing_tests = ls("SCI/modules/ast/tests/unit_tests/*.tst");
for i=1:size(parsing_tests, "*")
    test = parsing_tests(i);

    //avoid lambda not managed by macr2tree
    if strstr(test, "lambda.tst") <> "" then
        continue;
    end

    text = mgetl(test);
    deff("[] = macr2tree_fun()",text);
    macr2tree(macr2tree_fun);
    clear macr2tree_fun;
end

