// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C)  2016 - INRIA - Serge Steer
//
// This file is licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// For more information, see the COPYING file which you should have received
// along with this program.
function [Zc,Pc]=reduceToCommonDenominator(Z,P,K)
    
    arguments
        Z {mustBeA(Z, "cell")}
        P {mustBeA(P, "cell"), mustBeEqualDims(P, Z)}
        K {mustBeA(K, "double"), mustBeReal, mustBeEqualDims(K, Z)}
    end
    if typeof(Z)<>"ce" then
        error(msprintf(_("%s: Wrong type for input argument #%d: Cell expected.\n"),...
        "reduceToCommonDenominator",1))
    end
    if typeof(P)<>"ce" then
        error(msprintf(_("%s: Wrong type for input argument #%d: Cell expected.\n"),...
        "reduceToCommonDenominator",2))
    end
    if type(K)<>1|~isreal(K) then
        error(msprintf(_("%s: Wrong type for input argument #%d: real matrix expected.\n"),...
        "reduceToCommonDenominator",3))
    end

    Pc=P{1};
    mn=size(Z)
    n=prod(mn)
    Zc=Z;
    for k=2:n
        if K(k)<>0 then
            if P{k}<>[]then
                [pc,pk,c]=simplify_zp(Pc,P{k});
                Pc=[pc;pk;c];
                for i=1:k-1,Zc{i}=[Zc{i};pk];end
                Zc{k}=[Zc{k};pc];
            else
                Zc{k}=[Zc{k};Pc];
            end
        else
            Zc{k}=[]
        end
    end
endfunction

