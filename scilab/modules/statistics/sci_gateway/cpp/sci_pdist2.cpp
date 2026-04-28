/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "double.hxx"
#include "function.hxx"
#include "overload.hxx"
#include "statistics_gw.hxx"
#include "string.hxx"
#include "pairwise_distances.hxx"

extern "C"
{
    #include "Scierror.h"
    #include "Sciwarning.h"
    #include "localization.h"
}


/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_pdist2(types::typed_list& in, int _iRetCount, types::typed_list& out)
{

    if (in.size() < 2 || in.size() > 4)
    {
        Scierror(77, _("%s: Wrong number of input arguments: %d or %d expected.\n"), "pdist2", 2, 4);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected."), "pdist2", 1);
        return types::Function::Error;
    }

    // X
    if (in[0]->isDouble() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist2", 1, "double");
        return types::Function::Error;
    }

    types::Double* X = in[0]->getAs<types::Double>();
    double* pX = X->get();
    int rowsX = X->getRows();
    int colsX = X->getCols();

    // Y
    if (in[1]->isDouble() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist2", 2, "double");
        return types::Function::Error;
    }

    types::Double* Y = in[1]->getAs<types::Double>();
    double* pY = Y->get();
    int rowsY = Y->getRows();
    int colsY = Y->getCols();

    if (colsX != colsY)
    {
        Scierror(999, _("%s: Wrong size for input argument #%d and #%d: Must have the same number of columns.\n"), "pdist2", 1, 2);
        return types::Function::Error;
    }

    // metric name
    std::wstring metric = L"euclidean";

    if (in.size() > 2)
    {
        if (in[2]->isString() == false && in[2]->isFunction() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A string or function expected.\n"), "pdist2", 3);
            return types::Function::Error;
        }

        if (in[2]->isString())
        {
            metric = in[2]->getAs<types::String>()->get(0);
            auto distance = getdistance();
            if (distance.find(metric) == distance.end())
            {
                Scierror(999, _("%s: Wrong value for input argument #%d: invalid distance name '%ls'.\n"), "pdist2", 3, metric.data());
                return types::Function::Error;
            }
        }
    }

    // distance parameter for seuclidean, mahalanobis and minkowski
    types::Double* pDParam = NULL;
    double* pdParam = NULL;
    double dParam = 2.0;

    if (in.size() == 4)
    {
        std::vector<std::wstring> allowedmetric = {L"seuclidean", L"se", L"s", L"mahalanobis", L"mahal", L"mah", L"minkowski", L"mi", L"m"};
        if (std::find(allowedmetric.begin(), allowedmetric.end(), metric) == allowedmetric.end())
        {
            Sciwarning(_("%s: Warning: #%d argument is an option for %s metrics.\n"), "pdist2", 4, "\"seuclidean\", \"mahalanobis\", \"minkowski\"");
        }
        else
        {
            if (in[3]->isDouble() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist2", 4, "double");
                return types::Function::Error;
            }

            pDParam = in[3]->getAs<types::Double>();
        }
    }

    std::vector<double> dist;
    dist.reserve(rowsX * rowsY);

    if (metric == L"seuclidean" || metric == L"se" || metric == L"s")
    {
        if (pDParam == NULL)
        {
            types::typed_list in2 = {X};
            in2.push_back(new types::Double(1));
            types::typed_list pOut;

            if (Overload::call(L"stdev", in2, 1, pOut) != types::Function::OK)
            {
                return types::Function::Error;
            }

            pDParam = pOut[0]->getAs<types::Double>();
        }
        else
        {
            // Must be a row vector of length equal to the number of columns in X
            if (pDParam->isVector() && pDParam->getCols() != colsX)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: A row vector of length %d expected for %s distance.\n"), "pdist2", 3, colsX, "seuclidean");
                return types::Function::Error;
            }
        }

        pdParam = pDParam->get();

        for (int i = 0; i < colsX; ++i)
        {
            if (pdParam[i] == 0)
            {
                pdParam[i] = 1;
            }
        }
    }
    else if (metric == L"mahalanobis" || metric == L"mahal" || metric == L"mah")
    {
        if (pDParam == NULL)
        {
            types::typed_list in2 = {X};
            types::typed_list pOut;
            if (Overload::call(L"cov", in2, 1, pOut) != types::Function::OK)
            {
                return types::Function::Error;
            }
            pDParam = pOut[0]->getAs<types::Double>();
        }
        else
        {
            // check must have the same column number as X
            if (pDParam->getCols() != colsX)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: Must have the same number of columns as #%d for %d distance.\n"), "pdist2", 3, 1, "mahalanobis");
                return types::Function::Error;
            }
        }

        // inverse distparam
        types::typed_list in2 = {pDParam};
        types::typed_list pOut;
        if (Overload::call(L"inv", in2, 1, pOut) != types::Function::OK)
        {
            return types::Function::Error;
        }

        pDParam->killMe();
        pDParam = pOut[0]->getAs<types::Double>();
        pdParam = pDParam->get();

    }
    else if (metric == L"minkowski" || metric == L"mi" || metric == L"m")
    {
        if (pDParam == NULL)
        {
            pdParam = &dParam;
        }
        else
        {
            // check scalar
            if (!pDParam->isScalar())
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: A scalar expected for %s distance.\n"), "pdist2", 3, "minkowski");
                return types::Function::Error;
            }
            pdParam = pDParam->get();

            if (pdParam[0] < 0)
            {
                Scierror(999, _("%s: Wrong value for input argument #%d: A positive scalar expected for %s distance.\n"), "pdist2", 3, "minkowski");
                return types::Function::Error;
            }
        }
    }

    auto distance = getdistance()[metric];
    for (int r = 0; r < rowsX; ++r)
    {
        for (int k = 0; k < rowsY; ++k)
        {
            dist.push_back(distance(rowsX, rowsY, colsX, r, k, pX, pY, pdParam));
        }
    }

    if (pDParam != NULL)
    {
        pDParam->killMe();
    }

    types::Double* pDblOut = new types::Double(rowsX, rowsY);
    for (int i = 0; i < rowsX; ++i)
    {
        for (int j = 0; j < rowsY; ++j)
        {
            pDblOut->set(j * rowsX + i, dist[i * rowsY + j]);
        }
    }

    out.push_back(pDblOut);
    return types::Function::OK;

}
