// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

// Internal function

function dir_created = atomsExtract(archive_in,dir_out)

    // Check input parameters number
    // =========================================================================

    rhs  = argn(2);

    if rhs <> 2 then
        error(msprintf(gettext("%s: Wrong number of input argument: %d expected.\n"),"atomsExtract",2));
    end

    // Check input parameters type
    // =========================================================================

    if type(archive_in) <> 10 then
        error(msprintf(gettext("%s: Wrong type for input argument #%d: string expected.\n"),"atomsExtract",1));
    end

    if type(dir_out) <> 10 then
        error(msprintf(gettext("%s: Wrong type for input argument #%d: string expected.\n"),"atomsExtract",2));
    end

    // Check input parameters size
    // =========================================================================

    if size(archive_in,"*") <> 1 then
        error(msprintf(gettext("%s: Wrong size for input argument #%d: string expected.\n"),"atomsExtract",1));
    end

    if size(dir_out,"*") <> 1 then
        error(msprintf(gettext("%s: Wrong size for input argument #%d: string expected.\n"),"atomsExtract",2));
    end

    // Check input parameters value
    // =========================================================================

    if regexp(archive_in,"/(\.tar\.gz|\.tgz|\.tar\.xz|\.zip)$/","o") == [] then
        error(msprintf(gettext("%s: Wrong value for input argument #%d: Single string that ends with .tar.gz, .tgz or .zip expected.\n"),"atomsExtract",1));
    end

    if fileinfo(archive_in) == [] then
        error(msprintf(gettext("%s: The file ""%s"" does not exist or is not read accessible.\n"),"atomsExtract",archive_in));
    end

    if ~ isdir(dir_out) then
        error(msprintf(gettext("%s: The directory ""%s"" does not exist.\n"),"atomsExtract",dir_out));
    end

    // Operating system detection + Architecture detection
    // =========================================================================
    [OSNAME,ARCH,LINUX,MACOSX,SOLARIS,BSD] = atomsGetPlatform();

    // Get the list of directories before the extraction
    // =========================================================================
    dirs_before = atomsListDir(dir_out);

    // Extract the toolbox
    // =========================================================================
    decompress(archive_in, pathconvert(dir_out,%F));

    // Get the list of directories after the extraction
    // =========================================================================
    dirs_after = atomsListDir(dir_out);


    // Get the name of the created directory
    // =========================================================================

    dir_created = [];

    for j=1:size(dirs_after,"*")
        if find(dirs_after(j) == dirs_before) == [] then
            dir_created = dirs_after(j);
            break;
        end
    end

endfunction


// =============================================================================
// Just get the list of the directories present in the current directory
// =============================================================================

function result = atomsListDir(path)

    // Init the output argument
    // =========================================================================
    result = [];

    // Save the initial path
    // =========================================================================
    initialpath = pwd();

    chdir(path);
    items  = listfiles();

    // Loop on items
    // =========================================================================
    for i=1:size(items,"*")
        if isdir(items(i)) then
            result = [ result ; items(i) ];
        end
    end

    // Go to the initial location
    // =========================================================================
    chdir(initialpath);

endfunction
