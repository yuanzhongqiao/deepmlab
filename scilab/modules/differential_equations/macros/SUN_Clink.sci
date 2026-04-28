//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function _lib = SUN_Clink(names,files_in,p1,p2,p3,p4,p5,p6,p7,p8,p9)
    //
    // Easy link for Sundials gateways
    //
    // p1,p2,... are fake input arguments
    //
    opt = checkNamedArguments();
    [nargout,nargin] = argn(); 
    nargin = nargin - size(opt,"*");
    //
    if nargin <> 2
        msg = msprintf(_("%s: Wrong number of input arguments: %d expected"),"SUN_Clink",2)
        error(msg)
    end
    if typeof(names) <> "string"
        msg = msprintf(_("%s: Wrong type for input argument #%d: String array expected.\n"),"SUN_Clink",1)
        error(msg)
    end
    if min(length(names)) == 0
        msg = msprintf(_("%s: Wrong values for input argument #%d: non empty strings expected.\n"),"SUN_Clink",1)
        error(msg)
    end
    if typeof(files_in) <> "string"
        msg = msprintf(_("%s: Wrong type for input argument #%d: String array expected.\n"),"SUN_Clink",2)
        error(msg)
    end
    for i = 1:size(files_in,"*")
        if ~isfile(files_in(i))
            msg = msprintf(_("%s: Wrong value for input argument #%d: existing file(s) expected.\n"),"SUN_Clink",2)
            error(msg)
        end
    end

    CFLAGS = "";
    // Source tree version
    if isdir(SCI+"/modules/differential_equations/src/")
        SUNDIALSpath = fullfile(SCI,'modules','differential_equations','src','patched_sundials','include');
        CFLAGS=" -I"+SUNDIALSpath;
    elseif getos() == "Windows"
        SUNDIALSpath = fullfile(SCI,'modules','differential_equations','includes');
        CFLAGS=" -I"+SUNDIALSpath;
    end
    
    LDFLAGS = "";
    if getos() == "Windows"
        LDFLAGS=" "+SCI+"\bin\patched_sundials.lib";
    elseif isfile(SCI+"/modules/differential_equations/.libs/libscisundials"+getdynlibext())
        // Unix source tree version
        LDFLAGS=" "+SCI+"/modules/differential_equations/.libs/libscisundials"+getdynlibext();
    else
        // Unix binary tree version
        LDFLAGS=" "+SCI+"/../../lib/scilab/libscisundials"+getdynlibext();
    end

    VERBOSE = 1;
    if exists("verbose","local")
        opt(opt=="verbose") = [];
        if typeof(verbose) <> "constant" || size(verbose)>1 || verbose < 0 || verbose > 2
            msg = msprintf(_("%s: verbose option can be 0,1 or 2."),"SUN_Clink")            
            error(msg)
        end
        VERBOSE = verbose;
    end
    if exists("cflags","local")
        opt(opt=="cflags") = [];
        if typeof(cflags) <> "string" || size(cflags,"*") > 1
            msg = msprintf(_("%s: wrong type for ""cflags"" option, a string is expected."),"SUN_Clink")            
            error(msg)
        end
        CFLAGS = CFLAGS+" "+cflags
    end
    if exists("ldflags","local")
        opt(opt=="ldflags") = [];
        if typeof(ldflags) <> "string" || size(ldflags,"*") > 1
            msg = msprintf(_("%s: wrong type for ""ldflags"" option, a string is expected."),"SUN_Clink")            
            error(msg)
        end
        LDFLAGS = ldflags;
    end
    LIBNAME = names(1);
    if exists("libname","local")
        opt(opt=="libname") = [];
        if typeof(libname) <> "string" || size(libname,"*") > 1
            msg = msprintf(_("%s: wrong type for ""libname"" option, a string is expected."),"SUN_Clink")            
            error(msg)
        end
        LIBNAME = libname;
    end
    LOADERNAME = "lib" + LIBNAME + ".sce";
    if exists("loadername","local")
        opt(opt=="loadername") = [];
        if typeof(loadername) <> "string" || size(loadername,"*") > 1
            msg = msprintf(_("%s: wrong type for ""loadername"" option, a string is expected."),"SUN_Clink")            
            error(msg)
        end
        LOADERNAME = loadername;
    end
    LOAD = %f;
    if exists("load","local")
        opt(opt=="load") = [];
        if typeof(load) <> "boolean" || size(load) > 1
            msg = msprintf(_("%s: wrong type for ""load"" option, a boolean is expected."),"SUN_Clink")            
            error(msg)
        end
        LOAD = load;
        // prevent internal "load" squash (used in ilib_for_link under Windows)
        clear load
    end

	// prevent internal "load" squash (used in ilib_for_link under Windows)
    clear load

    // all remaining options are invalid, raise an error for the first one
    if size(opt,"*") > 0
        msg = msprintf(_("%s: ""%s"" is an invalid option.\n"),"SUN_Clink",opt(1))            
        error(msg)
    end

    files = fullpath(files_in);
    [_d,_f,_ext] = fileparts(files);
    files_tmp = _f+_ext;
    p = pwd();

    // copy source files in TMPDIR
    cd(TMPDIR);
    for k = 1:size(files_tmp,"*")
        copyfile(files(i),files_tmp(i))
    end

    old_verb = ilib_verbose();
    ilib_verbose(VERBOSE);
    
    // ilib_for_link call
    _lib = ilib_for_link(names,files_tmp,[],"c","",LOADERNAME,LIBNAME,LDFLAGS,CFLAGS); //compile

    if LOAD
        exec(LOADERNAME,-1)
        _lib = fullpath(fullfile(TMPDIR,_lib));
    else
        movefile(LOADERNAME,fullpath(fullfile(p,LOADERNAME)))
        libPath = "lib" + LIBNAME + getdynlibext();
        _lib = fullpath(fullfile(p,libPath));
        movefile(libPath,_lib)
    end
    ilib_verbose(old_verb);
    chdir(p)
end
