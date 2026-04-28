/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2023 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
* This file is hereby licensed under the terms of the GNU GPL v2.0,
* pursuant to article 5.3.4 of the CeCILL v.2.1.
* This file was originally licensed under the terms of the CeCILL v2.1,
* and continues to be available under such terms.
* For more information, see the COPYING file which you should have received
* along with this program.
*
*/

#include "fileio_gw.hxx"
#include "archive_utils.hxx"
#include "string.hxx"

#include <filesystem>
#include <fstream>
#ifdef _MSC_VER
#include <io.h>
#else
#include <glob.h>
#endif

extern "C"
{
    #include "sciprint.h"
    #include "expandPathVariable.h"
    #include <fcntl.h>
}

static int wildcard(std::filesystem::path& strPath, std::vector<std::filesystem::path>& vectFiles);

static const char fname[] = "compress";
types::Function::ReturnValue sci_compress(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    int res = 0;
    if(in.size() < 1 || in.size() > 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), fname, 1, 2);
        return types::Function::Error;
    }

    if(_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), fname, 1);
        return types::Function::Error;
    }

    // get Archive name
    if(in[0]->isString() == false || in[0]->getAs<types::String>()->isScalar() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: A scalar string expected.\n"), fname, 1);
        return types::Function::Error;
    }

    types::String* pArchive = in[0]->getAs<types::String>();

    // get files to fill the archive
    if(in[1]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: String expected.\n"), fname, 2);
        return types::Function::Error;
    }

    types::String* pFiles = in[1]->getAs<types::String>();

    // manages scilab variable and wildcard
    std::vector<std::filesystem::path> vectFiles;
    for(int i = 0; i < pFiles->getSize(); ++i)
    {
        wchar_t* wcsPath = expandPathVariableW(pFiles->get(i));
        std::filesystem::path p(wcsPath);
        FREE(wcsPath);

        int err = wildcard(p, vectFiles);
        if (err)
        {
            Scierror(999, _("%s: Path expansion failed.\n"), fname);
            return types::Function::Error;
        }
    }

    wchar_t* wcsArchive = expandPathVariableW(pArchive->get(0));
    std::wstring wArchive(wcsArchive);
    FREE(wcsArchive);

    struct archive* ar = archive_write_new();
    if (fillArchiveOpt(ar, opt, fname, wArchive.c_str()))
    {
        cleanup(ar);
        return types::Function::Error;
    }

    res = archive_write_open_filename_w(ar, wArchive.c_str());
    if(check_error(res, ar, fname))
    {
        cleanup(ar);
        return types::Function::Error;
    }

    std::vector<std::string> vstFiles;
    for(const auto& currentPath : vectFiles)
    {
        struct archive* disk = archive_read_disk_new();
        res = archive_read_disk_open(disk, currentPath.string().c_str());
        if(check_error(res, disk, fname))
        {
            cleanup(ar, disk);
            return types::Function::Error;
        }

#ifndef _MSC_VER
        res = archive_read_disk_set_standard_lookup(disk);
        if(check_error(res, disk, fname))
        {
            cleanup(ar, disk);
            return types::Function::Error;
        }
#endif

        size_t dn_len = 0;
        if(currentPath.is_absolute())
        {
            dn_len = currentPath.parent_path().native().length();
            // remove the / after between the path and the next item
            dn_len++;
        }

        struct archive_entry* entry = archive_entry_new();
        for (;;)
        {
            int res = archive_read_next_header2(disk, entry);
            if(res == ARCHIVE_EOF)
            {
                break;
            }

            if(check_error(res, disk, fname))
            {
                cleanup(ar, disk, entry);
                return types::Function::Error;
            }

            res = archive_read_disk_descend(disk);
            if(check_error(res, disk, fname))
            {
                cleanup(ar, disk, entry);
                return types::Function::Error;
            }

            // In case of absolute path, keep only the last element
            if(dn_len)
            {
                const char* current_file = archive_entry_pathname(entry);
                if(dn_len >= strlen(current_file))
                {
                    archive_entry_clear(entry);
                    continue;
                }

                archive_entry_set_pathname(entry, current_file + dn_len);
            }

            vstFiles.push_back(archive_entry_pathname(entry));

            res = archive_write_header(ar, entry);
            if(check_error(res, ar, fname))
            {
                cleanup(ar, disk, entry);
                return types::Function::Error;
            }

            std::ifstream input(archive_entry_sourcepath(entry), std::ios::binary);

            #define READ_SIZE 8192
            std::vector<char> fileData(READ_SIZE, 0);
            while (input)
            {
                input.read(fileData.data(), READ_SIZE);
                archive_write_data(ar, &fileData[0], input.gcount());
            }

            archive_entry_clear(entry);
        }

        archive_entry_free(entry);
        archive_read_close(disk);
        archive_read_free(disk);
    }

    types::String* pOut = new types::String(vstFiles.size(), 1);
    for(int i = 0; i < pOut->getRows(); ++i)
    {
        pOut->set(i, vstFiles[i].c_str());
    }

    out.push_back(pOut);

    archive_write_close(ar);
    archive_write_free(ar);

    return types::Function::OK;
}

int wildcard(std::filesystem::path& currentPath, std::vector<std::filesystem::path>& vectFiles)
{
#ifdef _MSC_VER
    struct _finddata_t c_file;
    intptr_t hFile;
    if ((hFile = _findfirst(currentPath.string().c_str(), &c_file)) == -1L)
    {
        // no match
        vectFiles.emplace_back(currentPath);
    }
    else
    {
        do
        {
            vectFiles.emplace_back(currentPath.parent_path() /= c_file.name);
        }
        while (_findnext(hFile, &c_file) == 0);
    }

    _findclose(hFile);
    return 0;
#else
    glob_t gstruct;
    int res = glob(currentPath.string().c_str(), GLOB_ERR, NULL, &gstruct);
    if (res == GLOB_NOMATCH)
    {
        // no match
        vectFiles.emplace_back(currentPath);
        globfree(&gstruct);
        return 0;
    }

    if (res)
    {
        globfree(&gstruct);
        return 1;
    }

    for (int iter = 0; iter < gstruct.gl_pathc; ++iter)
    {
        vectFiles.emplace_back(gstruct.gl_pathv[iter]);
    }

    globfree(&gstruct);
    return 0;
#endif
}
