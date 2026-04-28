// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// problem at save with compression since matio 1.5.12
// also disabled in savematfile.tst
//
// <-- Non-regression test for issue 15730 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15730
//
// <-- Short Description -->
// matfile_listvar() and loadmatfile() crash Scilab when the file contains some structure saved in version < 7.3

function test_issue_15730(produitref)
    for filever = ["-v6", "-v7", "-v7.3"]

        // Init variables to be saved
        produit = produitref;
    
        // Save variables
        savematfile(fullfile(TMPDIR, "issue_15730.mat"), filever, "produit");
    
        // Clear variables to be sure the are well reloaded
        clear produit
        
        // Load variables from file
        loadmatfile(fullfile(TMPDIR, "issue_15730.mat"));
    
        // Check values
        assert_checkequal(produit, produitref);
    
        // Test now with matfile_listvar() even if it is redundant with previous tests
        fd = matfile_open(fullfile(TMPDIR, "issue_15730.mat"), "r");
        [names, classes, types] = matfile_listvar(fd);
        matfile_close(fd);
        assert_checkequal(names, "produit");
    
    end
endfunction

// First test case in reported issue
prod = struct("type", "logiciel", "age", 30);
test_issue_15730(prod);

// Second test case in reported issue
prod = struct("age", 30, "type", "logiciel");
test_issue_15730(prod);

// Third test case in reported issue
prod = struct("age", 30, "type", "logiciel", "name", "Scilab");
test_issue_15730(prod);