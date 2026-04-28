/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2023-2023 - Dassault Systèmes S.E. - Bruno JOFRET
 *
 */

#ifndef AST_ARGUMENTSEXP_HXX
#define AST_ARGUMENTSEXP_HXX

#include <assert.h>
#include "exp.hxx"

namespace ast
{
/*
** \brief Abstract an Arguments Expression node.
**
** \b Example: arguments 
**                  A (1,1) double {mustBePositive} = 42
**             end
*/
class ArgumentsExp : public Exp
{
public:
    /*
    ** \brief Construct an Arguments Expression node.
    ** \param location scanner position informations
    ** \param decls list of argument declarations
    */
    ArgumentsExp(const Location& location,
          exps_t& decls)
        : Exp (location) 
    {
        for (auto it : decls)
        {
            it->setParent(this);
            _exps.push_back(it);
        }

        delete &decls;
    }

    virtual ~ArgumentsExp()
    {
    }
    
    virtual ArgumentsExp* clone()
    {
        exps_t* exp = new exps_t;
        for (auto it : _exps)
        {
            exp->push_back(it->clone());
        }

        ArgumentsExp* cloned = new ArgumentsExp(getLocation(), *exp);
        cloned->setVerbose(isVerbose());
        return cloned;
    }

    // \brief Visitors entry point.
public:
    virtual void	accept(Visitor& v)
    {
        v.visit (*this);
    }
    virtual void	accept(ConstVisitor& v) const
    {
        v.visit (*this);
    }

    virtual bool isArgumentsExp() const
    {
        return true;
    }

    virtual ExpType getType() const
    {
        return ARGUMENTSEXP;
    }

};

} // namespace ast

#endif // !AST_ARGUMENTSEXP_HXX
