/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "gw_statistics.h"
#include "CdfBase.h"

extern int C2F(cdftnc)(int *, double *, double *, double *, double *, double *, int *, double *);

/**
 * Interface to dcdflib's cdftnc
 * SUBROUTINE CDFTNC( WHICH, P, Q, T, DF, PNONC, STATUS, BOUND )
 * Cumulative Distribution Function, Non central T distribution
 */
int sci_cdftnc(char* fname, void* pvApiCtx)
{
    struct cdf_item items[] =
    {
        {"PQ", 3, 2, 2},
        {"T" , 4, 1, 3},
        {"Df", 4, 1, 4},
        {"Pnonc", 4, 1, 0}
    };
    struct cdf_descriptor cdf = mkcdf(cdftnc, 4, 5, 0, 2, items);
    return cdf_generic(fname, pvApiCtx, &cdf);
}
