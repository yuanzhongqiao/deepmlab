/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "pairwise_distances.hxx"

#include <cmath>

extern "C"
{
    #include "core_math.h" // Max
}


double euclidean(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double s = pX[r] - pY[k];
    double d = s * s;

    for (int c = 1; c < cols; ++c)
    {
        s = pX[c * rowsX + r] - pY[c * rowsY + k];
        d = d + (s * s);
    }

    return sqrt(d);
}

double squaredeuclidean(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double s = pX[r] - pY[k];
    double d = s * s;

    for (int c = 1; c < cols; ++c)
    {
        s = pX[c * rowsX + r] - pY[c * rowsY + k];
        d = d + (s * s);
    }

    return d;
}

double seuclidean(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double s = (pX[r] - pY[k]) / pdParam[0];
    double d = s * s;

    for (int c = 1; c < cols; ++c)
    {
        s = (pX[c * rowsX + r] - pY[c * rowsY + k]) / pdParam[c];
        d = d + (s * s);
    }

    return sqrt(d);
}

double mahalanobis(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d = 0;

    if (rowsX == 1 && cols != 1)
    {
        for (int c = 0; c < cols; ++c)
        {
            double s = pX[c * rowsX + r] - pY[c * rowsY + k];
            d = d + s * pdParam[0] * s;
        }
    }
    else
    {
        for (int i = 0; i < cols; ++i)
        {
            double p = 0;
            for (int c = 0; c < cols; ++c)
            {
                double s = pX[c * rowsX + r] - pY[c * rowsY + k];
                p = p + s * pdParam[i * cols + c];
            }
            d = d + p * (pX[i * rowsX + r] - pY[i * rowsY + k]);
        }
    }

    return sqrt(d);
}

double cityblock(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double s = pX[r] - pY[k];
    double d = abs(s);

    for (int c = 1; c < cols; ++c)
    {
        s = pX[c * rowsX + r] - pY[c * rowsY + k];
        d = d + abs(s);
    }

    return d;
}

double minkowski(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double p = pdParam[0];
    double d = pow(abs(pX[r] - pY[k]), p);

    for (int c = 1; c < cols; ++c)
    {
        d = d + pow(abs(pX[c * rowsX + r] - pY[c * rowsY + k]), p);
    }

    return pow(d, 1 / p);
}

double chebychev(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d = abs(pX[r] - pY[k]);

    for (int c = 1; c < cols; ++c)
    {
        double s = pX[c * rowsX + r] - pY[c * rowsY + k];
        d = Max(d, abs(s));
    }

    return d;
}

double cosine(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d = 0;
    double u = pX[r];
    double v = pY[k];
    double d1 = u * v;
    double d2 = u * u;
    double d3 = v * v;

    for (int c = 1; c < cols; ++c)
    {
        u = pX[c * rowsX + r];
        v = pY[c * rowsY + k];
        d1 = d1 + u * v;
        d2 = d2 + u * u;
        d3 = d3 + v * v;
    }
    d = 1 - d1 / sqrt(d2 * d3);
    return d;
}

double correlation(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d = 0;
    double u = pX[r];
    double v = pY[k];
    double mu = u;
    double mv = v;

    for (int c = 1; c < cols; ++c)
    {
        mu = mu + pX[c * rowsX + r];
        mv = mv + pY[c * rowsY + k];
    }
    mu = mu / cols;
    mv = mv / cols;

    u = u - mu;
    v = v - mv;

    double d1 = u * v;
    double d2 = u * u;
    double d3 = v * v;

    for (int c = 1; c < cols; ++c)
    {
        u = pX[c * rowsX + r] - mu;
        v = pY[c * rowsY + k] - mv;
        d1 = d1 + u * v;
        d2 = d2 + u * u;
        d3 = d3 + v * v;
    }

    d = 1 - d1 / sqrt(d2 * d3);

    return d;
}

double hamming(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d = 0;

    for (int c = 0; c < cols; ++c)
    {
        d = d + ((pX[c * rowsX + r] != pY[c * rowsY + k]) ? 1 : 0);
    }

    return d / cols;
}

double jaccard(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d1 = 0;
    double d2 = 0;

    for (int c = 0; c < cols; ++c)
    {
        double u = pX[c * rowsX + r];
        double v = pY[c * rowsY + k];
        double U = ((u != 0) || (v != 0)) ? 1 : 0;

        d1 = d1 + ((u != v && U) ? 1 : 0);
        d2 = d2 + U;
    }

    d1 = d1 / cols;
    d2 = d2 / cols;

    return d1 / d2;
}

double canberra(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d = 0;

    for (int c = 0; c < cols; ++c)
    {
        double u = pX[c * rowsX + r];
        double v = pY[c * rowsY + k];
        d = d + abs(u - v) / (abs(u) + abs(v));
    }

    return d;
}

double braycurtis(int rowsX, int rowsY, int cols, int r, int k, double* pX, double* pY, double* pdParam)
{
    double d1 = 0;
    double d2 = 0;

    for (int c = 0; c < cols; ++c)
    {
        double u = pX[c * rowsX + r];
        double v = pY[c * rowsY + k];
        d1 = d1 + abs(u - v);
        d2 = d2 + abs(u + v);
    }

    return d1 / d2;
}

std::map<std::wstring, std::function<double(int, int, int, int, int, double*, double*, double*)>> getdistance()
{
    return {
        {L"euclidean", euclidean},
        {L"euclid", euclidean},
        {L"eu", euclidean},
        {L"e", euclidean},
        {L"squaredeuclidean", squaredeuclidean},
        {L"sqeuclidean", squaredeuclidean},
        {L"sqe", squaredeuclidean},
        {L"sqeuclid", squaredeuclidean},
        {L"seuclidean", seuclidean},
        {L"se", seuclidean},
        {L"s", seuclidean},
        {L"mahalanobis", mahalanobis},
        {L"mahal", mahalanobis},
        {L"mah", mahalanobis},
        {L"city", cityblock},
        {L"city block", cityblock},
        {L"cityblock", cityblock},
        {L"cblock", cityblock},
        {L"cb", cityblock},
        {L"c", cityblock},
        {L"minkowski", minkowski},
        {L"mi", minkowski},
        {L"m", minkowski},
        {L"chebychev", chebychev},
        {L"chebyshev", chebychev},
        {L"cheby", chebychev},
        {L"cheb", chebychev},
        {L"ch", chebychev},
        {L"chebychev", chebychev},
        {L"cosine", cosine},
        {L"cos", cosine},
        {L"correlation", correlation},
        {L"co", correlation},
        {L"hamming", hamming},
        {L"hamm", hamming},
        {L"ha", hamming},
        {L"h", hamming},
        {L"jaccard", jaccard},
        {L"jacc", jaccard},
        {L"ja", jaccard},
        {L"j", jaccard},
        {L"canberra", canberra},
        {L"braycurtis", braycurtis}};
}
