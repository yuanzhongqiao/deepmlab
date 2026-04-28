// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

function b = isLinuxPackaged()
    b = isdir(SCI + "/../../include")
endfunction

function [binary] = compile_executable(srcFile, cflags, ldflags)
    // compile the srcFile to produce an executable using call_scilab

    srcFile = fullpath(srcFile);
    binary = fullfile(TMPDIR, basename(srcFile(1)));
    fileContent = mgetl(srcFile);
    idx = find(strstr(fileContent, "DisableInteractiveMode") <> "");
    withGraphic = idx == [];

    if getos() == "Windows" then
        // Load dynamic_link Internal lib if it's not already loaded
        if ~ exists("dynamic_linkwindowslib") then
            load(WSCI + "/modules/dynamic_link/macros/windows/lib");
        end
        [dynamic_info, static_info] = getdebuginfo();
        arch_info  = static_info(grep(static_info,"/^Compiler Architecture:/","r"));
        arch = strsplit(arch_info, ": ")($);
        binary = binary + ".exe";
        CC =  """"+listfiles(dlwGetVisualStudioPath() + "\VC\Tools\MSVC\*")(1) + "\bin\Host" + arch + "\" + arch + "\cl.exe""";
        CFLAGS = "/I """ + WSCI + [
                    "\modules\call_scilab\includes"
                    "\modules\api_scilab\includes"
                    "\modules\core\includes"
                    "\modules\ast\includes\ast"
                    "\modules\ast\includes\system_env"
                    ] + """";
        CFLAGS = ["/Wall"; CFLAGS ; "/I ."];
        LDFLAGS = [ "/link"
                    "/out:""" + binary + """"
                    "/LIBPATH:""" + WSCI + "\bin"""];
    else
        // use cc here to let the user configure it if needed
        CC = "cc -o " + binary;
        if isLinuxPackaged() then
            CFLAGS = "-I" + SCI + "/../../include/scilab/";
            scilabLib = "/../../lib/scilab/libscilab-cli.so";
            if withGraphic then
                scilabLib = "/../../lib/scilab/libscilab.so";
            end
            LDFLAGS = SCI + [
                        "/../../lib/scilab/libscicall_scilab.so",
                        scilabLib];
            LDFLAGS = [LDFLAGS; "-L" + SCI + "/../../lib/scilab/"];
        else
            CFLAGS = "-I" + SCI + [
                        "/modules/call_scilab/includes"
                        "/modules/api_scilab/includes"
                        "/modules/core/includes"
                        "/modules/ast/includes/ast"
                        "/modules/ast/includes/types"
                        "/modules/dynamic_link/includes"
                        "/modules/string/includes"
                        "/modules/fileio/includes"
                        "/modules/localization/includes"
                        "/modules/output_stream/includes"];

            // set scilab .so files from all .libs
            if withGraphic then
                [s, LDFLAGS, e] = host("find "+SCI+"/modules -name *.so ! -name *-disable.so ! -name *-cli.so");
            else
                [s, LDFLAGS, e] = host("find "+SCI+"/modules -name *.so");
                // removes graphic libs
                libToRemove = ["libscilab.", ...
                "libsciscicos.", "libscipreferences.", "libsciscicos_blocks.", ... // have a -cli.so equivalent
                "libscigraphic_export.", "libsciui_data.", "libsciscinotes.", ... // have a -disable.so equivalent
                "libscigraphic_objects.", "libscigui.", "libscicommons.", "libscijvm.", ...
                "libsciaction_binding.", "libscixcos.", "libscigraphics.", "libscihistory_browser.", ...
                "libscihelptools.", "libscitclsci.",...
                "libscirenderer.", "libscitypes-java.", "libsciexternal_objects_java.", "libscihelptools.", "libjavasci2.", "libsciconsole."]; // other graphics libs

                for l = libToRemove
                    LDFLAGS(find(strstr(LDFLAGS, l) <> "")) = [];
                end
            end

            if s <> 0 then
                error(["Failed to get libraries."; e]);
            end

            if isdef("ldflags", 'l') then
                // set path for -l libs given in 'ldflags' input argument
                [s, o, e] = host("ls -d " + SCI + "/modules/*/.libs");
                if s <> 0 then
                    error(["Failed to get libraries folders."; e]);
                end

                LDFLAGS = [LDFLAGS; "-L" + SCI + "/modules/.libs"; "-L" + o];
            end
        end

        CFLAGS = ["-Wall -Wextra -Werror -I ." ; CFLAGS];
        LDFLAGS = [ "-Wl,--allow-shlib-undefined" // Scilab has recursive dependencies, do not check them
                    "-Wl,--no-as-needed" // keep libscilab.so dependency
                    LDFLAGS];
    end

    if isdef("cflags", 'l') then
        CFLAGS = [CFLAGS ; cflags(getos())];
    end
    if isdef("ldflags", 'l') then
        LDFLAGS = [LDFLAGS ; ldflags(getos())];
    end

    command = strcat([CC strcat(""""+srcFile+"""", " ") strcat(CFLAGS, " ") strcat(LDFLAGS, " ")], " ");
    if getos() == "Windows" then
        command = dlwWriteBatchFile(command)
    end

    [status, stdout, stderr] = host(command);
    if status then
        error(["compile_executable exit with status " + string(status); "command: "+command; "output: "+stdout; "error: "+stderr]);
    end
endfunction

function [status, stdout, stderr] = run_executable(binary)
    // run the binary using call_scilab and proper env. variable

    env = "";
    if getos() <> "Windows" then
        if isLinuxPackaged() then
            env = ["LD_LIBRARY_PATH="+strcat(SCI + ["/../../lib/scilab", "/../../thirdparty/java/lib", "/../../thirdparty/java/lib/server"], ":")]
        else
            p = ["/modules/.libs", "/java/jre/lib", "/java/jre/lib/server"];
            if isdir(SCI + "/usr/lib") then
                p = [p, "/lib/thirdparty", "/lib/thirdparty/redist"];
            end
            [s, o, e] = host("ls -d " + SCI + "/modules/*/.libs");
            if s <> 0 then
                error(["Failed to get libraries folders."; e]);
            end
            env = ["LD_LIBRARY_PATH=""" + strcat([o', SCI + p], ":") + """"]
        end
        env = [ env
                "TCL_LIBRARY="+SCI+"/modules/tclsci/tcl/tcl8.5"
                "TK_LIBRARY="+SCI+"/modules/tclsci/tcl/tk8.5"];
    end

    command = strcat([strcat(env, " ") binary], " ");
    [status, stdout, stderr] = host(command);
endfunction