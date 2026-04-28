// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

load("SCI/modules/atoms/macros/atoms_internals/lib");
exec("SCI/modules/atoms/tests/unit_tests/atomsTestUtils.sce");
atomsRepositoryReset();

if isempty([ atomsRepositoryList("user") ; atomsRepositoryList("allusers")]) then

    rep1 = atomsCreateLocalRepositoryFromDescription(SCI+"/modules/atoms/tests/unit_tests/scene10.DESCRIPTION", "scene10");
    rep2 = atomsCreateLocalRepositoryFromDescription(SCI+"/modules/atoms/tests/unit_tests/scene11.DESCRIPTION", "scene11");

    if atomsRepositoryAdd(rep1,"user")     <> 1 then pause, end
    if atomsRepositoryAdd(rep2,"allusers") <> 1 then pause, end

    if or(atomsRepositoryList("user")     <> [rep1,"user"]) then pause, end
    if or(atomsRepositoryList("allusers") <> [rep2,"allusers"]) then pause, end

    if find( atomsRepositoryList("all") == [rep1]) == [] then pause, end
    if find( atomsRepositoryList("all") == [rep2]) == [] then pause, end

    if atomsRepositoryDel(rep1,"user") <> 1 then pause, end
    if atomsRepositoryDel(rep2,"allusers") <> 1 then pause, end

    if atomsRepositoryAdd( [rep1;rep2],"user") <> 2 then pause, end
    if or(atomsRepositoryList("user")     <> [rep1 "user";rep2 "user"]) then pause, end
    if or(atomsRepositoryList("allusers") <> []) then pause, end
    if atomsRepositoryDel([rep1;rep2],"user") <> 2 then pause, end

    if ~isempty([ atomsRepositoryList("user") ; atomsRepositoryList("allusers")]) then pause, end
end
