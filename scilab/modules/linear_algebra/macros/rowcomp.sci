
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 1987-2008 - INRIA - François DELEBECQUE
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [w,rk]=rowcomp(A,flag,tol)
    //Row compression of A <--> computation of im(A)
    //flag and tol are optional parameters
    //flag='qr' or 'svd' (default 'svd')
    //tol tolerance parameter (sqrt(%eps)*norm(A,1) as default value)
    //the rk first (top) rows of w span the row range of a
    //the rk first columns of w' span the image of a

    arguments
        A {mustBeA(A, "double")}
        flag (1,1) {mustBeA(flag, "string"), mustBeMember(flag, ["svd", "qr"])} = "svd"
        tol (1,1) {mustBeA(tol, "double"), mustBeReal, mustBeNonnegative} = sqrt(%eps)*norm(A,1)
    end


    if A==[] then w=[];rk=0;return;end

    if norm(A,1) < sqrt(%eps)/10 then [ma,na]=size(A),rk=0,w=eye(ma,ma),return;end

    select flag
    case "qr" then
        [q,r,rk,e]=qr(A,tol);w=q';
    case "svd" then
        [u,s,v,rk]=svd(A,tol);w=u' ;
    end
endfunction


