
/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *
 * Copyright (C) INRIA - Allan CORNET
 * Copyright (C) DIGITEO - 2010 - Allan CORNET
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
 *
 */

#include <sstream>
#include "spawncommand_tools.hxx"
#include "scilabWrite.hxx"

extern "C"
{
#include "os_string.h"
#include "configvariable_interface.h"
#include "charEncoding.h"
#include "BOOL.h"
#include "sci_malloc.h"
#ifdef WITH_GUI
#include "getScilabJavaVM.h"
#endif
}

#define CR '\r'
#define LF '\n'
#define BLANK L' '
#define EMPTY_CHAR L'\0'
#define BUFSIZE 4096

void* ReadFromPipe(void* data)
{
    pipeinfo* pi = (pipeinfo*)data;
    char buffer[BUFSIZE] = {0};
    std::stringstream ss;

#ifdef _MSC_VER
    DWORD dwSizeRead = 0;
#else
    FILE* file = fdopen(pi->pipe, "r");
    if (file == NULL)
    {
        return NULL;
    }
#endif

    for (;;)
    {
#ifdef _MSC_VER
        BOOL bres = ReadFile(pi->pipe, buffer, BUFSIZE - 1, &dwSizeRead, NULL);
        if (bres == false || dwSizeRead == 0)
        {
            break;
        }
        buffer[dwSizeRead] = '\0';
#else
        if (fgets(buffer, sizeof(buffer), file) == NULL)
        {
            break;
        }
#endif

        ss << buffer;
        if (pi->echo == 1)
        {
            scilabWrite(buffer);
        }
    }

    if (ss.str().empty() == false)
    {
        pi->buffer = os_strdup(ss.str().data());
    }

#ifdef WITH_GUI
    if(getScilabMode() == SCILAB_STD)
    {
        // scilabWrite and scilabError will attach this thread
        // to the JVM to write in the java console.
        // Detach the current thread to avoid freeze
        // at scilab exit when destroying the JVM.
        JavaVM* vm = getScilabJavaVM();
        vm->DetachCurrentThread();
    }
#endif

#ifndef _MSC_VER
    fclose(file);
#endif

    return NULL;
}

int splitString(char* output, char*** splited)
{
    if (output == NULL)
    {
        return 0;
    }

    // remove last \n to avoid an extra empty string at the end
    size_t outsize = strlen(output);
    if(outsize > 1 && output[outsize-1] == LF)
    {
        output[outsize-1] = EMPTY_CHAR;
        if(output[outsize-2] == CR)
        {
            output[outsize-2] = EMPTY_CHAR;
        }
    }

    int outlines = 1;
    char* pointer = output;
    while ((pointer = strchr(pointer, LF)))
    {
        outlines++;
        pointer++;
    }

    *splited = (char**)MALLOC(outlines * sizeof(char*));
    memset(*splited, 0x00, sizeof(char*) * outlines);
    for (int i = 0; i < outlines; i++)
    {
        size_t cr = 0;
        pointer = strchr(output, LF);
        if (pointer)
        {
            *pointer = EMPTY_CHAR;
            if (pointer != output && *(pointer - 1) == CR)
            {
                *(pointer - 1) = EMPTY_CHAR;
                cr = 1;
            }
        }
        (*splited)[i] = output;
        size_t len = strlen(output);
        output += len + cr + 1; // 1: lf
    }

    return outlines;
}
