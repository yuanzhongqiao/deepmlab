/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

/**
** \file enumdec.hxx
** Define the Methods Declaration class.
*/

#ifndef AST_METHODSDEC_HXX
#define AST_METHODSDEC_HXX

#include "dec.hxx"
#include "exp.hxx"

namespace ast
{
/*
** \brief Abstract a Enum Declaration node.
**
** \b Example: 
    methods
      function y=f(x)
        y = x.^2
      end
   end
*/
class MethodsDec : public Dec
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
    MethodsDec (const Location& location,
                 exps_t attributes,
                 exps_t methods)
        : Dec (location),
        _attributes (attributes),
        _methods (methods)
    {
    }

    virtual ~MethodsDec ()
    {
    }

    virtual MethodsDec* clone()
    {
        exps_t newAttributes;
        for (exps_t::const_iterator it = getAttributes().begin(); it != getAttributes().end(); ++it)
        {
            newAttributes.push_back(*it);
        }
        exps_t newMethods;
        for (exps_t::const_iterator it = getMethods().begin(); it != getMethods().end(); ++it)
        {
            newMethods.push_back(*it);
        }
        MethodsDec* cloned = new MethodsDec(getLocation(), newAttributes, newMethods);
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
    const exps_t& getMethods(void) const
    {
        return _methods;
    }

    exps_t& getMethods(void)
    {
        return _methods;
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
        return METHODSDEC;
    }

    virtual bool isMethodsDec() const
    {
        return true;
    }

  protected:
    exps_t _attributes;
    exps_t _methods;
};

} // namespace ast

#endif // !AST_METHODSDEC_HXX
