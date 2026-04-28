/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

/**
** \file enumdec.hxx
** Define the Properties Declaration class.
*/

#ifndef AST_PROPERTIESDEC_HXX
#define AST_PROPERTIESDEC_HXX

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
class PropertiesDec : public Dec
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
    PropertiesDec (const Location& location,
                 exps_t attributes,
                 exps_t properties)
        : Dec (location),
        _properties (properties),
        _attributes (attributes)
    {
    }

    virtual ~PropertiesDec ()
    {
    }

    virtual PropertiesDec* clone()
    {
        exps_t newAttributes;
        for (exps_t::const_iterator it = getAttributes().begin(); it != getAttributes().end(); ++it)
        {
            newAttributes.push_back(*it);
        }
        exps_t newProperties;
        for (exps_t::const_iterator it = getProperties().begin(); it != getProperties().end(); ++it)
        {
            newProperties.push_back(*it);
        }
        PropertiesDec* cloned = new PropertiesDec(getLocation(), newAttributes, newProperties);
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
    const exps_t& getProperties(void) const
    {
        return _properties;
    }

    exps_t& getProperties(void)
    {
        return _properties;
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
        return PROPERTIESDEC;
    }

    virtual bool isPropertiesDec() const
    {
        return true;
    }

  protected:
    exps_t _properties;
    exps_t _attributes;
};

} // namespace ast

#endif // !AST_PROPERTIESDEC_HXX
