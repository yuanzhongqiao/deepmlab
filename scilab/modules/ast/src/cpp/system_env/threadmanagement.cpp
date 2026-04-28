/*
*  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2015 - Scilab Enterprises - Cedric DELAMARRE
*
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
*
*/

#include "threadmanagement.hxx"
#include "runner.hxx"

#ifdef DEBUG_THREAD
#include <iostream>
#include <iomanip>

#define PRINT_COL_SIZE 32

__threadKey ThreadManagement::m_tkMain;
__threadKey ThreadManagement::m_tkReadAndExec;
__threadKey ThreadManagement::m_tkConsole;
#endif // DEBUG_THREAD

__threadLock ThreadManagement::m_ParseLock;
__threadLock ThreadManagement::m_StoreCommandLock;
__threadLock ThreadManagement::m_ScilabReadLock;

__threadSignal ThreadManagement::m_ConsoleExecDone;
__threadSignalLock ThreadManagement::m_ConsoleExecDoneLock;

__threadSignal ThreadManagement::m_DebuggerExecDone;
__threadSignalLock ThreadManagement::m_DebuggerExecDoneLock;

__threadSignal ThreadManagement::m_StartPending;
__threadSignalLock ThreadManagement::m_StartPendingLock;

__threadSignal ThreadManagement::m_CommandStored;
__threadSignalLock ThreadManagement::m_CommandStoredLock;

bool ThreadManagement::m_ConsoleExecDoneWasSignalled    = false;
bool ThreadManagement::m_DebuggerExecDoneWasSignalled   = false;
bool ThreadManagement::m_StartPendingWasSignalled       = false;
bool ThreadManagement::m_CommandStoredWasSignalled      = false;

void ThreadManagement::initialize()
{
    __InitLock(&m_ParseLock);
    __InitLock(&m_StoreCommandLock);
    __InitLock(&m_ScilabReadLock);

    __InitSignal(&m_ConsoleExecDone);
    __InitSignalLock(&m_ConsoleExecDoneLock);

    __InitSignal(&m_DebuggerExecDone);
    __InitSignalLock(&m_DebuggerExecDoneLock);

    __InitSignal(&m_StartPending);
    __InitSignalLock(&m_StartPendingLock);

    __InitSignal(&m_CommandStored);
    __InitSignalLock(&m_CommandStoredLock);
}

/***
    [Runner Lock]
    Used when we want to access to the Parser.
***/
void ThreadManagement::LockParser(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("LockParser");
#endif // DEBUG_THREAD
    __Lock(&m_ParseLock);
}

void ThreadManagement::UnlockParser(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("UnlockParser");
#endif // DEBUG_THREAD
    __UnLock(&m_ParseLock);
}

/***
    [Runner Lock]
    Used when we want to access to the Store Command.
***/
void ThreadManagement::LockStoreCommand(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("LockStoreCommand");
#endif // DEBUG_THREAD
    __Lock(&m_StoreCommandLock);
}

void ThreadManagement::UnlockStoreCommand(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("UnlockStoreCommand");
#endif // DEBUG_THREAD
    __UnLock(&m_StoreCommandLock);
}

/***
    [ScilabRead Lock]
    Used to manage scilabRead output wich can be used by Console thread or
    main thread through mscanf function.
***/
void ThreadManagement::LockScilabRead(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("LockScilabRead");
#endif // DEBUG_THREAD
    __Lock(&m_ScilabReadLock);
}

void ThreadManagement::UnlockScilabRead(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("UnlockScilabRead");
#endif // DEBUG_THREAD
    __UnLock(&m_ScilabReadLock);
}

/***
    [ConsoleExecDone Signal]

    Send : A console command is excuted.
    Wait : Wait for the last console command ends.

    This signal can be sent without any threads are waiting for,
    so we have to perform the Wait for each call to WaitForConsoleExecDoneSignal.
    (in case of "pause", we send this signal in sci_pause and in Runner::launch)

    The loop while is used to avoid spurious wakeup of __Wait.
***/
void ThreadManagement::SendConsoleExecDoneSignal(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("SendConsoleExecDoneSignal");
#endif // DEBUG_THREAD
    __LockSignal(&m_ConsoleExecDoneLock);
    m_ConsoleExecDoneWasSignalled = true;
    __Signal(&m_ConsoleExecDone);
    __UnLockSignal(&m_ConsoleExecDoneLock);
}

void ThreadManagement::WaitForConsoleExecDoneSignal(void)
{
# ifdef __DEBUG_SIGNAL
    std::cout << "WaitForConsoleExecDoneSignal" << std::endl;
# endif // __DEBUG_SIGNAL
    __LockSignal(&m_ConsoleExecDoneLock);
    ThreadManagement::UnlockStoreCommand();
    m_ConsoleExecDoneWasSignalled = false;
    while (m_ConsoleExecDoneWasSignalled == false)
    {
#ifdef DEBUG_THREAD
        PrintDebug("WaitForConsoleExecDoneSignal");
#endif // DEBUG_THREAD
        __Wait(&m_ConsoleExecDone, &m_ConsoleExecDoneLock);
    }
    __UnLockSignal(&m_ConsoleExecDoneLock);
}

/***
    [DebuggerExecDone Signal]

    Send : A debugger command is excuted.
    Wait : Wait for its execution.

    This signal can be sent without any threads are waiting for,
    so we have to perform the Wait for each call to WaitForDebuggerExecDoneSignal.
    (in case of "pause", we send this signal in sci_pause and in Runner::launch)

    The loop while is used to avoid spurious wakeup of __Wait.
***/
void ThreadManagement::SendDebuggerExecDoneSignal(void)
{
#ifdef DEBUG_THREAD
    PrintDebug("SendDebuggerExecDoneSignal");
#endif // DEBUG_THREAD
    __LockSignal(&m_DebuggerExecDoneLock);
    m_DebuggerExecDoneWasSignalled = true;
    __Signal(&m_DebuggerExecDone);
    __UnLockSignal(&m_DebuggerExecDoneLock);
}

// bResume: resume execution before wait for its end
void ThreadManagement::WaitForDebuggerExecDoneSignal()
{
# ifdef __DEBUG_SIGNAL
    std::cout << "WaitForDebuggerExecDoneSignal" << std::endl;
# endif // __DEBUG_SIGNAL
    __LockSignal(&m_DebuggerExecDoneLock);
    ThreadManagement::UnlockStoreCommand();
    m_DebuggerExecDoneWasSignalled = false;
    while (m_DebuggerExecDoneWasSignalled == false)
    {
#ifdef DEBUG_THREAD
        PrintDebug("WaitForDebuggerExecDoneSignal");
#endif // DEBUG_THREAD
        __Wait(&m_DebuggerExecDone, &m_DebuggerExecDoneLock);
    }
    __UnLockSignal(&m_DebuggerExecDoneLock);
}

/***
    [StartPending Signal]

    This signal is used in case where we have a console thread and a command to execute passed by -f argument.
    We have to waiting for the "-f" execution before lets users to enter a new command through the console.

    Send : The console thread (scilabReadAndStore) is ready.
    Wait : The main thread can create the read and exec command thread (scilabReadAndExecCommand).

    To avoid non-expected lost signal, we have to check if the signal was
    already sent to know if we have to waiting for or not.

    The loop while is used to avoid spurious wakeup of __Wait.
***/
void ThreadManagement::SendStartPendingSignal(void)
{
# ifdef __DEBUG_SIGNAL
    std::cout << "SendStartPendingSignal" << std::endl;
# endif // __DEBUG_SIGNAL
    __LockSignal(&m_StartPendingLock);
    m_StartPendingWasSignalled = true;
#ifdef DEBUG_THREAD
    PrintDebug("SendStartPendingSignal");
#endif // DEBUG_THREAD
    __Signal(&m_StartPending);
    __UnLockSignal(&m_StartPendingLock);
}

void ThreadManagement::WaitForStartPendingSignal(void)
{
# ifdef __DEBUG_SIGNAL
    std::cout << "WaitForStartPendingSignal" << std::endl;
# endif // __DEBUG_SIGNAL
    __LockSignal(&m_StartPendingLock);
    while (m_StartPendingWasSignalled == false)
    {
#ifdef DEBUG_THREAD
        PrintDebug("WaitForStartPendingSignal");
#endif // DEBUG_THREAD
        __Wait(&m_StartPending, &m_StartPendingLock);
    }
    m_StartPendingWasSignalled = false;
    __UnLockSignal(&m_StartPendingLock);
}

/***
    [CommandStored Signal]

    Send : A new command is available in the store command.
    Wait : Wait for a new command.

    To avoid non-expected lost signal, we have to check if the signal was
    already sent to know if we have to waiting for or not.

    The loop while is used to avoid spurious wakeup of __Wait.
***/
void ThreadManagement::SendCommandStoredSignal(void)
{
    __LockSignal(&m_CommandStoredLock);
    m_CommandStoredWasSignalled = true;
#ifdef DEBUG_THREAD
    PrintDebug("SendCommandStoredSignal");
#endif // DEBUG_THREAD
    __Signal(&m_CommandStored);
    __UnLockSignal(&m_CommandStoredLock);
}

void ThreadManagement::WaitForCommandStoredSignal(void)
{
    m_CommandStoredWasSignalled = isEmptyCommandQueue() ? false : true;
    __LockSignal(&m_CommandStoredLock);
    while (m_CommandStoredWasSignalled == false)
    {
#ifdef DEBUG_THREAD
        PrintDebug("WaitForCommandStoredSignal");
#endif // DEBUG_THREAD
        __Wait(&m_CommandStored, &m_CommandStoredLock);
    }
    m_CommandStoredWasSignalled = false;
    __UnLockSignal(&m_CommandStoredLock);
}

#ifdef DEBUG_THREAD
void ThreadManagement::SetThreadKey(__threadKey tkMain, __threadKey tkConsole)
{
    m_tkMain = tkMain;
    m_tkConsole = tkConsole;
}

void ThreadManagement::PrintDebug(const char* pcfunName)
{
    if (__GetCurrentThreadKey() == m_tkConsole)
    {
        std::cout.width(PRINT_COL_SIZE);
        std::cout << " ";
    }
    else if (__GetCurrentThreadKey() != m_tkMain)
    {
        std::cout.width(2*PRINT_COL_SIZE);
        std::cout << " ";
    }

    std::cout << pcfunName << std::endl;
}

void ThreadManagement::PrintDebugHead()
{
    std::cout << std::endl;
    std::cout.fill('-');
    std::cout.width(3 * PRINT_COL_SIZE);
    std::cout << "-";

    std::cout.fill(' ');
    std::cout << std::endl;
    std::cout << std::left;
    std::cout.width(PRINT_COL_SIZE);
    std::cout << "Main Thread";
    std::cout.width(PRINT_COL_SIZE);
    std::cout << "Console Thread";
    std::cout.width(2*PRINT_COL_SIZE);
    std::cout << "Other Threads";
    std::cout << std::endl << std::endl;
}
#endif // DEBUG_THREAD
