// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) XXXX-2008 - INRIA
// Copyright (C) 2005 - IRISA - Sage Group

//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.


// [x, flag, err, iter, res] = qmr( A, b, x, M1, M2, max_it, tol )
//
// QMR solves the linear system Ax=b using the
// Quasi Minimal Residual method with preconditioning.
//
// input   A        REAL matrix or function
//         x        REAL initial guess vector
//         b        REAL right hand side vector
//         M1       REAL left preconditioner matrix
//         M2       REAL right preconditioner matrix
//         max_it   INTEGER maximum number of iterations
//         tol      REAL error tolerance
//
// output  x        REAL solution vector
//         flag     INTEGER: 0: solution found to tolerance
//                           1: no convergence given max_it
//                     breakdown:
//                          -1: rho
//                          -2: Beta
//                          -3: gam
//                          -4: delta
//                          -5: ep
//                          -6: xi
//         err      REAL final residual norm
//         iter     INTEGER number of iterations performed
//         res      REAL residual vector

//     Details of this algorithm are described in
//
//     "Templates for the Solution of Linear Systems: Building Blocks
//     for Iterative Methods",
//     Barrett, Berry, Chan, Demmel, Donato, Dongarra, Eijkhout,
//     Pozo, Romine, and Van der Vorst, SIAM Publications, 1993
//     (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
//
//     "Iterative Methods for Sparse Linear Systems, Second Edition"
//     Saad, SIAM Publications, 2003
//     (ftp ftp.cs.umn.edu; cd dept/users/saad/PS; get all_ps.zip).

// Sage Group (IRISA, 2005)

function [x, flag, err, iter, res] = qmr(A, varargin)

    // -----------------------
    // Parsing input arguments
    // -----------------------
    [lhs,rhs]=argn(0);
    if (rhs < 2  || rhs > 7),
        error(msprintf(gettext("%s: Wrong number of input arguments: %d to %d expected.\n"),"qmr",2,7));
    end
    
    // Parsing A
    if or(type(A) == [1 5]) then // If A is a matrix (dense or sparse)
        if (size(A,1) ~= size(A,2)),
            error(msprintf(gettext("%s: Wrong size for input argument #%d: Square matrix expected.\n"),"qmr",1));
        end
        matvec = internal_matvec;
    elseif type(A) == 13 then  // If A is a function
        if size(getfield(1,macrovar(A)),"*") <> 2 then
            error(msprintf(gettext("%s: Wrong prototype of input argument #%d: A function with %d input arguments expected.\n"), "qmr", 1, 2));
        end
        matvec = A;
    else
        error(msprintf(gettext("%s: Wrong type for input argument #%d : A real or complex matrix or a sparse matrix or a function expected.\n"),"qmr",1));
    end

    // Parsing right hand side b
    if ( rhs >= 2 ),
        b=varargin(1);
        // if b is not constant or sparse
        if and(type(b) <> [1 5])  then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A real or complex, full or sparse column vector expected.\n"), "qmr", 2));
        end

        if ( size(b,2) ~= 1),
            error(msprintf(gettext("%s: Wrong size for input argument #%d: Column vector expected.\n"),"qmr",2));
        end
    end

    // Parsing initial vector x
    if ( rhs >= 3),
        x=varargin(2);
        // if x is not constant or sparse
        if and(type(x) <> [1 5])  then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A real or complex, full or sparse column vector expected.\n"), "qmr", 3));
        end
        if (size(x,2) ~= 1),
            error(msprintf(gettext("%s: Wrong size for input argument #%d: Column vector expected.\n"),"qmr",3));
        end
        if ( size(x,1) ~= size(b,1)),
            error(msprintf(gettext("%s: Wrong size for input argument #%d: Same size as input argument #%d expected.\n"),"qmr",3,2));
        end
    else // By default
        x=zeros(size(b,1),1);
    end

    //--------------------------------------------------------
    // Parsing of the preconditioner matrix M1
    //--------------------------------------------------------
    if (rhs >= 4),
        Prec_g=varargin(3);
        if or(type(Prec_g) == [1 5]) then // If M1 is a matrix (dense or sparse)
            if (size(Prec_g,1) ~= size(Prec_g,2)),
                error(msprintf(gettext("%s: Wrong size for input argument #%d: Square matrix expected.\n"),"qmr",4));
            end
            if (size(Prec_g,1)~=size(b,1)),
                error(msprintf(gettext("%s: Wrong size for input argument #%d: Same size as input argument #%d expected.\n"),"qmr",4,2));
            end
            precond_g = internal_precond_g;
        elseif type(Prec_g) == 13 then  // If M1 is a function
            if size(getfield(1, macrovar(Prec_g)), "*") <> 2 then
                error(msprintf(gettext("%s: Wrong prototype of input argument #%d: A function with %d input arguments expected.\n"), "qmr", 4, 2));
            end
            precond_g = Prec_g;
        else
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A real or complex, full or sparse, square matrix or a function expected.\n"), "qmr", 4));
        end
    else // By default
        Prec_g = 1;
        precond_g = internal_precond_g;
    end

    //--------------------------------------------------------
    // Parsing of the preconditioner matrix M2
    //--------------------------------------------------------
    if (rhs >= 5),
        Prec_d=varargin(4);
        if or(type(Prec_d) == [1 5]) then // If M2 is a matrix (dense or sparse)
            if (size(Prec_d,1) ~= size(Prec_d,2)),
                error(msprintf(gettext("%s: Wrong size for input argument #%d: Square matrix expected.\n"),"qmr",5));
            end
            if (size(Prec_d,1)~=size(b,1)),
                error(msprintf(gettext("%s: Wrong size for input argument #%d: Same size as input argument #%d expected.\n"),"qmr",5,2));
            end
            precond_d = internal_precond_d;
        elseif type(Prec_d) == 13 then  // If M2 is a function
            if size(getfield(1, macrovar(Prec_d)), "*") <> 2 then
                error(msprintf(gettext("%s: Wrong prototype of input argument #%d: A function with %d input arguments expected.\n"), "qmr", 5, 2));
            end
            precond_d = Prec_d;
        else
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A real or complex, full or sparse, square matrix or a function expected.\n"), "qmr", 5));
        end
    else  // By default
        precond_d = internal_precond_d;
        Prec_d = 1;
    end

    //--------------------------------------------------------
    // Parsing of the maximum number of iterations max_it
    //--------------------------------------------------------
    if (rhs >= 6),
        max_it=varargin(5);
        // if max_it is not constant
        if type(max_it) <> 1 then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: Scalar expected.\n"),"qmr",6));
        end

        if ~isreal(max_it) then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A real scalar expected.\n"),"qmr",6));
        end

        if (size(max_it,1) ~= 1 | size(max_it,2) ~=1),
            error(msprintf(gettext("%s: Wrong size for input argument #%d: Scalar expected.\n"),"qmr",6));
        end
    else // By default
        max_it=size(b,1);
    end

    //--------------------------------------------------------
    // Parsing of the error tolerance tol
    //--------------------------------------------------------
    if (rhs == 7),
        tol=varargin(6);
        // if tol is not constant
        if type(tol) <> 1 then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: Scalar expected.\n"),"qmr",7));
        end

        if ~isreal(tol) then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A real scalar expected.\n"),"qmr",7));
        end

        if (size(tol,1) ~= 1 | size(tol,2) ~=1),
            error(msprintf(gettext("%s: Wrong size for input argument #%d: Scalar expected.\n"),"qmr",7));
        end
    else // By default
        tol=1000*%eps;
    end

    // ------------
    // Computations
    // ------------

    // initialization
    i = 0;
    flag = 0;
    iter = 0;
    bnrm2 = norm( b );
    if  (bnrm2 == 0.0),
        bnrm2 = 1.0;
    end

    //   r = b - A*x;
    r = b - matvec(x,"notransp");

    err = norm( r ) / bnrm2;
    res = err;
    if ( err < tol ), return; end

    // [M1,M2] = lu( M );
    v_tld = r;

    // y = M1 \ v_tld;
    y = precond_g(v_tld,"notransp");

    rho = norm( y );

    w_tld = r;
    //   z = M2' \ w_tld;
    z = precond_d(w_tld,"transp");

    xi = norm( z );

    gam =  1.0;
    eta = -1.0;
    theta =  0.0;

    for i = 1:max_it,                      // begin iteration
        if ( rho == 0.0 | xi == 0.0 ), iter=i; break; end
        v = v_tld / rho;
        y = y / rho;

        w = w_tld / xi;
        z = z / xi;

        delta = z'*y;
        if ( delta == 0.0 ), iter=i; break; end

        //    y_tld = M2 \ y;
        y_tld = precond_d(y,"notransp");

        //    z_tld = M1'\ z;
        z_tld = precond_g(z,"transp");

        if ( i > 1 ),                       // direction vector
            p = y_tld - ( xi*delta / ep )*p;
            q = z_tld - ( rho*delta / ep )*q;
        else
            p = y_tld;
            q = z_tld;
        end

        //    p_tld = A*p;
        p_tld = matvec(p,"notransp");

        ep = q'*p_tld;
        if ( ep == 0.0 ), iter=i; break; end

        Beta = ep / delta;
        if ( Beta == 0.0 ), iter=i; break; end

        v_tld = p_tld - Beta*v;

        //    y =  M1 \ v_tld;
        y = precond_g(v_tld,"notransp");

        rho_1 = rho;
        rho = norm( y );

        //    w_tld = ( A'*q ) - ( Beta*w );
        w_tld = ( matvec(q,"transp") ) - ( Beta*w );

        //    z =  M2' \ w_tld;
        z = precond_d(w_tld,"transp");

        xi = norm( z );
        gamma_1 = gam;
        theta_1 = theta;
        theta = rho / ( gamma_1*Beta );
        gam = 1.0 / sqrt( 1.0 + (theta^2) );
        if ( gam == 0.0 ), iter=i; break; end

        eta = -eta*rho_1*(gam^2) / ( Beta*(gamma_1^2) );

        if ( i > 1 ),                         // compute adjustment
            d = eta*p + (( theta_1*gam )^2)*d;
            s = eta*p_tld + (( theta_1*gam )^2)*s;
        else
            d = eta*p;
            s = eta*p_tld;
        end
        x = x + d;                               // update approximation

        r = r - s;                               // update residual
        err = norm( r ) / bnrm2;               // check convergence
        res = [res;err];

        if ( err <= tol ), iter=i; break; end

        if ( i == max_it ), iter=i; end
    end

    if ( err <= tol ),                        // converged
        flag =  0;
    elseif ( rho == 0.0 ),                      // breakdown
        flag = -1;
    elseif ( Beta == 0.0 ),
        flag = -2;
    elseif ( gam == 0.0 ),
        flag = -3;
    elseif ( delta == 0.0 ),
        flag = -4;
    elseif ( ep == 0.0 ),
        flag = -5;
    elseif ( xi == 0.0 ),
        flag = -6;
    else                                        // no convergence
        flag = 1;
    end

endfunction

function y = internal_matvec(x,t)
    if (t=="notransp") then
        y = A*x;
    elseif (t=="transp") then
        y = A'*x;
    end
endfunction

function y = internal_precond_g(x,t)
    if (t=="notransp") then
        y = Prec_g*x;
    elseif (t=="transp") then
        y = Prec_g'*x;
    end
endfunction

function y = internal_precond_d(x,t)
    if (t=="notransp") then
        y = Prec_d*x;
    elseif (t=="transp") then
        y = Prec_d'*x;
    end
endfunction

