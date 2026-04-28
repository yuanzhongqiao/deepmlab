function [x0,B,D,V,rcnd]=findx0BD(A,C,y,u,withx0,withd,tol,printw)
    
    //FINDX0BD  Estimates the initial state and/or the matrices B and D of a
    //          discrete-time linear system, given the (estimated) system
    //          matrices A, C, and a set of input/output data.
    //
    //        [X0,B,D] = FINDX0BD(A,C,Y,U,WITHX0,WITHD,TOL,PRINTW)  estimates the
    //        initial state X0 and the matrices B and D of a discrete-time
    //        system using the system matrices A, C, output data Y and the input
    //        data U. The model structure is :
    //
    //             x(k+1) = Ax(k) + Bu(k),   k >= 1,
    //             y(k)   = Cx(k) + Du(k),
    //
    //        The vectors y(k) and u(k) are transposes of the k-th rows of Y and U,
    //        respectively.
    //
    //        WITHX0 is a select for estimating the initial state x0.
    //        WITHX0 = 1: estimate x0;
    //               = 0: do not estimate x0.
    //        Default:    WITHX0 = 1.
    //
    //        WITHD  is a select for estimating the matrix D.
    //        WITHD  = 1: estimate the matrix D;
    //               = 0: do not estimate the matrix D.
    //        Default:    WITHD = 1.
    //
    //        TOL is the tolerance used for estimating the rank of matrices.
    //        If  TOL > 0,  then the given value of  TOL  is used as a lower bound
    //        for the reciprocal condition number.
    //        Default:    prod(size(matrix))*epsilon_machine where epsilon_machine
    //                    is the relative machine precision.
    //
    //        PRINTW is a select for printing the warning messages.
    //        PRINTW = 1: print warning messages;
    //               = 0: do not print warning messages.
    //        Default:    PRINTW = 0.
    //
    //        [x0,B,D,V,rcnd] = FINDX0BD(A,C,Y,U)  also returns the orthogonal
    //        matrix V which reduces the system state matrix A to a real Schur
    //        form, as well as some estimates of the reciprocal condition numbers
    //        of the matrices involved in rank decisions.
    //
    //            B = FINDX0BD(A,C,Y,U,0,0)  returns B only, and
    //        [B,D] = FINDX0BD(A,C,Y,U,0)    returns B and D only.
    //
    //        See also FINDBD, INISTATE
    //

    //        V. Sima 13-05-2000.
    //
    //        For efficiency, most errors are checked in the mexfile findBD.
    //
    //        Revisions:
    //        V. Sima, July 2000.
    //

    arguments
        A {mustBeA(A, "double")}
        C {mustBeA(C, "double")}
        y {mustBeA(y, "double")}
        u {mustBeA(u, "double")}
        withx0 {mustBeA(withx0, "double"), mustBeMember(withd, [0 1])} = 1
        withd {mustBeA(withd, "double"), mustBeMember(withd, [0 1])} = 1
        tol {mustBeA(tol, "double")} = 0
        printw (1,1) {mustBeA(printw, "double"), mustBeMember(printw, [0, 1])} = 0
    end

    nout = nargout;
    x0=[];B=[];D=[];V=[];rcnd=[];

    if tol==[] then tol = 0;end
    if withx0 ==[] then  withx0 = 1;end
    job = withd+1;
    //
    if withx0==1 then
        if withd==1 then
            [x0,B,D,Vl,rcndl] = findBD(withx0,1,job,A,C,y,u,tol,printw);
            if nout>3 then
                V = Vl;
            end
            if nout>4 then
                rcnd = rcndl;
            end
        else
            [x0,B,Vl,rcndl] = findBD(withx0,1,job,A,C,y,u,tol,printw);
            if nout>2 then
                D = Vl;
            end
            if nout>3 then
                V = rcndl;
            end
        end
    else
        // Below, x0 means B, and B means D or V !
        if withd==1 then
            [x0,B,Vl,rcndl] = findBD(withx0,1,job,A,C,y,u,tol,printw);
            if nout>2 then
                D = Vl;
            end
            if nout>3 then
                V = rcndl;
            end
        else
            [x0,B,Vl] = findBD(withx0,1,job,A,C,y,u,tol,printw);
            if nout>2 then
                D = Vl;
            end
        end
    end
    //
    // end findx0BD
endfunction
