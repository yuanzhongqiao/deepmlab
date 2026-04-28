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
#include <limits>

#include "double.hxx"
#include "function.hxx"
#include "overload.hxx"
#include "statistics_gw.hxx"
#include "string.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
#include "sci_malloc.h"
#include "sciprint.h"
}
/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_nanmean(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    int rhs = static_cast<int>(in.size());
    if (rhs < 1 || rhs > 2)
    {
        Scierror(999, _("%s: Wrong number of input argument(s): %d to %d expected.\n"), "nanmean", 1, 2);
        return types::Function::Error;
    }

    switch (in[0]->getId())
    {
        case types::InternalType::IdDouble:
        case types::InternalType::IdScalarDouble:
        {
            types::Double* d = in[0]->getAs<types::Double>();
            int dim = d->getDims();
            int* dims = d->getDimsArray();

            if (rhs != 2)
            {
                in.push_back(new types::String(L"*")); //will be delete by Overload::call
            }

            if (in[0]->isDouble() && in[0]->getAs<types::Double>()->isComplex() == false)
            {
                types::Double* d = in[0]->clone()->getAs<types::Double>();
                types::Bool* isnan = (new types::Bool(d->getDims(), d->getDimsArray()))->setFalse();
                double* p = d->get();
                int* b = isnan->get();
                int s = d->getSize();
                for (int i = 0; i < s; ++i)
                {
                    if (std::isnan(p[i]))
                    {
                        p[i] = 0;
                        b[i] = 1;
                    }
                }

                int orient = -1;
                if (in[1]->isDouble())
                {
                    orient = (int)in[1]->getAs<types::Double>()->get()[0];
                }
                else if (in[1]->isString())
                {
                    wchar_t* o = in[1]->getAs<types::String>()->get()[0];
                    switch (o[0])
                    {
                        case L'r':
                            orient = 1;
                            break;
                        case L'c':
                            orient = 2;
                            break;
                        case L'm':
                        {
                            for (int i = 0; i < dim; ++i)
                            {
                                if (dims[i] > 1)
                                {
                                    orient = i + 1;
                                    break;
                                }
                            }
                            break;
                        }
                    }
                }
                else
                {
                    Scierror(999, _("%s: Wrong value for input argument #%d: Must be in the set {%s}.\n"), "mean", 2, "\"r\", \"c\", \"m\"");
                    return types::Function::Error;
                }

                types::typed_list in2 = in;
                in2[0] = isnan;
                types::typed_list out2;
                if (Overload::call(L"sum", in2, _iRetCount, out2) != types::Function::OK)
                {
                    return types::Function::Error;
                }

                types::Double* sum = out2[0]->getAs<types::Double>();
                int size = d->getSize();
                if (orient > 0)
                {
                    size = d->getDimsArray()[orient - 1];
                }

                std::vector<int> zeros;
                for (int i = 0; i < sum->getSize(); ++i)
                {
                    double val = size - sum->get()[i];
                    sum->get()[i] = val;
                    if (val == 0)
                    {
                        sum->get()[i] = 1;
                        zeros.push_back(i);
                    }
                }

                types::typed_list in3 = in;
                in3[0] = d;
                if (Overload::call(L"sum", in3, _iRetCount, out) != types::Function::OK)
                {
                    return types::Function::Error;
                }

                types::Double* o = out[0]->getAs<types::Double>();
                for (int i = 0; i < o->getSize(); ++i)
                {
                    o->get()[i] /= sum->get()[i];
                }

                for (auto&& idx : zeros)
                {
                    o->get()[idx] = std::numeric_limits<double>::quiet_NaN();
                }

                d->killMe();
                isnan->killMe();
            }
            break;
        }
        default:
        {
            return Overload::call(L"%_nanmean", in, _iRetCount, out);
        }
    }

    return types::Function::OK;
}
