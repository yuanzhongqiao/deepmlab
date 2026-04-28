// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- ENGLISH IMPOSED -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- TEST WITH ATOMS -->

// Override official repository for test purpose
rep = atomsCreateLocalRepositoryFromDescription(SCI+"/modules/atoms/tests/unit_tests/sample.DESCRIPTION", "sample");
atomsRepositorySetOfl(rep);

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
