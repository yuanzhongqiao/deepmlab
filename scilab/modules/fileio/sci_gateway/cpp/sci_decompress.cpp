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

extern "C"
{
    #include "sciprint.h"
    #include "expandPathVariable.h"
}

#define BLOCK_SIZE 10240

static const char fname[] = "decompress";
types::Function::ReturnValue sci_decompress(types::typed_list &in, types::optional_list &opt, int _iRetCount, types::typed_list &out)
{
    if (in.size() < 1 || in.size() > 2)
    {
        Scierror(77, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), fname, 1, 2);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
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

    std::filesystem::path outPath;
    if(in.size() > 1)
    {
        // get folder to extract archive in
        if(in[1]->isString() == false || in[1]->getAs<types::String>()->isScalar() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A single string expected.\n"), fname, 2);
            return types::Function::Error;
        }

        wchar_t* wcsOutPath = expandPathVariableW(in[1]->getAs<types::String>()->get(0));
        outPath = wcsOutPath;
        FREE(wcsOutPath);
    }

    wchar_t* wcsArchive = expandPathVariableW(pArchive->get(0));
    std::wstring archivePath(wcsArchive);
    FREE(wcsArchive);

    struct archive* ar = archive_read_new();
    if(fillArchiveOpt(ar, opt, fname))
    {
        cleanup(ar);
        return types::Function::Error;
    }

    int res = archive_read_open_filename_w(ar, archivePath.c_str(), BLOCK_SIZE);
    if(check_error(res, ar, fname))
    {
        cleanup(ar);
        return types::Function::Error;
    }

    // sciprint("Archive information:\n");
    // sciprint("  format:      %s\n", archive_format_name(ar));
    // std::string filters;
    // for( int i = 0; i < archive_filter_count(ar); ++i)
    // {
    //     filters += archive_filter_name(ar, 0);
    //     filters += " ";
    // }
    // sciprint("  compression:     %s\n", filters.data());

    /* Select which attributes we want to restore. */
    // int flags = 0;
    // flags = ARCHIVE_EXTRACT_TIME;
    // flags |= ARCHIVE_EXTRACT_PERM;
    // flags |= ARCHIVE_EXTRACT_ACL;
    // flags |= ARCHIVE_EXTRACT_FFLAGS;
    struct archive* disk = archive_write_disk_new();
    // archive_write_disk_set_options(disk, flags);
    archive_write_disk_set_standard_lookup(disk);

    struct archive_entry* entry = archive_entry_new();
    std::vector<std::string> vstFiles;
    for (;;)
    {
        int res = archive_read_next_header2(ar, entry);
        if (res == ARCHIVE_EOF)
        {
            break;
        }

        if(check_error(res, ar, fname))
        {
            cleanup(ar, disk, entry);
            return types::Function::Error;
        }

        if(!outPath.empty())
        {
            std::filesystem::path fullPath = outPath / archive_entry_pathname(entry); // concat path with sep
            archive_entry_set_pathname(entry, fullPath.string().c_str());
        }

        res = archive_write_header(disk, entry);
        if(check_error(res, disk, fname))
        {
            cleanup(ar, disk, entry);
            return types::Function::Error;
        }

        la_int64_t s = archive_entry_size(entry);
        if(s > 0)
        {
            while(res != ARCHIVE_EOF)
            {
                const void* buff;
                size_t size;
                la_int64_t offset;
                res = archive_read_data_block(ar, &buff, &size, &offset);
                if(check_error(res, ar, fname))
                {
                    cleanup(ar, disk, entry);
                    return types::Function::Error;
                }

                int resw = archive_write_data_block(disk, buff, size, offset);
                if(check_error(resw, disk, fname))
                {
                    cleanup(ar, disk, entry);
                    return types::Function::Error;
                }
            }
        }

        res = archive_write_finish_entry(disk);
        if(check_error(res, disk, fname))
        {
            cleanup(ar, disk, entry);
            return types::Function::Error;
        }

        vstFiles.push_back(archive_entry_pathname(entry));
        archive_entry_clear(entry);
    }

    types::String* pOut = new types::String(vstFiles.size(), 1);
    for(int i = 0; i < pOut->getRows(); ++i)
    {
        pOut->set(i, vstFiles[i].c_str());
    }

    out.push_back(pOut);

    archive_read_close(ar);
    archive_read_free(ar);
    archive_write_close(disk);
    archive_write_free(disk);
    archive_entry_free(entry);

    return types::Function::OK;
}
