/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2023-2023 - Dassault Systèmes S.E. - Bruno JOFRET
 *
 */

/**
** \file argumentdec.hxx
** Define the Argument Declaration class.
*/

#ifndef AST_ARGUMENTDEC_HXX
#define AST_ARGUMENTDEC_HXX

#include "dec.hxx"

namespace ast
{
/*
** \brief Abstract a Argument Declaration node.
**
** \b Example: Identifier (dim1, dim2) class {validator1, validator2} = defaultValue
*/
class ArgumentDec : public Dec
{
    // \name Ctor & dtor.
public:
    /*
    ** \brief Construct a Argument Declaration node.
    ** \param location scanner position informations
    ** \param name of argument
    */
    ArgumentDec (const Location& location,
                 Exp& name, 
                 Exp& dims,
                 Exp& type,
                 Exp& validators,
                 Exp& defaultValue)
        : Dec (location)
    {
        _exps.push_back(&name);
        _exps.push_back(&dims);
        _exps.push_back(&type);
        _exps.push_back(&validators);
        _exps.push_back(&defaultValue);

        name.setParent(this);
        dims.setParent(this);
        type.setParent(this);
        validators.setParent(this);
        defaultValue.setParent(this);
    }
    virtual ~ArgumentDec ()
    {
    }

    virtual ArgumentDec* clone()
    {
        ArgumentDec* cloned = new ArgumentDec(
            getLocation(), 
            *getArgumentName()->clone(),
            *getArgumentDims()->clone(),
            *getArgumentType()->clone(),
            *getArgumentValidators()->clone(),
            *getArgumentDefaultValue()->clone());

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

    const Exp* getArgumentName(void) const
    {
        // SimpleVar : a
        // or FieldExp : a.b.c
        return _exps[0];
    }

    Exp* getArgumentName(void)
    {
        // SimpleVar : a
        // or FieldExp : a.b.c
        return _exps[0];
    }

    const Exp* getArgumentDims(void) const
    {
        return _exps[1];
    }

    Exp* getArgumentDims(void)
    {
        return _exps[1];
    }

    const Exp* getArgumentType(void) const
    {
        return _exps[2];
    }

    Exp* getArgumentType(void)
    {
        return _exps[2];
    }

    const Exp* getArgumentValidators(void) const
    {
        return _exps[3];
    }

    Exp* getArgumentValidators(void)
    {
        return _exps[3];
    }

    const Exp* getArgumentDefaultValue(void) const
    {
        return _exps[4];
    }

    Exp* getArgumentDefaultValue(void)
    {
        return _exps[4];
    }

    virtual bool isArgumentDec() const
    {
        return true;
    }

    virtual ExpType getType() const
    {
        return ARGUMENTDEC;
    }
};
}
#endif /* !AST_ARGUMENTDEC_HXX */