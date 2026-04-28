//
// Scilab ( http://www.scilab.org// ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------
// adapted from https://github.com//SciML//DiffEqDevTools.jl//blob//master//src//ode_tableaus.jl

function out = %SUN_DormandPrince6()
    A = zeros(8, 8)
    c = zeros(8,1)
    α = zeros(1,8)
    αEEst = zeros(1,8)

    c(2) = 1 / 10
    c(3) = 2 / 9
    c(4) = 3 / 7
    c(5) = 3 / 5
    c(6) = 4 / 5
    c(7) = 1
    c(8) = 1
    A(2, 1) = 1 / 10
    A(3, 1) = -2 / 81
    A(3, 2) = 20 / 81
    A(4, 1) = 615 / 1372
    A(4, 2) = -270 / 343
    A(4, 3) = 1053 / 1372
    A(5, 1) = 3243 / 5500
    A(5, 2) = -54 / 55
    A(5, 3) = 50949 / 71500
    A(5, 4) = 4998 / 17875
    A(6, 1) = -26492 / 37125
    A(6, 2) = 72 / 55
    A(6, 3) = 2808 / 23375
    A(6, 4) = -24206 / 37125
    A(6, 5) = 338 / 459
    A(7, 1) = 5561 / 2376
    A(7, 2) = -35 / 11
    A(7, 3) = -24117 / 31603
    A(7, 4) = 899983 / 200772
    A(7, 5) = -5225 / 1836
    A(7, 6) = 3925 / 4056
    A(8, 1) = 465467 / 266112
    A(8, 2) = -2945 / 1232
    A(8, 3) = -5610201 / 14158144
    A(8, 4) = 10513573 / 3212352
    A(8, 5) = -424325 / 205632
    A(8, 6) = 376225 / 454272
    A(8, 7) = 0
    α(1) = 61 / 864
    α(2) = 0
    α(3) = 98415 / 321776
    α(4) = 16807 / 146016
    α(5) = 1375 / 7344
    α(6) = 1375 / 5408
    α(7) = -37 / 1120
    α(8) = 1 / 10
    αEEst(1) = 821 / 10800
    αEEst(2) = 0
    αEEst(3) = 19683 / 71825
    αEEst(4) = 175273 / 912600
    αEEst(5) = 395 / 3672
    αEEst(6) = 785 / 2704
    αEEst(7) = 3 / 50
    αEEst(8) = 0
    out = [c A
           6 α
           5 αEEst]
end
