/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include <cmath>
#include <vector>
#include <tuple>

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

double distEuclidian(double x1, double y1, double x2, double y2)
{
    double x = x2 - x1;
    double y = y2 - y1;
    return x * x + y * y;
}

void meanPoint(const std::vector<double>& ptX, const std::vector<double>& ptY, double& x, double& y)
{
    double sx = 0;
    double sy = 0;

    for (int i = 0; i < ptX.size(); ++i)
    {
        sx += ptX[i];
        sy += ptY[i];
    }

    int n = static_cast<int>(ptX.size());
    x = sx / n;
    y = sy / n;
}

/*--------------------------------------------------------------------------*/
types::Function::ReturnValue sci_percent_meanshift(types::typed_list& in, int _iRetCount, types::typed_list& out)
{
    if (in.size() != 5)
    {
        Scierror(77, _("%s: Wrong number of input argument: At least %d expected.\n"), "meanshift", 1);
        return types::Function::Error;
    }

    for (int i = 0; i < 2; i++)
    {
        if (in[i]->isDouble() == false)
        {
            Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "meanshift", i+1, "double");
            return types::Function::Error;
        }
    }
    

    types::Double* Seeds = in[0]->getAs<types::Double>();
    double* pSeeds = Seeds->get();
    
    types::Double* X = in[1]->getAs<types::Double>();
    double* pX = X->get();

    double radius = in[2]->getAs<types::Double>()->get()[0];
    double stopThresh = 1e-3 * radius;
    radius *= radius;

    if (in[3]->isString() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "meanshift", 4, "string");
        return types::Function::Error;
    }

    std::wstring kernel = in[3]->getAs<types::String>()->get()[0];

    if (in[4]->isDouble() == false)
    {
        Scierror(999, _("%s: Wrong type for input argument #%d: %s expected.\n"), "meanshift", 5, "double");
        return types::Function::Error;
    }

    int max_iter = static_cast<int>(in[4]->getAs<types::Double>()->get()[0]);

    int rowsSeeds = Seeds->getRows();
    int rows = X->getRows();

    std::vector<std::tuple<double, double>> allpoints;
    std::vector<double> densities;
    
    if (kernel == L"flat")
    {
        for (int r = 0; r < rowsSeeds; ++r)
        {
            double ref_x = pSeeds[r];
            double ref_y = pSeeds[r + rowsSeeds];
            double nb_points = 0;

            for (int iter = 0; iter < max_iter; ++iter)
            {
                std::vector<int> idx(rows);
                std::vector<double> pointsX;
                pointsX.reserve(rows);
                std::vector<double> pointsY;
                pointsY.reserve(rows);

                for (int p = 0; p < rows; ++p)
                {
                    double x = pX[p];
                    double y = pX[p + rows];
                    if (distEuclidian(ref_x, ref_y, x, y) <= radius)
                    {
                        idx.push_back(p);
                        pointsX.push_back(x);
                        pointsY.push_back(y);
                    }
                }

                nb_points = static_cast<int>(idx.size());
                if (nb_points == 0 || nb_points == 1)
                {
                    break;
                }

                double new_ref_x = 0;
                double new_ref_y = 0;
                meanPoint(pointsX, pointsY, new_ref_x, new_ref_y);
                                
                bool stopIter = distEuclidian(ref_x, ref_y, new_ref_x, new_ref_y) <= stopThresh;
                ref_x = new_ref_x;
                ref_y = new_ref_y;

                if (stopIter)
                {
                    break;
                }
            }

            densities.push_back(nb_points);
            allpoints.push_back({ref_x, ref_y});
        }
    }
    else // kernel == "gaussian"
    {
        for (int r = 0; r < rowsSeeds; ++r)
        {
            double ref_x = pSeeds[r];
            double ref_y = pSeeds[r + rowsSeeds];
            double density = 0;

            for (int iter = 0; iter < max_iter; ++iter)
            {

                double new_ref_x = 0;
                double new_ref_y = 0;

                for (int p = 0; p < rows; ++p)
                {
                    double x = pX[p];
                    double y = pX[p + rows];
                    double ww = std::exp(-distEuclidian(ref_x, ref_y, x, y)/(2 * radius));
                    density += ww;
                    new_ref_x += ww * x;
                    new_ref_y += ww * y;
                }

                new_ref_x = new_ref_x / density;
                new_ref_y = new_ref_y / density;
                                
                bool stopIter = distEuclidian(ref_x, ref_y, new_ref_x, new_ref_y) <= 1e-3 * stopThresh;
                ref_x = new_ref_x;
                ref_y = new_ref_y;

                if (stopIter)
                {
                    break;
                }

                density = 0;
            }

            densities.push_back(density);
            allpoints.push_back({ref_x, ref_y});
        }

    }
    
    types::Double* out1 = new types::Double(rowsSeeds, 2);
    types::Double* out2 = new types::Double(rowsSeeds, 1);
    for (int i = 0; i < rowsSeeds; ++i)
    {
        out1->set(i, 0, std::get<0>(allpoints[i]));
        out1->set(i, 1, std::get<1>(allpoints[i]));
        out2->set(i, densities[i]);
    }

    out.push_back(out1);
    out.push_back(out2);
    return types::Function::OK;
}