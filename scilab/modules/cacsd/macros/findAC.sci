function [A,C,rcnd]=findAC(s,n,l,R,meth,tol,printw)
    
    //FINDAC  Finds the system matrices A and C of a discrete-time system, given the
    //        system order and the relevant part of the R factor of the concatenated
    //        block-Hankel matrices, using subspace identification techniques (MOESP
    //        or N4SID).
    //
    //        [A,C] = FINDAC(S,N,L,R,METH,TOL,PRINTW)  computes the system matrices
    //        A and C. The model structure is:
    //
    //             x(k+1) = Ax(k) + Bu(k) + Ke(k),   k >= 1,
    //             y(k)   = Cx(k) + Du(k) + e(k),
    //
    //        where x(k) and y(k) are vectors of length N and L, respectively.
    //
    //        [A,C,RCND] = FINDAC(S,N,L,R,METH,TOL,PRINTW)  also returns the vector
    //        RCND of length 4 containing the condition numbers of the matrices
    //        involved in rank decisions.
    //
    //        S is the number of block rows in the block-Hankel matrices.
    //
    //        METH is an option for the method to use:
    //        METH = 1 :  MOESP method with past inputs and outputs;
    //             = 2 :  N4SID method.
    //        Default:    METH = 1.
    //        Matrix R, computed by FINDR, should be determined with suitable arguments
    //        METH and JOBD.
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
    //        See also FINDABCD, FINDBD, FINDBDK, FINDR, ORDER, SIDENT
    //

    //        V. Sima 18-01-2000.
    //
    //        Revisions:
    //

    arguments
        s (1, 1) {mustBeA(s, "double"), mustBeInteger}
        n (1, 1) {mustBeA(n, "double"), mustBeInteger}
        l (1, 1) {mustBeA(l, "double"), mustBeInteger}
        R {mustBeA(R, "double")}
        meth {mustBeA(meth, "double"), mustBeMember(meth, [1, 2, 3])} = 1
        tol {mustBeA(tol, "double")} = 0
        printw (1,1) {mustBeA(printw, "double"), mustBeMember(printw, [0, 1])} = 0
    end

    nout = nargout;
    if tol==[] then tol = 0;end
    if meth==[] then meth = 1;end
    A=[];C=[];rcnd=[];
    //
    // Compute system matrices A and C.
    job = 2;
    nsmpl = 0;
    if nout==1 then
        A = sident(meth,job,s,n,l,R,tol,nsmpl,[],[],printw);
    elseif nout==2 then
        [A,C] = sident(meth,job,s,n,l,R,tol,nsmpl,[],[],printw);
    elseif nout==3 then
        [A,C,rcnd] = sident(meth,job,s,n,l,R,tol,nsmpl,[],[],printw);
    else
        error(msprintf(gettext("%s: Wrong number of output arguments: %d to %d expected.\n"),"findAC",1,3));
    end
    //
    // end findAC
endfunction
