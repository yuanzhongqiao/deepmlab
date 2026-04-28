/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "classdef.hxx"
#include "object.hxx"
#include "context.hxx"
#include "runvisitor.hxx"

extern "C"
{
#include "sciprint.h"
}

namespace types
{
Classdef::Classdef(const std::wstring& name,
    const std::map<std::wstring, OBJ_ATTR>& properties,
    const std::map<std::wstring, OBJ_ATTR>& methods,
    const std::map<std::wstring, std::vector<types::InternalType*>>& enums,
    const std::vector<std::wstring>& super)
    : name(name), props(properties), meths(methods), enumerations(enums), superclass(super), initialized(false)
{
    std::reverse(superclass.begin(), superclass.end());
}

void Classdef::LoadClassdef()
{
    if (initialized == true)
    {
        return;
    }

    for (auto&& s : superclass)
    {
        Classdef* def = symbol::Context::getInstance()->getClassdef(s);
        if (def)
        {
            supers.push_back({s, def});
        }
        else
        {
            char msg[128];
            os_sprintf(msg, _("'%s' does not exist\n"), scilab::UTF8::toUTF8(s).data());
            throw ast::InternalError(scilab::UTF8::toWide(msg));
        }
    }

    //classdef A < B & C => C in first and after B
    for (auto&& s : superclass)
    {
        Classdef* def = symbol::Context::getInstance()->getClassdef(s);
        def->LoadClassdef();
        auto supermethods = def->getMethods();
        for (auto&& v : supermethods)
        {
            OBJ_ATTR attr = std::get<0>(v.second);
            // reduce level
            attr.access = reduceAccess(attr.access);
            this->methods[v.first] = {attr, def};
        }

        auto superproperties = def->getProperties();
        for (auto&& v : superproperties)
        {
            OBJ_ATTR attr = std::get<0>(v.second);
            attr.access = reduceAccess(attr.access);
            this->properties[v.first] = {attr, def};
        }

        auto superconstructors = def->getConstructors();
        for (auto&& v : superconstructors)
        {
            OBJ_ATTR attr = std::get<0>(v.second);
            attr.access = reduceAccess(attr.access);
            this->constructors[v.first] = {attr, def};
        }
    }

    // fill vtable
    for (auto&& m : meths)
    {
        if (m.first == getName())
        {
            OBJ_ATTR attr;
            attr.access = m.second.access;
            attr.callable = m.second.callable;
            constructors[getName()] = {attr, this};
            continue;
        }

        m.second.hidden = false;
        methods[m.first] = {m.second, this};
    }

    for (auto&& p : props)
    {
        p.second.hidden = false;
        properties[p.first] = {p.second, this};
    }

    addHelpers();
    //showMethodTable();

    //default empty constructor information
    if (constructors.find(getName()) == constructors.end())
    {
        OBJ_ATTR attr;
        attr.access = AccessModifier::PUBLIC;
        attr.callable = nullptr;
        constructors[getName()] = {attr, this};
    }

    // static
    /*
    for (auto&& p : properties)
    {
        if (p.second.isStatic)
        {
            addStaticProperty(p.first, p.second);
        }
    }

    for (auto&& m : methods)
    {
        if (m.second.isStatic)
        {
            addStaticMethod(m.first, m.second);
        }
    }
    */

    //clean constructor information
    props.clear();
    meths.clear();
    superclass.clear();
    initialized = true;
}

bool Classdef::toString(std::wostringstream& ostr)
{
    /*
    if (properties.size() > 0)
    {
        std::wostringstream prop_ostr;
        for (auto&& p : properties)
        {
            OBJ_ATTR attr = std::get<0>(p.second);
            if (attr.access == AccessModifier::PUBLIC)
            {
                prop_ostr << "    " << p.first << std::endl;
            }
        }

        if (prop_ostr.str().size() != 0)
        {
            ostr << L"with properties :" << std::endl;
            ostr << prop_ostr.str();
        }
    }

    if (methods.size() > 0)
    {
        std::wostringstream method_ostr;
        for (auto&& m : methods)
        {
            OBJ_ATTR attr = std::get<0>(m.second);
            if (attr.hidden == false && attr.access == AccessModifier::PUBLIC)
            {
                method_ostr << "    " << m.first << std::endl;
            }
        }

        if (method_ostr.str().size() != 0)
        {
            ostr << L"with methods:" << std::endl;
            ostr << method_ostr.str();
        }
    }

    if (enumerations.size() > 0)
    {
        ostr << L"with enumeration :" << std::endl;
        for (auto&& e : enumerations)
        {
            ostr << "    " << e.first << std::endl;
        }
    }
    */

    ostr << L"Constructor of classdef \"" << name << L"\"" << std::endl;
    return true;
}

void Classdef::showMethodTable()
{
    int max_len = 0;
    for (auto&& v : methods)
    {
        max_len = std::max(max_len, (int)v.first.length());
    }

    for (auto&& v : methods)
    {
        std::wstring access;
        switch (std::get<0>(v.second).access)
        {
            case AccessModifier::PUBLIC:
            access = L"public";
            break;
        case AccessModifier::PROTECTED:
            access = L"protected";
            break;
        case AccessModifier::PRIVATE:
            access = L"private";
            break;
        case AccessModifier::NONE:
            continue;
        }

        Classdef* def = std::get<1>(v.second);
        sciprint("%*ls [%-9ls] (%ls)\n", -max_len, v.first.data(), access.data(), def->getName().data());
    }

    sciprint("\n");
}

Classdef::~Classdef()
{
    //sciprint("delete Classdef\n");
    for (auto&& i : instances)
    {
        i.second->DecreaseRef();
        i.second->killMe();
    }

    for (auto&& e : enumerations)
    {
        for (auto&& it : e.second)
        {
            it->DecreaseRef();
            it->killMe();
        }
    }
}

std::vector<std::tuple<std::wstring, Classdef*>> Classdef::getSuperclass() const
{
    return supers;
}

bool Classdef::isAncestorOf(const Classdef* derived)
{
    if (this == derived)
    {
        return true;
    }

    for (auto&& t : derived->getSuperclass())
    {
        auto* base = std::get<1>(t);
        if (base == this || this->isAncestorOf(base))
        {
            return true;
        }
    }
    return false;
}

bool Classdef::invoke(typed_list& in, optional_list& opt, int _iRetCount, typed_list& out, const ast::Exp& e)
{
    AccessModifier ctorAccess;
    if (getAccessMethod(getName(), ctorAccess))
    {
        switch (ctorAccess)
        {
            case AccessModifier::PUBLIC:
            {
                internalCall(in, opt, _iRetCount, out, e);
                return true;
            }
            case AccessModifier::PROTECTED:
            {
                types::InternalType* pIT = symbol::Context::getInstance()->getCurrentObject();
                if (pIT != nullptr && pIT->isObject())
                {
                    types::Object* currentObj = pIT->getAs<types::Object>();
                    if (currentObj)
                    {
                        types::Classdef* caller = currentObj->getClassdef();
                        if (caller == this || isAncestorOf(caller))
                        {
                            internalCall(in, opt, _iRetCount, out, e);
                            return true;
                        }
                    }
                }
                break;
            }
            case AccessModifier::PRIVATE:
            {
                //continue to error
                break;
            }
            default: {}
        }

        wchar_t szError[128];
        os_swprintf(szError, 128, _W("Wrong call: constructor of '%ls' is not accessible.\n").c_str(), name.data());
        throw ast::InternalError(szError);
    }

    /*
    if (methods[name].access != AccessModifier::PUBLIC)
    {
        InternalType* pIT = symbol::Context::getInstance()->getCurrentObject();
        if (pIT == nullptr || (pIT->isClassdef() && pIT != this) || (pIT->isObject() && pIT->getAs<Object>()->getClassdef() != this))
        {
            wchar_t szError[128];
            os_swprintf(szError, 128, _W("Wrong call: constructor of '%ls' is not accessible.\n").c_str(), name.data());
            throw ast::InternalError(szError);
        }
    }
    */

    return false;
}

void Classdef::internalCall(typed_list& in, optional_list& opt, int _iRetCount, typed_list& out, const ast::Exp& e)
{
    //call of class constructor in constructor (A < B  A() { B() }
    InternalType* current = symbol::Context::getInstance()->getCurrentObject();
    if (current && current->isObject())
    {
        if (_iRetCount == 0) //not an assignation
        {
            Object* obj = current->getAs<Object>();
            if (isAncestorOf(obj->getClassdef()))
            {
                obj->IncreaseRef();
                obj->callSuperclassContructor(this, in, opt, _iRetCount, out, e);
                obj->DecreaseRef();
                return;
            }
        }
    }

    Object* obj = createEmptyInstance();
    obj->IncreaseRef();
    obj->callConstructor(in, opt, _iRetCount, out, e);
    obj->DecreaseRef();
    out.push_back(obj);
}

Object* Classdef::createEmptyInstance()
{
    LoadClassdef();
    return new Object(this);
}

Classdef* Classdef::insert(typed_list* _pArgs, InternalType* _pSource)
{
    if (_pArgs->size() == 1 && (*_pArgs)[0]->isString())
    {
        std::wstring field((*_pArgs)[0]->getAs<types::String>()->get(0));
        //InternalType* pIT = symbol::Context::getInstance()->getCurrentObject();
        AccessModifier access;
        if (getAccessProperty(field, access))
        {
            if (access == AccessModifier::PUBLIC || 
                (symbol::Context::getInstance()->getCurrentObject() == this && access != AccessModifier::NONE))
            {
                //setStatic(field, _pSource);
            }
            else
            {
                wchar_t szError[128];
                os_swprintf(szError, 128, _W("Wrong insertion: property '%ls' is not accessible.\n").c_str(), field.data());
                throw ast::InternalError(szError);
            }
        }
        else
        {
            wchar_t szError[128];
            os_swprintf(szError, 128, _W("Wrong insertion: property '%ls' does not exist.\n").c_str(), field.data());
            throw ast::InternalError(szError);
        }
    }
    else
    {
        wchar_t szError[128];
        os_swprintf(szError, 128, _W("Wrong insertion: invalid index.\n").c_str());
        throw ast::InternalError(szError);
    }

    return this;
}

bool Classdef::getAccessProperty(const std::wstring& name, AccessModifier& access)
{
    auto p = properties.find(name);
    if (p == properties.end())
    {
        return false;
    }

    access = std::get<0>(p->second).access;
    return true;
}

bool Classdef::getAccessMethod(const std::wstring& name, AccessModifier& access)
{
    auto p = methods.find(name);
    if (p == methods.end())
    {
        // default cstor
        if (name == getName())
        {
            access = AccessModifier::PUBLIC;
            return true;
        }

        return false;
    }

    access = std::get<0>(p->second).access;
    return true;
}

bool Classdef::extract(const std::wstring& name, InternalType*& out)
{
    auto p = instances.find(name);
    if (p != instances.end())
    {
        out = p->second;
        return true;
    }

    auto e = enumerations.find(name);
    if (e != enumerations.end())
    {
        optional_list opt;
        typed_list out1;

        Object* obj = createEmptyInstance();
        obj->IncreaseRef();
        obj->callConstructor(e->second, opt, 0, out1, ast::CommentExp(Location(), new std::wstring(L"")));
        instances[e->first] = obj;

        out = obj;
        return true;
    }
    
    return false;
}

Callable* Classdef::getMethod(const std::wstring& name)
{
    if (methods.find(name) == methods.end())
    {
        return nullptr;
    }

    return std::get<0>(methods[name]).callable;
}

std::wstring Classdef::getMethodClassdef(const std::wstring& name)
{
    if (name == getName())
    {
        return name;
    }

    auto p = methods.find(name);
    if (p != methods.end())
    {
        return this->name;
    }

    return L"";
}

std::vector<std::wstring> Classdef::getPublicProperties()
{
    std::vector<std::wstring> props;
    for (auto&& p : properties)
    {
        OBJ_ATTR attr = std::get<0>(p.second);
        if (attr.hidden == false && attr.access == AccessModifier::PUBLIC)
        {
            props.push_back(p.first);
        }
    }

    return props;
}

std::vector<std::wstring> Classdef::getPublicMethods()
{
    std::vector<std::wstring> m;
    for (auto&& p : methods)
    {
        OBJ_ATTR attr = std::get<0>(p.second);
        if (attr.hidden == false && attr.access == AccessModifier::PUBLIC)
        {
            m.push_back(p.first);
        }
    }

    return m;
}
std::vector<std::wstring> Classdef::getEnumeration()
{
    std::vector<std::wstring> m;
    for (auto&& p : enumerations)
    {
        m.push_back(p.first);
    }

    for (auto&& s : supers)
    {
        auto p = std::get<1>(s)->getEnumeration();
        m.insert(m.end(), p.begin(), p.end());
    }

    return m;
}

/*
void Classdef::addStaticProperty(const std::wstring& name, const OBJ_ATTR& attr)
{
    instances[name] = instantiateProperty(name, attr);
    instances[name]->IncreaseRef();
}

void Classdef::addStaticMethod(const std::wstring& name, const OBJ_ATTR& attr)
{
    instances[name] = instantiateMethod(name, attr, true);
    instances[name]->IncreaseRef();
}

bool Classdef::hasStatic(const std::wstring& name)
{
    return instances.find(name) != instances.end();
}
    
InternalType* Classdef::getStatic(const std::wstring& name)
{
    if (hasStatic(name))
    {
        return instances[name];
    }

    return nullptr;
}

bool Classdef::setStatic(const std::wstring& name, InternalType* pIT)
{
    if (hasStatic(name))
    {
        instances[name]->DecreaseRef();
        instances[name]->killMe();

        pIT->IncreaseRef();
        instances[name] = pIT;
        return true;
    }

    return false;
}
*/
InternalType* Classdef::instantiateProperty(const std::wstring& name, const OBJ_ATTR& attr)
{
    if (attr.arg.default_value == nullptr)
    {
        return types::Double::Empty();
    }
    else
    {
        ast::RunVisitor* exec = (ast::RunVisitor*)ConfigVariable::getDefaultVisitor();
        attr.arg.default_value->accept(*exec);
        InternalType* pIT = exec->getResult();
        if (pIT == nullptr || pIT->isAssignable() == false)
        {
            char msg[128];
            os_sprintf(msg, _("%s: Unable to evaluate default value.\n"), scilab::UTF8::toUTF8(name).data());
            throw ast::InternalError(scilab::UTF8::toWide(msg), 999, attr.arg.default_value->getLocation());
        }

        pIT->IncreaseRef();
        delete exec;
        pIT->DecreaseRef();
        return pIT;
    }
}

AccessModifier Classdef::reduceAccess(AccessModifier access)
{
    switch (access)
    {
        case AccessModifier::PROTECTED:
            access = AccessModifier::PRIVATE;
            break;
        case AccessModifier::PRIVATE:
            access = AccessModifier::NONE;
            break;
        default: {}
    }

    return access;
}

void Classdef::addHelpers()
{
    // add undefined useful overload
    //addHelper(L"disp", &Classdef::object_disp);
    addHelper(L"outline", &Classdef::object_outline);
    addHelper(L"eq", &Classdef::object_eq);
    addHelper(L"ne", &Classdef::object_ne);
    addHelper(L"clone", &Classdef::object_clone);
    addHelper(L"delete", &Classdef::object_delete);
}

void Classdef::addHelper(const std::wstring& name, Function::ReturnValue (Classdef::*_pFunc)(typed_list&, int, typed_list&))
{
    auto m = methods.find(name);
    if (m == methods.end() || std::get<0>((*m).second).hidden == true)
    {
        if (m != methods.end())
        {
            /*
            OBJ_ATTR attr = std::get<0>((*m).second);
            if (attr.callable != nullptr)
            {
                attr.callable->DecreaseRef();
                attr.callable->killMe();
            }
            */
        }

        OBJ_ATTR attr;
        attr.access = AccessModifier::PUBLIC;
        attr.isStatic = false;
        attr.hidden = true;
        Function* f = Function::createFunction(name, this, _pFunc, getName());
        f->IncreaseRef();
        attr.callable = f;
        methods[name] = {attr, this};
    }
}

/* gateways for default overload*/
Function::ReturnValue Classdef::object_disp(typed_list& in, int _iRetCount, typed_list& out)
{
    return Function::OK;
}

Function::ReturnValue Classdef::object_outline(typed_list& in, int _iRetCount, typed_list& out)
{
    std::wostringstream ostr;
    ostr << " (" << getName() << " object)";
    out.push_back(new String(ostr.str().data()));
    return Function::OK;
}

Function::ReturnValue Classdef::object_eq(typed_list& in, int _iRetCount, typed_list& out)
{
    // sciprint("Object::object_eq\n");
    out.push_back(new Bool(in[0] == in[1]));
    return Function::OK;
}

Function::ReturnValue Classdef::object_ne(typed_list& in, int _iRetCount, typed_list& out)
{
    // sciprint("Object::object_ne\n");
    out.push_back(new Bool(in[0] != in[1]));
    return Function::OK;
}

Function::ReturnValue Classdef::object_clone(typed_list& in, int _iRetCount, typed_list& out)
{
    // sciprint("Object::object_clone\n");
    InternalType* obj = symbol::Context::getInstance()->getCurrentObject();
    if (obj && obj->isObject())
    {
        out.push_back(new Object(*obj->getAs<Object>()));
        return Function::OK;
    }

    return Function::Error;
}

Function::ReturnValue Classdef::object_delete(typed_list& in, int _iRetCount, typed_list& out)
{
    // sciprint("Object::object_delete\n");
    return Function::OK;
}

} // namespace types