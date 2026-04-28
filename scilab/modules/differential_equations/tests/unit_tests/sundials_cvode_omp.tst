// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->


with_openmp=%t;
try
    cvode(%SUN_vdp1,[0 1],[0 1],nbThreads=4);
catch
    with_openmp=%f;
end    

if with_openmp

    NUM_THREADS=4;
    mputl([
    "#include <nvector/nvector_openmp.h>"  
    "int f(sunrealtype t, N_Vector Y, N_Vector Yd, void *pManager)"
    "{"
    "    double *y = N_VGetArrayPointer(Y);"
    "    double *yd = N_VGetArrayPointer(Yd);"
    "    double *par = (double *)pManager;"
    "    int n = (int)par[0];"
    "    int nhalf = n/2;"
    "    int n2 = n*n;"
    "    double dx = par[1];"
    "    double dx2 = dx*dx;"
    ""
    "    N_VConst(0,Yd);"
    "    #pragma omp parallel for num_threads("+string(NUM_THREADS)+")"
    "    for (int i = 1 ; i < n-1 ; i++) {"
    "        for (int j = 1 ; j <n-1 ; j++) {"
    "            for (int k = 1 ; k <n-1 ; k++)"
    "            {"
    "                int l0=i+j*n+k*n2;"
    "                yd[l0]=(-6.0*y[l0]+y[l0-1]+y[l0+1]+y[l0-n]+y[l0+n]+y[l0-n2]+y[l0+n2])/dx2;"
    "            }"
    "        }"
    "    }"
    "    return 0;"
    "}"
    ],TMPDIR+"/code.c");
    SUN_Clink("f",TMPDIR+"/code.c",load=%t,cflags="-O3 -fopenmp");
    
    n = 80; //n should be even n = 80 yields 80^3=512000 states 
    n2 = n*n;
    dx = 2/(n-1);
    [x,y,z] = ndgrid(-1:dx:1,-1:dx:1,-1:dx:1);
    f0 = x.*x+y.*y+z.*z;
    
    [t,f,info1]=cvode(list("f",[n dx]),0.5,f0,t0=0,method="BDF",linearSolver="CG",...
        rtol=1e-3,atol=1e-3,nbThreads=NUM_THREADS);
    
    // don't pass -fopenmp => ignore pragma directive in source
    SUN_Clink("f",TMPDIR+"/code.c",load=%t,cflags="-O3");
    
    [t,f,info2]=cvode(list("f",[n dx]),0.5,f0,t0=0,method="BDF",linearSolver="CG",...
        rtol=1e-3,atol=1e-3);

end
