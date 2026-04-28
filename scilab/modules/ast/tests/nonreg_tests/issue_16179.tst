// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 16179 -->
//
// <-- INTERACTIVE TEST -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16179
//
// <-- Short Description -->
// pause inhibits error display when executed in try-catch block

// execute the following line
// try, pause, end

// then execute abort

// the next line must display the error
// error("This should report an error!")
