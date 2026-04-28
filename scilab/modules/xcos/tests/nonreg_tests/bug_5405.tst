/ =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- INTERACTIVE TEST -->
// <-- XCOS TEST -->
//
// <-- Non-regression test for bug 5405 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/5405
//
// <-- Short Description -->
// If one modify a superblock, the main diagram is not updated while all the 
// modified superblock and intermediate superblocks are closed



// xcos(SCI + '/modules/xcos/demos/Discrete-KalmanFilter.zcos');
// Open a superblock
// modify something inside (links or whatever you want)
// check that the simulation results differs



