// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function s=%_EObj_fieldnames(b)
    s = [];
    if get(get(0), "ShowHiddenProperties") == "on" then
        s = getfield(1, b)(2:$)'; // _EnvId, ... 
    end
    s = [s ; jgetmethods(b) ; jgetfields(b)]
end
