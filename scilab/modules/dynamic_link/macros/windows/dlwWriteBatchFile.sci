// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

//=============================================================================
function filename = dlwWriteBatchFile(cmd)

    //update DEBUG_SCILAB_DYNAMIC_LINK to match with Scilab compilation mode
    val = getenv("DEBUG_SCILAB_DYNAMIC_LINK","");
    if val <> "NO" & val <> "YES" then
        if isDebug() then
            val = "YES";
        else
            val = "NO";
        end
    end

    ifort = findmsifortcompiler();
    if ifort <> "unknown" then
        //call setvars from intel oneAPI to setup env (fortran AND C/C++)
        VSVer = dlwGetVisualStudioVersion();
        cmdenv = "@call """ + getIntelInformation() + "\setvars.bat"" " + "intel64" + sprintf(" vs%d", VSVer);
    else
        //call vcvarsall from Visual Studio to setup env (C/C++)
        if winarm64() then
            cmdenv = "@call """ + dlwGetVisualStudioPath() + "\VC\Auxiliary\Build\vcvarsall.bat"" " + "arm64";
        else
            cmdenv = "@call """ + dlwGetVisualStudioPath() + "\VC\Auxiliary\Build\vcvarsall.bat"" " + "x64";
        end
    end

    scibuild = [ ...
        cmdenv
        "set DEBUG_SCILAB_DYNAMIC_LINK=" + val;
        cmd
    ];

    filename = TMPDIR + "/scibuild.bat";
    mputl(scibuild, filename);
endfunction
