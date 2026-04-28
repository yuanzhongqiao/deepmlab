/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

/**
** \file classdec.hxx
** Define the Class Declaration class.
*/

#ifndef AST_CLASSDEC_HXX
#define AST_CLASSDEC_HXX

#include "macro.hxx"

#include "context.hxx"
#include "dec.hxx"
#include "arraylistvar.hxx"
#include "seqexp.hxx"

namespace ast
{
/*
** \brief Abstract a Class Declaration node.
**
** \b Example: 
** classdef MyClass
**      ...
** end
*/
class ClassDec : public Dec
{
    // \name Ctor & dtor.
public:
    /*
    ** \brief Construct a Class Declaration node.
    ** \param location scanner position informations
    ** \param name of class
    ** \param list of enumeration
    ** \param list of properties
    ** \param list of methods
    */
    ClassDec (const Location& location,
                 symbol::Symbol name,
                 exps_t& superclasses,
                 exps_t& enumeration,
                 exps_t& properties,
                 exps_t& methods)
        : Dec (location),
          _name (name),
          _superclasses (superclasses),
          _enumeration (enumeration),
         _properties (properties),
         _methods (methods)
    {
    }

    virtual ~ClassDec ()
    {
    }

    virtual ClassDec* clone()
    {
        exps_t newSuperClasses;
        for (exps_t::const_iterator it = getSuperClasses().begin(); it != getSuperClasses().end(); ++it)
        {
            newSuperClasses.push_back(*it);
        }
        exps_t newEnumeration;
        for (exps_t::const_iterator it = getEnumeration().begin(); it != getEnumeration().end(); ++it)
        {
            newEnumeration.push_back(*it);
        }
        exps_t newMethods;
        for (exps_t::const_iterator it = getMethods().begin(); it != getMethods().end(); ++it)
        {
            newMethods.push_back(*it);
        }
        exps_t newProperties;
        for (exps_t::const_iterator it = getProperties().begin(); it != getProperties().end(); ++it)
        {
            newProperties.push_back(*it);
        }
        ClassDec* cloned = new ClassDec(getLocation(), getSymbol(), newSuperClasses, newEnumeration, newProperties, newMethods);
        return cloned;
    }

    // \name Visitors entry point.
public:
    // \brief Accept a const visitor
    virtual void accept (Visitor& v)
    {
        v.visit (*this);
    }
    // \brief Accept a non-const visitor
    virtual void accept (ConstVisitor& v) const
    {
        v.visit (*this);
    }

    // \name Accessors.
public:
    const symbol::Symbol & getSymbol(void) const
    {
        return _name;
    }

    const exps_t& getSuperClasses(void) const
    {
        return _superclasses;
    }

    exps_t& getSuperClasses(void)
    {
        return _superclasses;
    }

    const exps_t& getEnumeration(void) const
    {
        return _enumeration;
    }

    exps_t& getEnumeration(void)
    {
        return _enumeration;
    }

    const exps_t& getEnumerationAttributes(void) const
    {
        return _enumeration;
    }

    exps_t& getEnumerationAttributes(void)
    {
        return _enumeration;
    }

    const exps_t& getMethods(void) const
    {
        return _methods;
    }

    exps_t& getMethods(void)
    {
        return _methods;
    }

    const exps_t& getMethodsAttributes(void) const
    {
        return _methods;
    }

    exps_t& getMethodsAttributes(void)
    {
        return _methods;
    }

    const exps_t& getProperties(void) const
    {
        return _properties;
    }

    exps_t& getProperties(void)
    {
        return _properties;
    }

    const exps_t& getPropertiesAttributes(void) const
    {
        return _properties;
    }

    exps_t& getPropertiesAttributes(void)
    {
        return _properties;
    }

    virtual bool isClassDec() const
    {
        return true;
    }

    virtual ExpType getType() const
    {
        return CLASSDEC;
    }

protected:
    symbol::Symbol _name;
    exps_t _superclasses;
    exps_t _enumeration;
    exps_t _properties;
    exps_t _methods;
};

} // namespace ast

#endif // !AST_CLASSDEC_HXX
