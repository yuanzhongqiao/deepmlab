// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [out, ka, kb] = %datetime_intersect(varargin)
    in = varargin;
    out = varargin(1);
    n = 24 * 60 *60;

    in(1) = out.date * n + out.time;
    in(2) = varargin(2).date * n + varargin(2).time;

    [a, ka, kb] = intersect(in(:));
    
    out.date = floor(a ./ n);
    out.time = modulo(a, n);
endfunction
