// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Antoine ELIAS
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2016, 2018, 2019, 2021 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function tbx_build_localization(tbx_name, tbx_path)
    // tbx_build_localization(name, path)   // deprecated (6.0)
    // tbx_build_localization(name)         // deprecated (6.0)
    // tbx_build_localization(path)         // 6.0
    // tbx_build_localization()             // 6.0  path = pwd()

    fname = "tbx_build_localization"
    rhs = argn(2)

    // CHECKING INPUT PARAMETERS
    // -------------------------
    if and(rhs <> [0 1 2]) then
        msg = _("%s: Wrong number of input arguments: %d to %d expected.\n")
        error(msprintf(msg, fname, 0, 1))
    end

    if rhs==2
        msg = "%s: %s(name, path) is obsolete. Please use %s(path) instead.\n"
        warning(msprintf(msg, fname, fname, fname))  // no translation

    elseif rhs==0
        tbx_path = pwd()
    else
        tbx_path = tbx_name
        if type(tbx_path) <> 10 then
            msg = _("%s: Argument #%d: Text(s) expected.\n")
            error(msprintf(msg, fname, rhs))
        end
        tbx_path = tbx_path(1)
        // May be
        //  * either the former tbx_build_localization(tbx_name) (until 5.5.2)
        //  * or the new        tbx_build_localization(tbx_path) (from 6.0.0)
        if grep(tbx_path,["/" "\"])==[] && ~isdir(tbx_path) then // only name was provided
            tbx_path = pwd()
        end
        if ~isdir(tbx_path) then
            msg = _("%s: The directory ''%s'' doesn''t exist or is not read accessible.\n")
            error(msprintf(msg, fname, tbx_path))
        end
    end

    // Retrieving the toolbox name
    // ---------------------------
    tbx_name = tbx_get_name_from_path(tbx_path)

    // Run tbx_generate_pofile() ?  Yes if /locales or *.po do not exist
    //------------------------
    localePath = pathconvert(tbx_path + "/locales/")
    tbx_generate_pofile(tbx_path);
    poFiles = findfiles(localePath, "*.po")'
    if poFiles==[]
        msg = _("%s: The module ''%s'' has no entry to be localized.\n")
        mprintf(msg, fname, tbx_name)
        return
    else
        poFiles = fileparts(poFiles, "fname")
        poFiles(poFiles=="en_US") = []
        msg = _("tbx_build_localization (%s): \n   - The msgid have been updated in ''*.po'' files.\n")
        if poFiles==[]
            msg = msg + _("   Please\n   - Copy the en_US.po file into la_LA.po (ex: pt_BR.po) in the same directory.\n   - Write missing msgstr translated messages in the copies\n   - Rerun the build.\n")
            warning(msprintf(msg, tbx_name+"\locales\"))
        else
            warning(msprintf(msg, tbx_name+"\locales\"))
            n = 0;
            // We display how many msgstr are missing in each .po file
            for po = poFiles
                tmp = mgetl(localePath + po + ".po");
                tmp = length(grep(tmp, "/^msgstr """"$/", "r")) - 1
                n = n + tmp
                msg = _("   - %s.po : %d untranslated messages.\n")
                warning(msprintf(msg, po, tmp))
            end
            if n > 0
                warning(msprintf(_("Please\n   - Write missing translated messages msgstr in la_LA.po files.\n   - Rerun the build.\n")))
            end
            mprintf("\n")
        end
    end

    // find list of .po files
    // ----------------------
    poFiles = gsort(listfiles(localePath + "*.po"), "lr", "i");

    if getos() == "Windows" then
        cmd = SCI + filesep() + "tools/gettext/msgfmt";
    else
        cmd = "msgfmt";
    end

    mprintf(gettext("Generating localization\n"));
    for i=1:size(poFiles, "*")
        //generate moFile name and path
        lang = fileparts(poFiles(i), "fname");
        printf("-- Building for ""%s"" --\n", lang);
        moFile = localePath + lang + "/LC_MESSAGES/";
        mkdir(moFile); //to be sure path exists
        poFile = moFile + tbx_name + ".po";
        moFile = moFile + tbx_name + ".mo";

        //check mo file is newest po, don't need to generate it
        if newest(poFiles(i), moFile) == 1 then
            copyfile(poFiles(i), poFile);
            cmd1 = cmd + " -o " + moFile + " " + poFile;
            host(cmd1)
        end
    end
endfunction
