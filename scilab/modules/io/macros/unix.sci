// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//

function [status, stdout, stderr] = unix(command)
    arguments
        command { mustBeA(command, "string"), mustBeScalar }
    end

    warnobsolete("host", "2027.0.0")
    [status, stdout, stderr] = host(command);
endfunction