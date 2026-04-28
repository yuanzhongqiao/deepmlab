/* -----------------------------------------------------------------
 * Programmer: Cody J. Balos @ LLNL
 * -----------------------------------------------------------------
 * SUNDIALS Copyright Start
 * Copyright (c) 2002-2023, Lawrence Livermore National Security
 * and Southern Methodist University.
 * All rights reserved.
 *
 * See the top-level LICENSE and NOTICE files for details.
 *
 * SPDX-License-Identifier: BSD-3-Clause
 * SUNDIALS Copyright End
 * -----------------------------------------------------------------*/

#ifndef _SUNDIALS_LAPACK_H
#define _SUNDIALS_LAPACK_H

#include <sundials/sundials_types.h>

#ifdef __cplusplus  /* wrapper to enable C++ usage */
extern "C" {
#endif

/*
 * ==================================================================
 * Blas and Lapack functions
 * ==================================================================
 */

#if defined(SUNDIALS_F77_FUNC)

#define dgbtrf_f77      SUNDIALS_F77_FUNC(dgbtrf, DGBTRF)
#define dgbtrs_f77      SUNDIALS_F77_FUNC(dgbtrs, DGBTRS)
#define dgetrf_f77      SUNDIALS_F77_FUNC(dgetrf, DGETRF)
#define dgetrs_f77      SUNDIALS_F77_FUNC(dgetrs, DGETRS)

#define sgbtrf_f77      SUNDIALS_F77_FUNC(sgbtrf, SGBTRF)
#define sgbtrs_f77      SUNDIALS_F77_FUNC(sgbtrs, SGBTRS)
#define sgetrf_f77      SUNDIALS_F77_FUNC(sgetrf, SGETRF)
#define sgetrs_f77      SUNDIALS_F77_FUNC(sgetrs, SGETRS)

#else

#define dgbtrf_f77      dgbtrf_
#define dgbtrs_f77      dgbtrs_
#define dgetrf_f77      dgetrf_
#define dgetrs_f77      dgetrs_

#define sgbtrf_f77      sgbtrf_
#define sgbtrs_f77      sgbtrs_
#define sgetrf_f77      sgetrf_
#define sgetrs_f77      sgetrs_

#endif

/* LAPACK */

extern void dgbtrf_f77(const int *m, const int *n,
                       const int *kl, const int *ku,
                       double *ab, int *ldab, int *ipiv,
                       int *info);

extern void dgbtrs_f77(const char *trans, const int *n,
                       const int *kl, const int *ku,
                       const int *nrhs, double *ab,
                       const int *ldab, int *ipiv,
                       double *b, const int *ldb, int *info);


extern void dgetrf_f77(const int *m, const int *n, double *a,
                       int *lda, int *ipiv,
                       int *info);

extern void dgetrs_f77(const char *trans, const int *n,
                       const int *nrhs, double *a,
                       const int *lda, int *ipiv, double *b,
                       const int *ldb, int *info);

extern void sgbtrf_f77(const int *m, const int *n,
                       const int *kl, const int *ku,
                       float *ab, int *ldab, int *ipiv,
                       int *info);

extern void sgbtrs_f77(const char *trans, const int *n,
                       const int *kl, const int *ku,
                       const int *nrhs, float *ab,
                       const int *ldab, int *ipiv,
                       float *b, const int *ldb, int *info);

extern void sgetrf_f77(const int *m, const int *n, float *a,
                       int *lda, int *ipiv,
                       int *info);

extern void sgetrs_f77(const char *trans, const int *n,
                       const int *nrhs, float *a,
                       const int *lda, int *ipiv,
                       float *b, const int *ldb, int *info);

#ifdef __cplusplus
}
#endif

#endif
