// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Pierre MARECHAL <pierre.marechal@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// <-- Non-regression test for bug 871 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/871
//
// <-- Short Description -->
//    The Semicolon operator does not work on functions called
//    without parenthesis on args '()'. For instance:
//
//    --> rand()         // OK
//    ans  =
//
//        0.2113249  
//
//    --> rand();         // OK
//    [NO OUTPUT]
//
//    --> rand            // OK
//     ans  =
//
//        0.7560439 
//
//    --> rand;          // BUG: the semicolon doesn't work!!!!
//     ans  =
//
//        0.7560439

dia_file = fullfile(TMPDIR,"bug871.dia");

diary(dia_file);
rand;
diary(dia_file, "close");

expected = ["";
			prompt()+"rand;";
			"";
			prompt()+"diary(dia_file, ""close"");"];

assert_checkequal(mgetl(dia_file), expected);
