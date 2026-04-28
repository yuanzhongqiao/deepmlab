// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function FComplier = getIntelInformation()
    if getenv("IFORT_COMPILER25", "") <> "" then
        FComplier = fullpath(getenv("IFORT_COMPILER25", "") + "../..");
    end
endfunction