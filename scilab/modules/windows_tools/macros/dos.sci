// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//

function [output, bOK, exitcode] = dos(command, echomode)
    arguments
        command { mustBeA(command, "string"), mustBeScalar }
        echomode { mustBeA(echomode, "string"), mustBeScalar, mustBeMember(echomode, ["-echo", ""]) } = ""
    end
    warnobsolete("host", "2027.0.0")
    [lhs, rhs] = argn();

    bEcho = echomode == "-echo";
    [status, stdout, stderr] = host(command, echo=bEcho);
    if status then
        output = stderr;
        bOK = %f;
        exitcode = status;
    else
        output = stdout;
        bOK = %t;
        exitcode = status;
    end

    if lhs == 1 then
        output = bOK;
    end
endfunction
