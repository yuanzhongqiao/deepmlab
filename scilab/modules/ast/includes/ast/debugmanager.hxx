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

#ifndef __DEBUGGER_MANAGER_HXX__
#define __DEBUGGER_MANAGER_HXX__

#include <memory>
#include <mutex>

#include "abstractdebugger.hxx"
#include "configvariable.hxx"
#include "breakpoint.hxx"
#include "dynlib_ast.h"

namespace debugger
{
class EXTERN_AST DebuggerManager
{
public:
    enum DebugAction
    {
        Continue,
        Aborted,
        StepNext,
        StepIn,
        StepOut
    };

    struct StackRow
    {
        std::string functionName;
        std::string fileName;
        int functionLine;
        int fileLine;
        int scope;
        int column;
        bool hasFile = false;
    };

    typedef std::vector<StackRow> Stack;
    struct CallStack
    {
        std::string exp;
        Stack stack;
    };

private:
    static std::unique_ptr<DebuggerManager> me;
    DebuggerManager() :
        breakpoints(),
        callstack(),
        debuggers(),
        pExp(nullptr),
        interrupted(false),
        request_pause(false),
        currentBreakPoint(-1),
        action(Continue),
        level(0) {}

    std::mutex breakpoints_lock;
    Breakpoints breakpoints;
    CallStack callstack;
    Debuggers debuggers;

    ast::Exp* pExp;
    bool interrupted;
    bool request_pause;
    int currentBreakPoint;
    DebugAction action;
    int level;

    void internal_stop();
    int get_current_level();
    bool callstackAddFile(StackRow* _row, const std::wstring& _fileName);

public:
    ~DebuggerManager()
    {
        for (auto d : debuggers)
        {
            delete d.second;
        }

        for (auto b : breakpoints)
        {
            delete b;
        }

        clearCallStack();
    }

    static DebuggerManager* getInstance();

    //debuggers functions
    void addDebugger(const std::string& _name, AbstractDebugger* _debug);
    void removeDebugger(const std::string& _name);
    AbstractDebugger* getDebugger(const std::string& _name);
    int getDebuggerCount();
    Debuggers& getAllDebugger();

    void setExp(const ast::Exp* _pExp)
    {
        pExp = const_cast<ast::Exp*>(_pExp);
    }
    void clearExp()
    {
        pExp = NULL;
    }
    ast::Exp* getExp()
    {
        return pExp;
    }

    bool isInterrupted()
    {
        return interrupted;
    }

    Breakpoint* getCurrentBreakPoint()
    {
        if (currentBreakPoint != -1)
        {
            return getBreakPoint(currentBreakPoint);
        }

        return nullptr;
    }

    void generateCallStack();
    inline void clearCallStack()
    {
        callstack.exp.clear();
        callstack.stack.clear();
    }

    CallStack& getCallStack()
    {
        return callstack;
    }

    //send information to debuggers
    void sendStop(int index);
    void sendExecution();
    void sendExecutionReleased();
    void sendPrint(const std::string& variable);
    void sendShow(int bp);
    void sendResume();
    void sendAbort();
    void sendErrorInFile(const std::wstring& filename) const;
    void sendErrorInScript(const std::wstring& funcname) const;
    void sendQuit();
    void sendUpdate() const;

    void stop(const ast::Exp* pExp, int index);
    void errorInFile(const std::wstring filename, const ast::Exp* pExp);
    void errorInScript(const std::wstring funcname, const ast::Exp* pExp);

    //breakpoints functions
    bool addBreakPoint(Breakpoint* bp);
    bool updateBreakPoint(Breakpoint* bp);
    bool removeBreakPoint(Breakpoint* bp);
    Breakpoints::iterator findBreakPoint(Breakpoint* bp);
    void removeBreakPoint(int _iBreakPoint);
    void setAllBreakPoints(Breakpoints& _bps);
    void removeAllBreakPoints();
    void disableAllBreakPoints();
    void disableBreakPoint(int _iBreakPoint);
    void enableAllBreakPoints();
    void enableBreakPoint(int _iBreakPoint);
    bool isEnableBreakPoint(int _iBreakPoint);
    Breakpoint* getBreakPoint(int _iBreakPoint);
    int getBreakPointCount();
    Breakpoints& getAllBreakPoint();
    void lockBreakpoints()
    {
        breakpoints_lock.lock();
    }
    void unlockBreakpoints()
    {
        breakpoints_lock.unlock();
    }

    //actions called by debuggers
    inline void setStepIn()
    {
        action = StepIn;
        level = get_current_level();
    }

    inline bool isStepIn()
    {
        return action == StepIn && get_current_level() > level;
    }

    inline void resetStepIn()
    {
        if (isStepIn())
        {
            action = Continue;
        }
    }

    inline void setStepOut()
    {
        action = StepOut;
        level = get_current_level();
    }

    inline bool isStepOut()
    {
        // StepIn/StepNext: when stepIn/StepNext at the end of a body, considere it as stepOut
        return (action == StepOut || action == StepNext || action == StepIn) && get_current_level() < level;
    }

    inline void resetStepOut()
    {
        if (isStepOut())
        {
            action = Continue;
        }
    }

    inline void setAborted()
    {
        action = Aborted;
    }

    inline bool isAborted()
    {
        return action == Aborted;
    }

    inline void resetAborted()
    {
        if (isAborted())
        {
            action = Continue;
        }
    }

    inline void setStepNext()
    {
        action = StepNext;
        level = get_current_level();
    }

    inline bool isStepNext()
    {
        // StepIn: when stepIn after stepOut, considere stepIn as StepNext
        return (action == StepNext || action == StepIn) && get_current_level() == level;
    }

    inline void resetStepNext()
    {
        if (isStepNext())
        {
            action = Continue;
        }
    }

    inline void resetStep()
    {
        if (isInterrupted() == false)
        {
            action = Continue;
        }
    }

    char* execute(const std::string& command); //execute a non prioritary command
    char* executeNow(const std::string& command, int iWaitForIt = 1); //execute a prioritary command
    void print(const std::string& variable); //print a variable
    void show(int bp); //print the breakpoint bp or all breakpoints (bp = -1)
    void resume(int iWait = true); //resume execution
    void abort(); //abort execution
    void requestPause(); //pause execution
    bool isPauseRequested(); //get pause request status
    void resetPauseRequest(); //reset pause request status
    bool getSourceFile(std::string* filename = nullptr);
};

}
#endif /* !__DEBUGGER_MANAGER_HXX__ */
