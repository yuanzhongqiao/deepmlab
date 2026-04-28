/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2015 - Scilab Enterprises - Calixte DENIZET
 *  Copyright (C) 2012 - 2016 - Scilab Enterprises
 *  Copyright (C) 2017 - 2020 - Samuel GOUGEON
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "checkers/DeprecatedChecker.hxx"
#include "callexp.hxx"
#include "simplevar.hxx"
#include "doubleexp.hxx"
#include "getdeprecated.hxx"

namespace slint
{

std::unordered_map<std::wstring, std::wstring> DeprecatedChecker::deprecated = initDep();
std::unordered_map<std::wstring, std::shared_ptr<SLintChecker>> DeprecatedChecker::partiallyDeprecated = initPartDep();

void DeprecatedChecker::preCheckNode(const ast::Exp & e, SLintContext & context, SLintResult & result)
{
    const ast::CallExp & ce = static_cast<const ast::CallExp &>(e);
    if (ce.getName().isSimpleVar())
    {
        const std::wstring & name = static_cast<const ast::SimpleVar &>(ce.getName()).getSymbol().getName();
        const auto i = deprecated.find(name);
        if (i != deprecated.end())
        {
            if (i->second.empty())
            {
                result.report(context, e.getLocation(), *this, _("Deprecated function: %s."), name);
            }
            else
            {
                result.report(context, e.getLocation(), *this, _("Deprecated function %s: use %s instead."), name, i->second);
            }
        }
        else
        {
            const auto i = partiallyDeprecated.find(name);
            if (i != partiallyDeprecated.end())
            {
                i->second->preCheckNode(e, context, result);
            }
        }
    }
}

void DeprecatedChecker::postCheckNode(const ast::Exp & e, SLintContext & context, SLintResult & result)
{
}

const std::string DeprecatedChecker::getName() const
{
    return "DeprecatedChecker";
}

void DeprecatedChecker::__Svd::preCheckNode(const ast::Exp & e, SLintContext & context, SLintResult & result)
{
    const ast::CallExp & ce = static_cast<const ast::CallExp &>(e);
    const ast::exps_t args = ce.getArgs();
    if (args.size() == 2)
    {
        const ast::Exp & second = *args.back();
        if (second.isDoubleExp() && static_cast<const ast::DoubleExp &>(second).getValue() == 0)
        {
            result.report(context, e.getLocation(), *this, _("svd(..., 0) is deprecated."));
        }
    }
}

void DeprecatedChecker::__Mfprintf::preCheckNode(const ast::Exp & e, SLintContext & context, SLintResult & result)
{
    const ast::CallExp & ce = static_cast<const ast::CallExp &>(e);
    const ast::exps_t args = ce.getArgs();
    if (args.size() != 0)
    {
        const ast::Exp & first = *args.front();
        if (first.isDoubleExp() && static_cast<const ast::DoubleExp &>(first).getValue() == -1)
        {
            result.report(context, e.getLocation(), *this, _("mfprintf(-1, ...) is deprecated."));
        }
    }
}

std::unordered_map<std::wstring, std::wstring> DeprecatedChecker::initDep()
{
    std::unordered_map<std::wstring, std::wstring> map = getDeleted();
    map.merge(getDeprecated());
    return map;
}

std::unordered_map<std::wstring, std::shared_ptr<SLintChecker>> DeprecatedChecker::initPartDep()
{
    std::unordered_map<std::wstring, std::shared_ptr<SLintChecker>> map;
    map.emplace(L"svd", std::shared_ptr<SLintChecker>(new __Svd()));
    map.emplace(L"mfprintf", std::shared_ptr<SLintChecker>(new __Mfprintf()));

    return map;
}
}
