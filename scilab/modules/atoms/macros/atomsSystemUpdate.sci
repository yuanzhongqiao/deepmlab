// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
// Copyright (C) 2012 - DIGITEO - Allan CORNET
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2021 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

// End user function

function atomsSystemUpdate()
    // Updates the list of available packages

    // Load Atoms Internals lib if it's not already loaded
    // =========================================================================
    if ~ exists("atomsinternalslib") then
        load("SCI/modules/atoms/macros/atoms_internals/lib");
    end

    if (atomsGetConfig("offLine") == "True" | atomsGetConfig("offline") == "True") then
        warning(msprintf(gettext("Option offline of ATOMS configuration is set to True. atomsSystemUpdate did not check the latest modules availables.")));
        return
    end

    // Check write access on allusers zone
    // =========================================================================
    if or(getscilabmode() == ["NWNI", "API"]) | get("atomsFigure")==[] then  // command-line mode
        atomsDESCRIPTIONget(%T);
    else                            // atomsGUI mode
        allModules = [];
        errStatus  = execstr("allModules = atomsDESCRIPTIONget(%T);", "errcatch");
        if errStatus<>0 | size(allModules, "*") == 0 then
            if size(atomsRepositoryList(),"*") > 0 then
                messagebox(gettext("No ATOMS module is available.<br><br>Please, check your Internet connection or make sure that your OS is compatible with ATOMS."), msprintf(gettext("ATOMS error in %s"),"atomsSystemUdate()"), "error");
            else
                messagebox(gettext("No ATOMS repository available.<br><br>Please check atomsRepositoryList() and atomsRepositoryAdd()."), msprintf(gettext("ATOMS error in %s"), "atomsSystemUpdate()"), "error");
            end
            return
        end
        // We update data stored in the GUI
        set("atomsFigure", "UserData", allModules);
    end
endfunction
