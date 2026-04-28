// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA -
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function [n,nc,u,sl,v]=st_ility(sl,tol)
    //stabilizability test

    arguments
        sl {mustBeA(sl, "lss")}
        tol {mustBeA(tol, "double"), mustBeScalarOrEmpty} = []
    end

    [a,b,c,d,x0,dom]=sl(2:7);
    if dom==[] then
        warning(msprintf(gettext("%s: Input argument #%d is assumed continuous time.\n"),"st_ility",1));
        dom="c";
    end
    typ="c";if dom<>"c" then typ="d",end
    [na,na]=size(a);
    [nw,nb]=size(b);
    if nb==0 then
        b=zeros(na,1);
    end
    // controllable part
    if nargin == 1 then
        [n,u,ind,V,a,b]=contr(a,b);
    else
        [n,u,ind,V,a,b]=contr(a,b,tol);
    end
    
    if nb==0 then
        b=[];
    end;
    n=sum(n);nc=n;
    if nargout==4 then c=c*u;x0=u'*x0;end
    if n<>na then
        //order evals uncont. part
        nn=n+1:na;
        [v,n1]=schur(a(nn,nn),part(typ,1))
        n=n+n1
        //new realization
        if nargout>2 then
            u(:,nn)=u(:,nn)*v
            if nargout==4 then
                a(:,nn)=a(:,nn)*v;a(nn,nn)=v'*a(nn,nn)
                b(nn,:)=v'*b(nn,:)
                c(:,nn)=c(:,nn)*v
                x0(nn)=v'*x0(nn)
            end;
        end;
    end;
    //
    if nargout==4 then sl=syslin(dom,a,b,c,d,x0),end
    if nargout==5 then v=sl.B;sl=sl.A;end
endfunction
