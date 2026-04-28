/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "elem_func_gw.hxx"
#include "function.hxx"
#include "double.hxx"
#include "overload.hxx"
#include "string.hxx"
#include "int.hxx"

extern "C"
{
#include "Scierror.h"
#include "localization.h"
#include "basic_functions.h"
}

types::Function::ReturnValue sci_gallery(types::typed_list &in, int _iRetCount, types::typed_list &out)
{
    types::Double* pDblIn   = NULL;
    types::Double* pDblOut  = NULL;

    if (in.size() < 1)
    {
        Scierror(77, _("%s: Wrong number of input argument: At least %d expected.\n"), "gallery", 1);
        return types::Function::Error;
    }

    if (_iRetCount > 1)
    {
        Scierror(78, _("%s: Wrong number of output argument(s): %d expected.\n"), "gallery", 1);
        return types::Function::Error;
    }

    if (in.size() == 1)
    {
        if (in[0]->isDouble() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A double expected.\n"), "gallery", 1);
            return types::Function::Error;
        }

        pDblIn = in[0]->getAs<types::Double>();
        if (pDblIn->getSize() != 1)
        {
            Scierror(999, _("%s: Wrong size for input argument #%d: A scalar expected.\n"), "gallery", 1);
            return types::Function::Error;
        }

        int N = static_cast<int>(pDblIn->get(0));
        std::vector<double> data;
        pDblOut = new types::Double(N, N);
        switch (N)
        {
            case 3:
            {
                data = {-149, 537, -27, -50, 180, -9, -154, 546, -25};
                break;
            }
            case 5:
            {
                data = {-9, 70, -575, 3891, 1024, 11, -69, 575, -3891, -1024, -21, 141, -1149, 7782, 2048, 63, -421, 3451, -23345, -6144, -252, 1684, -13801, 93365, 24572};
                break;
            }
            default:
            {
                Scierror(999, _("%s: Wrong value for input argument #%d: Must be in the set {%s}.\n"), "gallery", 1, "\"3\",\"5\"");
                return types::Function::Error;
            }
        }

        pDblOut->set(data.data());
    }
    else
    {
        if (in[0]->isString() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A string expected.\n"), "gallery", 1);
            return types::Function::Error;
        }

        std::wstring wcsName = in[0]->getAs<types::String>()->get(0);
        if (in[1]->isDouble() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: A double expected.\n"), "gallery", 2);
            return types::Function::Error;
        }

        pDblIn = in[1]->getAs<types::Double>();
        int iSize = pDblIn->getSize();
        bool isScalarX = iSize == 1;

        if (wcsName == L"circul") // gallery("circul", x)
        {
            if (iSize == 0 || pDblIn->isVector() == false)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: A vector expected.\n"), "gallery", 2);
                return types::Function::Error;
            }

            int N = 0;
            double* data = NULL;

            if (isScalarX)
            {
                if (pDblIn->isComplex())
                {
                    Scierror(999, _("%s: Wrong value for input argument #%d: Real scalar expected.\n"), "gallery", 2);
                    return types::Function::Error;
                }

                N = static_cast<int>(pDblIn->get(0));
                data = new double[N];

                for (int i = 1; i < N+1; i++)
                {
                    data[i-1] = i;
                }
            }
            else
            {
                N = iSize;
                data = pDblIn->get();
            }

            pDblOut = new types::Double(N, N, pDblIn->isComplex());
            circul_matrix(N, data, pDblOut->get());
            if (pDblOut->isComplex())
            {
                circul_matrix(N, pDblIn->getImg(), pDblOut->getImg());            
            }
            if (isScalarX)
            {
                delete[] data;
            }
        }  
        else if (wcsName == L"cauchy") // gallery("cauchy", x) or gallery("cauchy", x, y)
        {
            if (iSize == 0 || pDblIn->isVector() == false)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: A vector expected.\n"), "gallery", 2);
                return types::Function::Error;
            }

            int N = 0;
            double* dataX = NULL;
            double* dataXI = NULL;
            double* dataY = NULL;
            double* dataYI = NULL;
            bool isScalarY = false;

            if (isScalarX)
            {
                // x is scalar
                if (pDblIn->isComplex())
                {
                    Scierror(999, _("%s: Wrong value for input argument #%d: Real scalar expected.\n"), "gallery", 2);
                    return types::Function::Error;
                }

                N = static_cast<int>(pDblIn->get(0));
                dataX = new double[N];
                for (int i = 1; i < N + 1; i++)
                {
                    dataX[i - 1] = i;
                }
            }
            else
            {
                N = iSize;
                dataX = pDblIn->get();
                if (pDblIn->isComplex())
                {
                    dataXI = pDblIn->getImg();
                }
            }

            if (in.size() == 2)
            {
                dataY = dataX;
                dataYI = dataXI;
                pDblOut = new types::Double(N, N, pDblIn->isComplex());
            }
            else
            {
                // gallery("cauchy", x, y)
                types::Double* pDblIn2 = NULL;
                if (in[2]->isDouble() == false)
                {
                    if (isScalarX)
                    {
                        delete[] dataX;
                    }
                    Scierror(999, _("%s: Wrong type for input argument #%d: A double expected.\n"), "gallery", 3);
                    return types::Function::Error;
                }

                pDblIn2 = in[2]->getAs<types::Double>();
                int iSize2 = pDblIn2->getSize();
                isScalarY = iSize2 == 1;

                if (isScalarY)
                {
                    // y is scalar
                    if (pDblIn2->isComplex())
                    {
                        if (isScalarX)
                        {
                            delete[] dataX;
                        }
                        Scierror(999, _("%s: Wrong value for input argument #%d: Real scalar expected.\n"), "gallery", 3);
                        return types::Function::Error;
                    }
                    // y must be equal to size of x or x when it is scalar
                    if (N != static_cast<int>(pDblIn2->get(0)))
                    {
                        if (isScalarX)
                        {
                            delete[] dataX;
                        }
                        Scierror(999, _("%s: Wrong size for input argument #%d: Must be of the same size of #%d.\n"), "gallery", 3, 2);
                        return types::Function::Error;
                    }

                    dataY = new double[N];
                    for (int i = 1; i < N + 1; i++)
                    {
                        dataY[i - 1] = i;
                    }
                }
                else
                {
                    if (N != iSize2)
                    {
                        if (isScalarX)
                        {
                            delete[] dataX;
                        }
                        Scierror(999, _("%s: Wrong size for input argument #%d: Must be of the same size of #%d.\n"), "gallery", 3, 2);
                        return types::Function::Error;
                    }

                    dataY = pDblIn2->get();
                    if (pDblIn2->isComplex())
                    {
                        dataYI = pDblIn2->getImg();
                    }
                }

                pDblOut = new types::Double(N, N, pDblIn->isComplex() || pDblIn2->isComplex());
            }

            cauchy_matrix(N, dataX, dataXI, dataY, dataYI, pDblOut->get(), pDblOut->getImg());

            if (isScalarX)
            {
                delete[] dataX;
            }
            if (isScalarY)
            {
                delete[] dataY;
            }
        }
        else 
        {
            if (iSize == 0)
            {
                out.push_back(types::Double::Empty());
                return types::Function::OK;
            }

            if (iSize != 1)
            {
                Scierror(999, _("%s: Wrong size for input argument #%d: A scalar expected.\n"), "gallery", 2);
                return types::Function::Error;
            }

            int N = static_cast<int>(pDblIn->get(0));
            if (N < 0) 
            {
                Scierror(999, _("%s: Wrong value for input argument #%d: A positive value expected.\n"), "gallery", 2);
                return types::Function::Error;
            }

            pDblOut = new types::Double(N, N, pDblIn->isComplex());
            if (wcsName == L"ris")
            {
                ris_matrix(N, pDblOut->get());
            }
            else if (wcsName == L"minij")
            {
                minij_moler_matrix(N, 0, pDblOut->get());
            }
            else if (wcsName == L"moler")
            {
                minij_moler_matrix(N, 2, pDblOut->get());
            }
            else
            {
                Scierror(999, _("%s: Wrong value for input argument #%d: %s expected.\n"), "gallery", 1, "\"cauchy\", \"circul\" or \"ris\"");
                return types::Function::Error;
            }
        }
    }    

    out.push_back(pDblOut);
    return types::Function::OK;
}
