// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

load("SCI/modules/atoms/macros/atoms_internals/lib")

// Used in tests
function repository = atomsLoadTestScene(name, overwriteExisting, addRepository)
    arguments
        name
        overwriteExisting = %T
        addRepository = %T
    end
    select name
    case "scene10"
        archives = [
            "toolbox_1V6_1.0-1.bin.x64.windows.zip",
            "toolbox_2V6_1.0-1.bin.zip",
            "toolbox_2V6_2.0-1.bin.zip",
            "toolbox_3V6_1.0-1.bin.zip",
            "toolbox_4V6_1.0-1.bin.zip",
            "toolbox_5V6_1.0-1.bin.x64.windows.zip",
            "toolbox_6V6_1.0-1.bin.zip"]
    case "scene11"
        archives = [
            "toolbox_1V6_1.0-1.bin.x64.windows.zip",
            "toolbox_2V6_1.0-1.bin.zip",
            "toolbox_2V6_2.0-1.bin.zip",
            "toolbox_2V6_2.1-1.bin.zip",
            "toolbox_3V6_1.0-1.bin.zip",
            "toolbox_4V6_1.0-1.bin.zip",
            "toolbox_4V6_1.1-2.bin.zip",
            "toolbox_5V6_1.0-1.bin.x64.windows.zip"]
    case "scene12"
        archives = [
            "toolbox_1V6_1.0-1.bin.x64.windows.zip",
            "toolbox_2V6_1.0-1.bin.zip",
            "toolbox_2V6_2.0-1.bin.zip",
            "toolbox_2V6_2.1-1.bin.zip",
            "toolbox_4V6_1.1-2.bin.zip",
            "toolbox_5V6_1.0-1.bin.x64.windows.zip"]
    else
        error(msprintf(_("atomsLoadTestScene: Unknown scene: %s."), name));
    end
    repository = atomsCreateLocalRepositoryFromDescription(SCI+"/modules/atoms/tests/unit_tests/" + name + ".DESCRIPTION", name);
    if overwriteExisting then
        atomsRepositorySetOfl(repository);
    else
        if addRepository then
            atomsRepositoryAdd(repository);
        end
    end
    for iFile = 1:size(archives, "*")
        [status, message] = copyfile(SCI + "/modules/atoms/tests/unit_tests/" + archives(iFile), TMPDIR + "/" + name + "/");
    end
endfunction

// Used in documentation examples
function repository = atomsCreateTestRepository(name, addRepository)
    arguments
        name
        addRepository = %T
    end
    repository = atomsLoadTestScene(name, %F, addRepository)
endfunction

function filePath = atomsCreateLocalRepositoryFromDescription(descriptionFile, name)
    filePath = "";
    [OSNAME,ARCH,LINUX,MACOSX,SOLARIS,BSD] = atomsGetPlatform();
    
    // Remove/Create repository folder
    [status, message] = rmdir(TMPDIR + filesep() + name,'s')
    mkdir(TMPDIR, name);
    
    // Edit description file to replace TMPDIR by its value
    desc = mgetl(descriptionFile);
    for iLine=1:size(desc, "*")
        if ~isempty(strindex(desc(iLine), "TMPDIR")) then
            desc(iLine) = strsubst(desc(iLine), "TMPDIR", strsubst(TMPDIR, "\", "/"));
        end
    end
    tmpDescriptionFile = fullfile(TMPDIR, name + ".DESCRIPTION");
    mputl(desc, tmpDescriptionFile)
    
    // Gzip description file
    localRepository = fullfile(TMPDIR, name , OSNAME + ".gz");
    if ~isfile(localRepository) then
        compress(localRepository, tmpDescriptionFile, format="raw", compression="gzip", level=0);
    end

    // TMPDIR is using C:\Users\Me under Linux
    // but we need a valid URI
    filePath = "file://" + strsubst(TMPDIR + filesep() + name, "\", "/")
endfunction

function atomsRepositoryReset()
    userRep = atomsRepositoryList("user");
    allusersRep = atomsRepositoryList("allusers");
    if userRep <> [] then
        atomsRepositoryDel(userRep);
    end
    if allusersRep <> [] then
        atomsRepositoryDel(allusersRep);
    end
    sampleRep = atomsCreateLocalRepositoryFromDescription(SCI+"/modules/atoms/tests/unit_tests/sample.DESCRIPTION", "sample")
    atomsRepositorySetOfl(sampleRep);
endfunction
