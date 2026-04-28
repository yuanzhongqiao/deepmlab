/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
*
* Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
*
*/

#include "spawncommand.hxx"
#include "spawncommand_tools.hxx"
#include "UTF8.hxx"

extern "C"
{
#include "Thread_Wrapper.h"
#include "PATH_MAX.h"
#include "os_string.h"
}

#ifndef _MSC_VER
#include <sys/wait.h>
#include <unistd.h>
#endif

static pipeinfo pipeSpawnOut = {INVALID_PIPE, NULL, 0};
static pipeinfo pipeSpawnErr = {INVALID_PIPE, NULL, 0};
static void setEmptyOutputs(int _iOutputs, types::String** _pStrOut, types::String** _pStrErr);

int spawncommand(const std::wstring& _pstCommand, int _iOutputs, types::String** _pStrOut, types::String** _pStrErr, int _iEcho)
{
    int iExitCode = 0;
    char* pcOutBuffer = NULL;
    char* pcErrBuffer = NULL;
    pipeSpawnOut = {INVALID_PIPE, NULL, 0};
    pipeSpawnErr = {INVALID_PIPE, NULL, 0};
    bool needsStdOut = _iEcho == 1 || _iOutputs > 0;
    bool needsStdErr = _iOutputs == 2;

    if (_pstCommand.empty())
    {
        setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
        return iExitCode;
    }

    pipeSpawnOut.echo = _iEcho;
    pipeSpawnErr.echo = _iEcho;

#ifdef _MSC_VER
    wchar_t shellCmd[PATH_MAX];
    STARTUPINFOW si;
    PROCESS_INFORMATION pi;
    SECURITY_ATTRIBUTES sa;
    DWORD threadID;
    HANDLE h;
    HANDLE hProcess = GetCurrentProcess();
    DWORD ExitCode = 0;

    ZeroMemory(&pi, sizeof(PROCESS_INFORMATION));
    ZeroMemory(&si, sizeof(STARTUPINFOW));
    si.cb = sizeof(STARTUPINFO);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdInput = INVALID_HANDLE_VALUE;

    ZeroMemory(&sa, sizeof(SECURITY_ATTRIBUTES));
    sa.nLength = sizeof(SECURITY_ATTRIBUTES);
    sa.lpSecurityDescriptor = NULL;
    sa.bInheritHandle = TRUE;

    // create a Job object to handle Scilab kill or closing before the child process
    HANDLE hJob = CreateJobObjectW(NULL, NULL);
    if (!hJob)
    {
        setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
        return -1;
    }

    JOBOBJECT_EXTENDED_LIMIT_INFORMATION jeli = {0};
    jeli.BasicLimitInformation.LimitFlags = JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
    if (!SetInformationJobObject(hJob, JobObjectExtendedLimitInformation, &jeli, sizeof(jeli)))
    {
        setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
        CloseHandle(hJob);
        return -1;
    }

    if (needsStdOut)
    {
        /* create a non-inheritible pipe. */
        CreatePipe(&pipeSpawnOut.pipe, &h, &sa, 0);
        /* dupe the write side, make it inheritible, and close the original. */
        DuplicateHandle(hProcess, h, hProcess, &si.hStdOutput,
                        0, TRUE, DUPLICATE_SAME_ACCESS | DUPLICATE_CLOSE_SOURCE);

        if (needsStdErr)
        {
            /* Same as above, but for stderr. */
            CreatePipe(&pipeSpawnErr.pipe, &h, &sa, 0);
            DuplicateHandle(hProcess, h, hProcess, &si.hStdError,
                            0, TRUE, DUPLICATE_SAME_ACCESS | DUPLICATE_CLOSE_SOURCE);
        }
        else
        {
            /* Redirect stderr in same pipe as stdout */
            si.hStdError = si.hStdOutput;
        }
    }

    // no needs to redirect stdout/err
    if (si.hStdOutput == NULL)
    {
        si.hStdOutput = GetStdHandle(STD_OUTPUT_HANDLE);
    }

    if (si.hStdError == NULL)
    {
        si.hStdError = GetStdHandle(STD_ERROR_HANDLE);
    }

    /* base command line */
    GetEnvironmentVariableW(L"ComSpec", shellCmd, PATH_MAX);

    std::wstring CmdLine = shellCmd;
    CmdLine += L" /C \"" + _pstCommand + L"\"";

    BOOL ok = CreateProcessW(
        NULL,            /* Module name. */
        (wchar_t*)CmdLine.c_str(), /* Command line. */
        NULL,            /* Process handle not inheritable. */
        NULL,            /* Thread handle not inheritable. */
        TRUE,            /* yes, inherit handles. */
        0,               /* Display console or not. */
        NULL,            /* Use parent's environment block. */
        NULL,            /* Use parent's starting directory. */
        &si,             /* Pointer to STARTUPINFO structure. */
        &pi);            /* Pointer to PROCESS_INFORMATION structure. */

    if (!ok)
    {
        setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
        return -1;
    }

    if (!AssignProcessToJobObject(hJob, pi.hProcess))
    {
        setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
        TerminateProcess(pi.hProcess, 1);
        CloseHandle(hJob);
        return -1;
    }

    // close our references to the write handles that have now been inherited
    if (needsStdOut)
    {
        CloseHandle(si.hStdOutput);
        if (needsStdErr)
        {
            CloseHandle(si.hStdError);
        }
    }

    WaitForInputIdle(pi.hProcess, 5000);
    CloseHandle(pi.hThread);

#else

    int pipeOut[2] = {0};
    int pipeErr[2] = {0};
    pid_t pid;
    int status = 0;

    if (needsStdOut)
    {
        if(pipe(pipeOut) == -1)
        {
            setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
            return -1;
        }
    }

    if (needsStdErr)
    {
        if(pipe(pipeErr) == -1)
        {
            setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
            return -1;
        }
    }

    pid = fork();
    if (pid == -1)
    {
        setEmptyOutputs(_iOutputs, _pStrOut, _pStrErr);
        return -1;
    }

    if (pid == 0)
    {
        /*** executed by the child process ***/
        // close #1: close read end of stdout/stderr pipe
        // dup2: redirect stdout/err in a pipe
        // close #2: close write end of stdout/stderr pipe
        if (needsStdOut)
        {
            close(pipeOut[0]);
            dup2(pipeOut[1], STDOUT_FILENO);
            if (needsStdErr)
            {
                close(pipeErr[0]);
                dup2(pipeErr[1], STDERR_FILENO);
                close(pipeErr[1]);
            }
            else
            {
                // merge stdout and stderr as same output
                dup2(pipeOut[1], STDERR_FILENO);
            }
            close(pipeOut[1]);
        }

        // execute the command
        execl("/bin/sh", "sh", "-c", scilab::UTF8::toUTF8(_pstCommand).data(), (char *)NULL);

        // if this code runs it because the execution has failed
        // exit the child process
        exit(EXIT_FAILURE);
    }

    /*** executed by the parent process (pid is the child pid) ***/

    // close write end of stdout/stderr pipe
    if (needsStdOut)
    {
        close(pipeOut[1]);
        pipeSpawnOut.pipe = pipeOut[0];
        if (needsStdErr)
        {
            close(pipeErr[1]);
            pipeSpawnErr.pipe = pipeErr[0];
        }
    }
#endif
    // host("echo OK 2>NUL", echo=%t)  
    // spawn threads for each output if needed
    if (needsStdOut)
    {
        __threadId threadStdOut;
        __threadId threadStdErr;
        __threadKey keyStdOut;
        __CreateThreadWithParams(&threadStdOut, &keyStdOut, &ReadFromPipe, &pipeSpawnOut);

        if (needsStdErr)
        {
            __threadKey keyStdErr;
            __CreateThreadWithParams(&threadStdErr, &keyStdErr, &ReadFromPipe, &pipeSpawnErr);
        }

        __WaitThreadDie(threadStdOut);
        if (needsStdErr)
        {
            __WaitThreadDie(threadStdErr);
        }
    }

    // waiting for the process to end
#ifdef _MSC_VER
    WaitForSingleObject(pi.hProcess, INFINITE);
    if (GetExitCodeProcess(pi.hProcess, &ExitCode) == STILL_ACTIVE)
    {
        TerminateProcess(pi.hProcess, 0);
    }

    CloseHandle(pi.hProcess);
    iExitCode = (int)ExitCode;
#else
    waitpid(pid, &status, 0);
    iExitCode = WEXITSTATUS(status);
#endif

    pcOutBuffer = pipeSpawnOut.buffer;
    pcErrBuffer = pipeSpawnErr.buffer;

    if (_iOutputs > 0)
    {
        char** output = NULL;
        int outlines = splitString(pcOutBuffer, &output);
        if (outlines && output[0] != NULL)
        {
            *_pStrOut = new types::String(outlines, 1);
            (*_pStrOut)->set(output);
            FREE(pcOutBuffer);
            FREE(output);
            output = NULL;
        }
        else
        {
            *_pStrOut = new types::String("");
        }

        if (_iOutputs == 2)
        {
            outlines = splitString(pcErrBuffer, &output);
            if (outlines && output[0] != NULL)
            {
                *_pStrErr = new types::String(outlines, 1);
                (*_pStrErr)->set(output);
                FREE(pcErrBuffer);
                FREE(output);
            }
            else
            {
                *_pStrErr = new types::String("");
            }
        }
    }

    return iExitCode;
}

void setEmptyOutputs(int _iOutputs, types::String** _pStrOut, types::String** _pStrErr)
{
    if (_iOutputs > 0)
    {
        *_pStrOut = new types::String("");
    }

    if (_iOutputs == 2)
    {
        *_pStrErr = new types::String("");
    }
}