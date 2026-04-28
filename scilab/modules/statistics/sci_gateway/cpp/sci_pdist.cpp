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
types::Function::ReturnValue sci_pdist(types::typed_list& in, int _iRetCount, types::typed_list& out)
{

	if (in.size() < 1 || in.size() > 3)
	{
        Scierror(77, _("%s: Wrong number of input argument(s): %d or %d expected.\n"), "pdist", 1, 3);
        return types::Function::Error;
	}

	if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected."), "pdist", 1);
        return types::Function::Error;
    }

    // X
    if (in[0]->isDouble() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist", 1, "double");
        return types::Function::Error;
    }

    types::Double* X = in[0]->getAs<types::Double>();
    double* pX = X->get();
    int rows = X->getRows();
    int cols = X->getCols();

    // metric name
    std::wstring metric = L"euclidean";
    
    if (in.size() > 1)
    {
        if (in[1]->isString() == false && in[1]->isFunction() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A string or function expected.\n"), "pdist", 2);
            return types::Function::Error;
        }

        if (in[1]->isString())
        {
            metric = in[1]->getAs<types::String>()->get(0);
            auto distance = getdistance();
            if (distance.find(metric) == distance.end())
            {
                Scierror(999, _("%s: Wrong value for input argument #%d: invalid distance name '%ls'.\n"), "pdist", 2, metric.data());
                return types::Function::Error;
            }
        }
        
    }

    // distance parameter for seuclidean, mahalanobis and minkowski
    types::Double* pDParam = NULL;
    double* pdParam = NULL;
    double dParam = 2.0;

    if (in.size() == 3)
    {
        std::vector<std::wstring> allowedmetric = {L"seuclidean", L"se", L"s", L"mahalanobis", L"mahal", L"mah", L"minkowski", L"mi", L"m"};
        if (std::find(allowedmetric.begin(), allowedmetric.end(), metric) == allowedmetric.end())
        {
            Sciwarning(_("%s: Warning: #%d argument is an option for %s metrics.\n"), "pdist", 3, "\"seuclidean\", \"mahalanobis\", \"minkowski\"");
        }
        else
        {
            if (in[2]->isDouble() == false)
            {
                Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "pdist", 3, "double");
                return types::Function::Error;
            }

            pDParam = in[2]->getAs<types::Double>();
        }
    }

    int distLength = 0;
    for (int i = 1; i < rows; i++)
    {
        distLength = distLength + i;
    }
    std::vector<double> dist;
    dist.reserve(distLength);


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
            if (pDParam->isVector() && pDParam->getCols() != cols)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: A row vector of length %d expected for %s distance.\n"), "pdist", 3, cols, "seuclidean");
                return types::Function::Error;
            }
        }

        pdParam = pDParam->get();
        for (int i = 0; i < cols; ++i)
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
            if (pDParam->getCols() != cols)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: Must have the same number of columns as #%d for %d distance.\n"), "pdist", 3, 1, "mahalanobis");
                return types::Function::Error;
            }
        }

        // inverse pDParam
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
                Scierror(999, _("%s: Wrong size for input argument #%d: A scalar expected for %s distance.\n"), "pdist", 3, "minkowski");
                return types::Function::Error;
            }
            pdParam = pDParam->get();

            if (pdParam[0] < 0)
            {
                Scierror(999, _("%s: Wrong value for input argument #%d: A positive scalar expected for %s distance.\n"), "pdist", 3, "minkowski");
                return types::Function::Error;
            }
        }
    }

    // call distance
    auto distance = getdistance()[metric];
    for (int r = 0; r < rows; ++r)
    {
        for (int k = r + 1; k < rows; ++k)
        {
            dist.push_back(distance(rows, rows, cols, r, k, pX, pX, pdParam));
        }
    }

    if (pDParam != NULL)
    {
        pDParam->killMe();
    }
    
    types::Double* pDblOut = new types::Double(1, distLength);
    pDblOut->set(dist.data());
    out.push_back(pDblOut);
    return types::Function::OK;
}
