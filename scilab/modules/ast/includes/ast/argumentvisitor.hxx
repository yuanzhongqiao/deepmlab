/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#ifndef AST_ARGUMENTVISITOR_HXX
#define AST_ARGUMENTVISITOR_HXX

#include <iostream>
#include <sstream>
#include <string>
#include <time.h>

#include "dummyvisitor.hxx"
#include "logicalopexp.hxx"

namespace ast
{
class ArgumentVisitor : public DummyVisitor
{
public:
    ArgumentVisitor() : status(true) {}
    ~ArgumentVisitor() {}

    bool getStatus() { return status; }

    virtual void visit(const CallExp& e)
    {
        if (e.getName().isSimpleVar())
        {
            std::wstring name = e.getName().getAs<SimpleVar>()->getSymbol().getName();
            if (funcs.find(name) == funcs.end())
            {
                status = false;
            }
        }
        else
        {
            status = false;
        }

        //check args
        exps_t args = e.getArgs();
        for (auto arg : args)
        {
            arg->accept(*this);
        }
    }

private: 
    std::set<std::wstring> funcs = {L"ones", L"zeros", L"int8", L"int16", L"int32", L"int64", L"uint8", L"uint16", L"uint32", L"uint64"};
    bool status;
};
} // namespace ast

#endif /* !AST_ARGUMENTVISITOR_HXX*/