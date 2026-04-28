// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2022 - UTC - Stéphane Mottelet
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
    "int SUN_lorenz(sunrealtype t, N_Vector N_VectorY, N_Vector N_VectorYd, void *data)"
    "{"
    "double *y = N_VGetArrayPointer(N_VectorY);"
    "double *ydot = N_VGetArrayPointer(N_VectorYd);"
    "double *par = (double *)data;"
    "int n=(int)par[0];";
    "double sigma=par[1];"
    "double rho=par[2];"
    "double bet=par[3];"
    "#pragma omp parallel for num_threads("+string(NUM_THREADS)+")"
    "for (int i=0;i<n;i++) {"
    "   int k=3*i;"
    "   ydot[k]=sigma*(y[k+1]-y[k]);"
    "   ydot[k+1]=rho*y[k]-y[k+1]-y[k]*y[k+2];"
    "   ydot[k+2]=y[k]*y[k+1]-bet*y[k+2];"
    "}"
    "return 0;"
    "}"
    ],TMPDIR+"/SUN_lorenz_omp.c");
    SUN_Clink("SUN_lorenz",TMPDIR+"/SUN_lorenz_omp.c",cflags="-O3 -fopenmp",load=%t);
    
    sigma=10;
    rho=28;
    bet=8/3;
    
    n=100000; 
    X0=rand(3,n,"normal");
    s2=sqrt(sum(X0.*X0,1));
    X0=X0./s2([1 1 1],:)*30;
    X0(3,:)=X0(3,:)+30;
    
    [t,y,info1]=arkode(list("SUN_lorenz",[n,sigma,rho,bet]),5,X0,t0=0,...
               method="ERK_5",nbThreads=NUM_THREADS);
    
    // don't pass -fopenmp => ignore pragma directive in source
    SUN_Clink("SUN_lorenz",TMPDIR+"/SUN_lorenz_omp.c",cflags="-O3",load=%t);
    
    [t,y,info2]=arkode(list("SUN_lorenz",[n,sigma,rho,bet]),5,X0,t0=0,...
               method="ERK_5");
               
end
