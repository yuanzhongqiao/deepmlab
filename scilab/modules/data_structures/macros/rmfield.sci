// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E - Vincent COUVERT
//
// For more information, see the COPYING file which you should have received
// along with this program.

function st = rmfield(st, fields)
    arguments
        st {mustBeA(st, "struct")}
        fields {mustBeA(fields, ["empty", "string", "cell"])} 
    end

    if iscell(fields) then
        if ~iscellstr(fields) && ~isempty(fields) then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A string matrix or a cell of strings expected.\n"), "rmfield", 2));
        end
        fields = cell2mat(fields(:));
    end

    for i = 1:size(fields, "*")
        if isfield(st, fields(i)) then
            st(fields(i)) = null();
        else
            error(msprintf(gettext("%s: Field ''%s'' does not exist.\n"), "rmfield", fields(i)));
        end
    end
endfunction
