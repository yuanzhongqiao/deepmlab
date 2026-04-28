/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#ifndef __PAIRWISE_DISTANCES_H__
#define __PAIRWISE_DISTANCES_H__

#include <map>
#include <string>
#include <functional>

extern "C"
{
#include "dynlib_statistics.h"
}


STATISTICS_IMPEXP double euclidean(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double squaredeuclidean(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double seuclidean(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double mahalanobis(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double cityblock(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double minkowski(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double chebychev(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double cosine(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double correlation(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double hamming(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double jaccard(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double canberra(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);
STATISTICS_IMPEXP double braycurtis(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam);

STATISTICS_IMPEXP std::map<std::wstring, std::function<double(int, int, int, int, int, double*, double*, double*)>> getdistance();

#endif /* __PAIRWISE_DISTANCES_H__ */
