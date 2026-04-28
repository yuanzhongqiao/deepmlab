/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2015 - Scilab Enterprises - Antoine ELIAS
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

#include <memory>

#include "debugmanager.hxx"
#include "threadmanagement.hxx"
#include "execvisitor.hxx"
#include "printvisitor.hxx"
#include "UTF8.hxx"

#include "threadId.hxx"

extern "C"
{
#include "Thread_Wrapper.h"
#include "storeCommand.h"
#include "pause.h"
#include "FileExist.h"
}

namespace debugger
{
std::unique_ptr<DebuggerManager> DebuggerManager::me(nullptr);

//singleton
DebuggerManager* DebuggerManager::getInstance()
{
    if (me.get() == nullptr)
    {
        me.reset(new DebuggerManager());
    }

    return me.get();
}

void DebuggerManager::addDebugger(const std::string& _name, AbstractDebugger* _debug)
{
    debuggers[_name] = _debug;
}

void DebuggerManager::removeDebugger(const std::string& _name)
{
    if (getDebugger(_name))
    {
        debuggers.erase(_name);
    }
}

AbstractDebugger* DebuggerManager::getDebugger(const std::string& _name)
{
    const auto& d = debuggers.find(_name);
    if (d != debuggers.end())
    {
        return debuggers[_name];
    }

    return NULL;
}

int DebuggerManager::getDebuggerCount()
{
    return (int)debuggers.size();
}

Debuggers& DebuggerManager::getAllDebugger()
{
    return debuggers;
}

void DebuggerManager::sendStop(int index)
{
    currentBreakPoint = index;
    for (const auto& it : debuggers)
    {
        it.second->onStop(index);
    }
}

void DebuggerManager::sendExecution()
{
    for (const auto& it : debuggers)
    {
        it.second->onExecution();
    }
}

void DebuggerManager::sendExecutionReleased()
{
    for (const auto& it : debuggers)
    {
        it.second->onExecutionReleased();
    }
}

void DebuggerManager::sendPrint(const std::string& variable)
{
    for (const auto& it : debuggers)
    {
        it.second->onPrint(variable);
    }
}

void DebuggerManager::sendShow(int bp)
{
    for (const auto& it : debuggers)
    {
        it.second->onShow(bp);
    }
}

void DebuggerManager::sendResume()
{
    currentBreakPoint = -1;
    for (const auto& it : debuggers)
    {
        it.second->onResume();
    }
}

void DebuggerManager::sendAbort()
{
    currentBreakPoint = -1;
    for (const auto& it : debuggers)
    {
        it.second->onAbort();
    }
}

void DebuggerManager::sendErrorInFile(const std::wstring& filename) const
{
    for (const auto& it : debuggers)
    {
        it.second->onErrorInFile(filename);
    }
}

void DebuggerManager::sendErrorInScript(const std::wstring& funcname) const
{
    for (const auto& it : debuggers)
    {
        it.second->onErrorInScript(funcname);
    }
}

void DebuggerManager::sendQuit()
{
    currentBreakPoint = -1;
    for (const auto& it : debuggers)
    {
        it.second->onQuit();
    }
}

void DebuggerManager::sendUpdate() const
{
    for (const auto& it : debuggers)
    {
        it.second->updateBreakpoints();
    }
}

void DebuggerManager::setAllBreakPoints(Breakpoints& _bps)
{
    // remove existing breakpoints
    for (auto bp : breakpoints)
    {
        delete bp;
    }
    breakpoints.clear();

    // set new breakpoints
    breakpoints.swap(_bps);
    sendUpdate();
}

Breakpoints::iterator DebuggerManager::findBreakPoint(Breakpoint* bp)
{
    Breakpoints::iterator found = std::find_if(breakpoints.begin(), breakpoints.end(),
                                  [&](Breakpoint * b)
    {
        bool isMacro = b->getFunctioName() != "" &&
                       b->getFunctioName() == bp->getFunctioName() &&
                       b->getMacroLine() == bp->getMacroLine();

        bool isFile  = b->getFileName() != "" &&
                       b->getFileName() == bp->getFileName() &&
                       b->getFileLine() == bp->getFileLine();

        return (isMacro || isFile);
    });

    return found;
}

bool DebuggerManager::addBreakPoint(Breakpoint* bp)
{
    //check if breakpoint does not exist
    Breakpoints::iterator iter = findBreakPoint(bp);
    if (iter == breakpoints.end())
    {
        breakpoints.push_back(bp);
        sendUpdate();
        return true;
    }

    return false;
}

bool DebuggerManager::updateBreakPoint(Breakpoint* bp)
{
    Breakpoints::iterator iter = findBreakPoint(bp);
    if (iter != breakpoints.end())
    {
        std::swap(*iter, bp);
        delete bp;
        return true;
    }

    return false;
}

bool DebuggerManager::removeBreakPoint(Breakpoint* bp)
{
    Breakpoints::iterator iter = findBreakPoint(bp);
    if (iter != breakpoints.end())
    {
        delete *iter;
        breakpoints.erase(iter);
        return true;
    }

    return false;
}

void DebuggerManager::removeBreakPoint(int _iBreakPoint)
{
    if (_iBreakPoint >= 0 && _iBreakPoint <= (int)breakpoints.size())
    {
        Breakpoints::iterator it = breakpoints.begin() + _iBreakPoint;
        delete *it;
        breakpoints.erase(it);
        sendUpdate();
    }
}

void DebuggerManager::removeAllBreakPoints()
{
    breakpoints_lock.lock();
    Breakpoints::iterator it = breakpoints.begin();
    for (; it != breakpoints.end(); ++it)
    {
        delete *it;
    }

    breakpoints.clear();
    breakpoints_lock.unlock();
    sendUpdate();
}

void DebuggerManager::disableBreakPoint(int _iBreakPoint)
{
    if (_iBreakPoint >= 0 && _iBreakPoint <= (int)breakpoints.size())
    {
        breakpoints[_iBreakPoint]->setDisable();
        sendUpdate();
    }
}

void DebuggerManager::disableAllBreakPoints()
{
    for (const auto& it : breakpoints)
    {
        it->setDisable();
    }

    sendUpdate();
}

void DebuggerManager::enableBreakPoint(int _iBreakPoint)
{
    if (_iBreakPoint >= 0 && _iBreakPoint <= (int)breakpoints.size())
    {
        breakpoints[_iBreakPoint]->setEnable();
        sendUpdate();
    }
}

void DebuggerManager::enableAllBreakPoints()
{
    for (const auto& it : breakpoints)
    {
        it->setEnable();
    }

    sendUpdate();
}

bool DebuggerManager::isEnableBreakPoint(int _iBreakPoint)
{
    if (_iBreakPoint >= 0 && _iBreakPoint <= (int)breakpoints.size())
    {
        return breakpoints[_iBreakPoint]->isEnable();
    }

    return false;
}

Breakpoint* DebuggerManager::getBreakPoint(int _iBreakPoint)
{
    if (_iBreakPoint >= 0 && _iBreakPoint < (int)breakpoints.size())
    {
        return breakpoints[_iBreakPoint];
    }

    return NULL;
}

int DebuggerManager::getBreakPointCount()
{
    return (int)breakpoints.size();
}

Breakpoints& DebuggerManager::getAllBreakPoint()
{
    return breakpoints;
}

void DebuggerManager::generateCallStack()
{
    clearCallStack();

    std::wostringstream ostr;
    ast::PrintVisitor pp(ostr, true, true, true);
    getExp()->accept(pp);
    callstack.exp = scilab::UTF8::toUTF8(ostr.str());

    // - When stopped on error, generate the call stack from whereError
    //   because "where" may have been unstacked (ie: parsing error in exec)
    // - When stopped on breakpoint or paused, generate the call stack
    //   from "where" because where error is not filled.
    if(ConfigVariable::isError())
    {
        //where error
        const auto& whereError = ConfigVariable::getWhereError();

        Stack cs;
        for (const auto& elem : whereError)
        {
            StackRow row;
            row.functionName = scilab::UTF8::toUTF8(elem.m_function_name);
            row.functionLine = elem.m_line - 1;
            if (callstackAddFile(&row, elem.m_file_name))
            {
                row.fileLine = elem.m_line;
                row.functionLine = -1;
                row.column = elem.m_Location.first_column;
                if (elem.m_first_line)
                {
                    row.fileLine = elem.m_first_line + elem.m_line - 1;
                    row.functionLine = elem.m_line - 1;
                }
            }

            row.scope = elem.m_scope_lvl;
            cs.push_back(row);
        }

        callstack.stack = cs;
        ConfigVariable::resetWhereError();
    }
    else
    {
        //where
        const std::vector<ConfigVariable::WhereEntry>& where = ConfigVariable::getWhere();
        // skip fake pause name
        auto it_name = where.rbegin();
        ++it_name;

        Stack cs;
        for (auto it_line = where.rbegin(); it_name != where.rend(); it_name++, it_line++)
        {
            StackRow row;
            row.functionName = scilab::UTF8::toUTF8(it_name->call->getName());
            row.functionLine = it_line->m_line - 1;
            if (it_name->m_file_name != nullptr && callstackAddFile(&row, *it_name->m_file_name))
            {
                row.fileLine = it_line->m_line;
                row.functionLine = -1;
                row.column = it_line->m_Location.first_column;

                if (it_name->call->getFirstLine())
                {
                    row.fileLine = it_name->call->getFirstLine() + it_line->m_line - 1;
                    row.functionLine = it_line->m_line - 1;
                }
            }

            row.scope = it_line->m_scope_lvl;
            cs.push_back(row);
        }

        callstack.stack = cs;
    }
}

bool DebuggerManager::callstackAddFile(StackRow* _row, const std::wstring& _fileName)
{
    _row->hasFile = false;
    if (_fileName.empty())
    {
        return false;
    }

    std::string pstrFileName = scilab::UTF8::toUTF8(_fileName);
    _row->hasFile = true;
    // replace .bin by .sci
    size_t pos = pstrFileName.rfind(".bin");
    if (pos != std::string::npos)
    {
        pstrFileName.replace(pos, 4, ".sci");
        // do not add the file in the callstack if the associeted .sci is not available
        if (FileExist(pstrFileName.data()) == false)
        {
            _row->hasFile = false;
        }
    }

    if (_row->hasFile)
    {
        _row->fileName = pstrFileName;
    }

    return _row->hasFile;
}

void DebuggerManager::print(const std::string& variable)
{
    //inform debuggers
    sendPrint(variable);
}

void DebuggerManager::show(int bp)
{
    //inform debuggers
    sendShow(bp);
}

char* DebuggerManager::execute(const std::string& command)
{
    char* error = checkCommand(command.data());
    if (error)
    {
        return error;
    }

    // reset abort flag befor a new execution
    resetAborted();

    // inform debuggers
    sendExecution();
    // execute command and wait
    StoreCommandWithFlags(command.data(), 0, 1, DEBUGGER);

    return nullptr;
}

char* DebuggerManager::executeNow(const std::string& command, int iWaitForIt)
{
    char* error = checkCommand(command.data());
    if (error)
    {
        return error;
    }

    // reset abort flag befor a new execution
    resetAborted();

    // inform debuggers
    sendExecution();
    // execute command and wait
    StoreDebuggerCommand(command.data(), iWaitForIt);

    return nullptr;
}

void DebuggerManager::resume(int iWait) //resume execution
{
    //inform debuggers
    sendResume();

    // reset callstack
    clearCallStack();

    StoreDebuggerCommand("resume", iWait);
}

void DebuggerManager::requestPause() //ask for pause
{
    // pause on execution only if a command is running
    if (interrupted == false)
    {
        request_pause = true;
    }
}

bool DebuggerManager::isPauseRequested() //pause execution
{
    return request_pause;
}

void DebuggerManager::resetPauseRequest() //pause execution
{
    request_pause = false;
}

void DebuggerManager::abort() //abort execution
{
    //inform debuggers
    sendAbort();

    // this state is check by the debuggerVisitor to do abort in the main thread
    setAborted();

    // reset requested pause in case we abort before beeing in pause
    resetPauseRequest();

    // abort in a pause
    if (isInterrupted())
    {
        // reset lasterror information
        ConfigVariable::clearLastError();
        // reset error flag
        ConfigVariable::resetError();
        // reset callstack
        clearCallStack();

        StoreDebuggerCommand("abort", true);
    }
}

int DebuggerManager::get_current_level()
{
    if(isInterrupted())
    {
        return ConfigVariable::getWhere().size() - 1; // -1 remove pause from the level, see DebuggerManager::internal_stop
    }
    else
    {
        return ConfigVariable::getWhere().size();
    }
    
}

void DebuggerManager::internal_stop()
{
    interrupted = true;

    // Create a fake pause call to retrieve good lines in
    // where or whereami when stopped on breakpoint.
    // This a no effect when stopped on error because where error has already been filled
    // and will be used to generate the callstack.
    int iFirstLine = getExp()->getLocation().first_line;
    types::Macro* pFakePause = new types::Macro();
    pFakePause->setName(L"pause");
    pFakePause->setLines(iFirstLine, getExp()->getLocation().last_line);
    ConfigVariable::where_begin(iFirstLine + 1 - ConfigVariable::getMacroFirstLines(), pFakePause, getExp()->getLocation());
    ConfigVariable::macroFirstLine_begin(2);

    generateCallStack();
    // release the debugger thread
    ThreadManagement::SendDebuggerExecDoneSignal();
    sendExecutionReleased();
    // wait inside pause
    try
    {
        pause_interpreter();
    }
    catch (const ast::InternalAbort& ia)
    {
        ConfigVariable::macroFirstLine_end();
        // can append when aborting an execution
        // which is running inside a pause
        ConfigVariable::where_end();
        interrupted = false;
        throw ia;
    }

    ConfigVariable::macroFirstLine_end();
    ConfigVariable::where_end();
    interrupted = false;
}

void DebuggerManager::stop(const ast::Exp* pExp, int index)
{
    //send stop information to all debuggers
    setExp(pExp);
    sendStop(index);
    // because stop is used only in the debuggervisitor the pause
    // will be executed in the main thread (where is executed the command)
    internal_stop();
    clearExp();
}

void DebuggerManager::errorInFile(const std::wstring filename, const ast::Exp* pExp)
{
    setExp(pExp);
    sendErrorInFile(filename);
    internal_stop();
    clearExp();
}
void DebuggerManager::errorInScript(const std::wstring funcname, const ast::Exp* pExp)
{
    setExp(pExp);
    sendErrorInScript(funcname);
    internal_stop();
    clearExp();
}

// return false if a file .sci of a file .bin doesn't exists
// return true for others files or existing .sci .sce
bool DebuggerManager::getSourceFile(std::string* filename)
{
    const std::vector<ConfigVariable::WhereEntry>& lWhereAmI = ConfigVariable::getWhere();
    // "Where" can be empty at the end of script execution
    // this function is called when the script ends after a step out
    if(lWhereAmI.empty())
    {
        return false;
    }

    if(lWhereAmI.back().m_file_name == nullptr)
    {
        return false;
    }

    std::string file = scilab::UTF8::toUTF8(*lWhereAmI.back().m_file_name);
    if (file.rfind(".bin") != std::string::npos)
    {
        file.replace(file.size() - 4, 4, ".sci");
        // stop on bp only if the file exist
        if (!FileExist(file.data()))
        {
            return false;
        }
    }

    if(filename != nullptr)
    {
        filename->assign(file);
    }

    return true;
}
}
