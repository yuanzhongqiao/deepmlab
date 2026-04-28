// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
// This file is distributed under the same license as the Scilab package.
// For more information, see the COPYING file which you should have received
// along with this program.

function [package_file, listing, DESCRIPTION] = tbx_package(tbx_path, build_id, customize)
    arguments
        tbx_path (1,1) string {mustBeFolder} = pwd()
        build_id (1,1) string = ""
        customize {mustBeA(customize, "function")} = #(workdir) -> ()
    end
    
    // Load Atoms Internals lib if it's not already loaded
    // =========================================================================
    if ~ exists("atomsinternalslib") then
        load("SCI/modules/atoms/macros/atoms_internals/lib");
    end
    
    DESCRIPTION = atomsDESCRIPTIONread(fullfile(tbx_path, "DESCRIPTION"));
    [OSNAME, ARCH] = atomsGetPlatform();
    native = %f;

    name = fieldnames(DESCRIPTION("packages"));
    version = fieldnames(DESCRIPTION("packages")(name));
    pkg_name_version = name + "-" + version;

    if build_id <> "" then
        build_id = "-" + build_id;
    end
    if OSNAME == "windows" then
        ext = ".zip";
    else
        ext = ".tar.xz";
    end

    // create a work directory to copy files into
    // Toolboxes have a root directory named after the package name-ver
    workdir = fullfile(TMPDIR, pkg_name_version);
    if isdir(workdir) then
        // probably from a previous build, cleanup
        rmdir(workdir, 's');
    end

    // copy the full directory content, preserving internal symbolic links
    [status, msg] = copyfile(tbx_path, workdir, "preserve");
    if status <> 1 then
        errmsg = msprintf("%s: unable to copy %s to %s: %s", "tbx_package", tbx_path, workdir, msg);
        error(errmsg);
    end
    
    // remove the source files
    all_files = workdir + filesep() + findfiles(workdir);
    while all_files <> [] then
        f = all_files($);
        all_files($) = [];
        
        // recurse on directory
        if isdir(f) then

            // filter some directory
            [_, dname] = fileparts(f);
            select dname
            case {"Release", "Debug"}
                // windows msvc "Release"/"Debug" directory
                rmdir(f, 's');
                native = %t;
                continue
            end
            
            if strindex(dname, ".") == 1 then
                // do not ship directory starting with "."
                rmdir(f, 's');
            end

            files = findfiles(f);
            if files <> [] then
                all_files = [all_files ; f + filesep() + files];
            end
            continue;
        end

        // filter source code and temporary build artifacts
        [pname, fname, extension] = fileparts(f);
        if strindex(fname, ".") == 1 then
            // do not ship files starting with "."
            deletefile(f);
        end

        if strindex(extension, ".h") == 1 && strindex(pname, workdir + filesep() + "include") == 1 then
            // this is a .h, .hxx, .hpp, ... file in the root_package/include directory
            // it will be included in the package
            native = %t
        elseif extension == ".sce" then
            if strindex(fname, "build") == 1 then
                // this is a build*.sce file ; it will not be included
                deletefile(f);
            elseif strindex(fname, "clean") == 1 then
                // this is a clean*.sce ; it will not be included
                deletefile(f);
            end
        elseif extension == ".sci" && isfile(pname + filesep() + fname + ".bin") then
            // this is a Scilab macro file ; source code will not be included
            deletefile(f);
        elseif or(extension == [...
            ".lib" ".def" ".exp" ".obj" ".mak" ...          // windows build files
            ".o" "Makefile" ...                             // linux build files
            ".c" ".f" ".cxx" ".cpp" ".h" ".hxx" ".hpp" ...  // source files
            ]) then
            native = %t;
            deletefile(f);
        elseif extension == ".java" then
            deletefile(f);
        end
    end

    // cleanup, add files, do modification on the workdir
    customize(workdir);

    // compress the directory and remove it.
    if native then
        package_file = name + "-" + version + build_id + "-bin-" + OSNAME + ext;
    else
        package_file = name + "-" + version + build_id + "-bin" + ext;
    end
    if isfile(package_file) then
        errmsg = msprintf("%s: unable to create %s: file exists", "tbx_package", package_file);
        error(errmsg);
    end
    listing = compress(package_file, workdir);

    // Update DESCRIPTION
    if native then
        basekeyname = OSNAME + ARCH;
        DESCRIPTION.packages(name)(version)("HasNativeCode") = "Yes";
    else
        basekeyname = "binary";
        DESCRIPTION.packages(name)(version)("HasNativeCode") = "No";
    end
    DESCRIPTION.packages(name)(version)(basekeyname + "Name") = package_file;
    DESCRIPTION.packages(name)(version)(basekeyname + "Md5") = getmd5(package_file);
    DESCRIPTION.packages(name)(version)(basekeyname + "Size") = fileinfo(package_file)(1);

    rmdir(workdir, 's');
endfunction
