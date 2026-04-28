// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - Calixte DENIZET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->

// <-- Non-regression test for bug 5436 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5436
//
// <-- Short Description -->
// The export to svg does not work with bar graphs.
// Blue triangles are placed over the yellow ones.

indexfirst = [
    0.3139532  
    0.4423253  
    8.086D-31  
]
indextotal = [
    0.5576747  
    0.4423255  
    0.2437215  
]
bar(indextotal,0.2,'blue');
bar(indexfirst,0.15,'yellow');
legend(["totale" "premier ordre"],pos=1);
xtitle("Fonction Ishigami - Indice de sensibilité");
xs2svg ( 0 , "export.svg" )
