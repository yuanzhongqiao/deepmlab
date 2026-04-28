// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS

// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = %table_gsort(t, varargin)
    tt = t.vars(1).data;

    [_, idx] = gsort(tt, varargin(:));

    varargout(1) = t(idx, :);
    varargout(2) = idx;
endfunction
