/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
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
/*--------------------------------------------------------------------------*/

#include "double.hxx"
#include "function.hxx"
#include "statistics_gw.hxx"
#include "string.hxx"
#include "overload.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
#include "sci_malloc.h"
#include "sciprint.h"
}
/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_nansum(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    int rhs = static_cast<int>(in.size());
    if (rhs < 1 || rhs > 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "nansum", 1, 2);
        return types::Function::Error;
    }

    switch (in[0]->getId())
    {
        case types::InternalType::IdDouble:
        case types::InternalType::IdScalarDouble:
        {
            types::Double* d = in[0]->clone()->getAs<types::Double>();
            double* p = d->get();
            for (int i = 0; i < d->getSize(); ++i)
            {
                if (std::isnan(p[i]))
                {
                    p[i] = 0;
                }
            }
            types::typed_list in2 = in;
            in2[0] = d;
            return Overload::call(L"sum", in2, _iRetCount, out);
        }
        default:
            return Overload::call(L"%_nansum", in, _iRetCount, out);
    }
}