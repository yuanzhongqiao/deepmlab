// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17208 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17208
//
// <-- Short Description -->
// Using surf with "LineStyle" option set to "none" does not draw anything (surface is hidden).

Z= [0.0001    0.0013    0.0053   -0.0299   -0.1809   -0.2465   -0.1100   -0.0168   -0.0008   -0.0000
    0.0005    0.0089    0.0259   -0.3673   -1.8670   -2.4736   -1.0866   -0.1602   -0.0067    0.0000
    0.0004    0.0214    0.1739   -0.3147   -4.0919   -6.4101   -2.7589   -0.2779    0.0131    0.0020
   -0.0088   -0.0871    0.0364    1.8559    1.4995   -2.2171   -0.2729    0.8368    0.2016    0.0130
   -0.0308   -0.4313   -1.7334   -0.1148    3.0731    0.4444    2.6145    2.4410    0.4877    0.0301
   -0.0336   -0.4990   -2.3552   -2.1722    0.8856   -0.0531    2.6416    2.4064    0.4771    0.0294
   -0.0137   -0.1967   -0.8083    0.2289    3.3983    3.1955    2.4338    1.2129    0.2108    0.0125
   -0.0014   -0.0017    0.3189    2.7414    7.1622    7.1361    3.1242    0.6633    0.0674    0.0030];

surf(Z, "LineStyle", "none"); 

// Check properties
assert_checkequal(gce().surface_mode, "on");
assert_checkequal(gce().color_mode, -1);