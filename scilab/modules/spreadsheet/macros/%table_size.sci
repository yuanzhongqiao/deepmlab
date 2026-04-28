// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = %table_size(varargin)
    rows = size(varargin(1).vars(1).data, 1);
    cols = size(varargin(1).vars, "*");

    select nargout
    case {0,1}
        if nargin == 1 then
            varargout(1) = [rows cols];
        else
            select varargin(2)
            case "r"
                varargout(1) = rows;
            case 1
                varargout(1) = rows;
            case "c"
                varargout(1) = cols;
            case 2
                varargout(1) = cols;
            case "*"
                varargout(1) = rows * cols;
            end
        end
    case 2
        varargout(1) = rows;
        varargout(2) = cols;
    end
endfunction
