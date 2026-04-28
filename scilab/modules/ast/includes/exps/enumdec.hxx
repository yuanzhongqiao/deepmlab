/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

/**
** \file enumdec.hxx
** Define the Enum Declaration class.
*/

#ifndef AST_ENUMDEC_HXX
#define AST_ENUMDEC_HXX

#include "dec.hxx"
#include "exp.hxx"

namespace ast
{
/*
** \brief Abstract a Enum Declaration node.
**
** \b Example: 
    enumeration
      Monday, Tuesday, Wednesday, Thursday, Friday
   end
*/
class EnumDec : public Dec
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
    EnumDec (const Location& location,
                 exps_t attributes,
                 exps_t enumeration)
        : Dec (location),
        _attributes (attributes),
        _enumeration (enumeration)
    {
    }

    virtual ~EnumDec ()
    {
    }

    virtual EnumDec* clone()
    {
        exps_t newAttributes;
        for (exps_t::const_iterator it = getAttributes().begin(); it != getAttributes().end(); ++it)
        {
            newAttributes.push_back(*it);
        }
        exps_t newEnumeration;
        for (exps_t::const_iterator it = getEnumeration().begin(); it != getEnumeration().end(); ++it)
        {
            newEnumeration.push_back(*it);
        }
        EnumDec* cloned = new EnumDec(getLocation(), newAttributes, newEnumeration);
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
    const exps_t& getEnumeration(void) const
    {
        return _enumeration;
    }

    exps_t& getEnumeration(void)
    {
        return _enumeration;
    }

    const exps_t& getAttributes(void) const
    {
        return _attributes;
    }

    exps_t& getAttributes(void)
    {
        return _attributes;
    }

    virtual ExpType getType() const
    {
        return ENUMDEC;
    }

    virtual bool isEnumDec() const
    {
        return true;
    }

  protected:
    exps_t _attributes;
    exps_t _enumeration;
};

} // namespace ast

#endif // !AST_ENUMDEC_HXX
