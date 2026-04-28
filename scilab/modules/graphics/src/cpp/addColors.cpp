/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Antoine ELIAS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include <set>
#include <vector>
#include <tuple>
#ifndef _MSC_VER
    #include <algorithm>
#endif

extern "C"
{
#include "addColor.h"
#include "getGraphicObjectProperty.h"
#include "graphicObjectProperties.h"
#include "setGraphicObjectProperty.h"
#include "sci_malloc.h"
#include "sciprint.h"
}

void addColors(int _iFig, double* _pdblNewColors, int colors, double** indexes)
{
    int iColorMapSize = 0;
    int* piColorMapSize = &iColorMapSize;
    double* pdblColorMap = NULL;

    // first get figure.color_map
    getGraphicObjectProperty(_iFig, __GO_COLORMAP_SIZE__, jni_int, (void**)&piColorMapSize);
    getGraphicObjectProperty(_iFig, __GO_COLORMAP__, jni_double_vector, (void**)&pdblColorMap);

    std::set<std::tuple<double, double, double>> s;
    std::vector<std::tuple<double, double, double>> v;
    for (int i = 0; i < iColorMapSize; ++i)
    {
        s.emplace(pdblColorMap[i], pdblColorMap[i + iColorMapSize], pdblColorMap[i + iColorMapSize * 2]);
        v.emplace_back(pdblColorMap[i], pdblColorMap[i + iColorMapSize], pdblColorMap[i + iColorMapSize * 2]);
    }

    for (int i = 0; i < colors; ++i)
    {
        auto res = s.emplace(_pdblNewColors[i], _pdblNewColors[i + colors], _pdblNewColors[i + colors * 2]);
        if (res.second)
        {
            (*indexes)[i] = (int)v.size() + 1;
            v.emplace_back(_pdblNewColors[i], _pdblNewColors[i + colors], _pdblNewColors[i + colors * 2]);
        }
        else
        {
            auto pos = std::find_if(v.begin(), v.end(), [&](const std::tuple<double, double, double>& t)
            {
                return std::get<0>(t) == std::get<0>(*res.first) &&
                    std::get<1>(t) == std::get<1>(*res.first) &&
                    std::get<2>(t) == std::get<2>(*res.first);
            });

            (*indexes)[i] = (int)std::distance(v.begin(), pos) + 1;
        }
    }

    int nbColors = (int)v.size();
    std::vector<double> newColors(nbColors * COLOR_COMPONENT);
    std::vector<std::tuple<double, double, double>>::iterator it = v.begin();
    for (int i = 0; it != v.end(); ++it, i++)
    {
        newColors[i               ] = std::get<0>(*it);
        newColors[i + nbColors    ] = std::get<1>(*it);
        newColors[i + nbColors * 2] = std::get<2>(*it);
    }

    setGraphicObjectProperty(_iFig, __GO_COLORMAP__, newColors.data(), jni_double_vector, nbColors * COLOR_COMPONENT);
    releaseGraphicObjectProperty(__GO_COLORMAP__, pdblColorMap, jni_double_vector, iColorMapSize * COLOR_COMPONENT);
}
