// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function vs = getVsWhereInformation()
    //call vswhere MS tools to get Information about VSs >= 2015 installed.

    //command vswhere -all -prerelease -format json -utf8

    //-prerelease   Also searches prereleases. By default, only releases are searched.
    //-format arg   Return information about instances found in a format described below.
    //-utf8         Use UTF-8 encoding (recommended for JSON).
    //-products *   all version including BuildTools
    //-requires     MSBuild, version be able to build C++

    cmd = sprintf("""%s"" -products * -requires Microsoft.Component.MSBuild -prerelease -format json -utf8", fullfile(SCI, "tools", "vswhere", "vswhere"));
    [_, x] = host(cmd); // x will be equal to "[]" character string if no product found
    vs = [];
    vers = [];
    x = fromJSON(x);
    if isempty(x) == %f then
        for i = 1:length(x)
            xi = x(i);
            vs($+1) = struct("name", xi.displayName, "version", strtod(xi.catalog.productLineVersion), "path", xi.installationPath);
        end

        vers = list2vec(vs.version);
        [_, i] = gsort(vers);
        vs = vs(i);
    end
endfunction
