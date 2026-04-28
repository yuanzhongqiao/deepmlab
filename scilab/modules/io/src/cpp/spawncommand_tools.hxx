/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
 *
 */

#ifndef __SPAWNCOMMAND_TOOLS_H__
#define __SPAWNCOMMAND_TOOLS_H__

#ifdef _MSC_VER
#include <Windows.h>
#define pipe_t HANDLE
#define INVALID_PIPE INVALID_HANDLE_VALUE
#else
#define pipe_t int
#define INVALID_PIPE 0
#endif

typedef struct pipeinfo
{
    pipe_t pipe;
    char* buffer;
    int echo;
} pipeinfo;

int splitString(char* output, char*** splited);
void* ReadFromPipe(void* data);
#endif /* __SPAWNCOMMAND_TOOLS_H__ */