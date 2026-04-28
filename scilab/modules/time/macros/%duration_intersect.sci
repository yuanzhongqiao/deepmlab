// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [out, ka, kb] = %duration_intersect(varargin)
    in = varargin;
    out = varargin(1);

    in(1) = out.duration;
    in(2) = varargin(2).duration;

    [a, ka, kb] = intersect(in(:));

    out.duration = a;
endfunction
