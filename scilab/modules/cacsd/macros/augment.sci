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


function [P,r]=augment(G,SRT,flag)
    // Augmented plants P
    // flag='output' (default) :
    //
    //       [ I | -G]   -->'S'
    //       [ 0 |  I]   -->'R'
    //   P = [ 0 |  G]   -->'T'
    //       [-------]
    //       [ I | -G]
    //
    //
    // flag='input' :
    //
    //       [ I | -I]   -->'S'
    //       [ G | -G]   -->'R'
    //   P = [ 0 |  I]   -->'T'
    //       [-------]
    //       [ G | -G]
    //!

    arguments
        G {mustBeA(G, ["r", "lss"])}
        SRT {mustBeA(SRT, "string"), mustBeMember(SRT, ["S", "R", "T", "SR", "ST", "RT", "SRT"])}= "SRT"
        flag {mustBeA(flag, "string"), mustBeMember(flag, ["output", "input", "o", "i"])}= "output"
    end

    select part(flag,1)
    case "o"
        G1=G(1);
        r=size(G);
        [ny,nu]=size(G);Iu=eye(nu,nu);Iy=eye(ny,ny);
        Ouy=zeros(nu,ny);Oyu=zeros(ny,nu);Ouu=zeros(nu,nu);
        Oyy=zeros(ny,ny);
        ssSRT=0;
        if G1(1)=="r" then ssSRT=1;end
        long=length(SRT);
        select long
        case 3 then
            // 'SRT'
            if ssSRT==0 then
                W1=[Iy,Oyu,Oyy;
                Ouy,Iu,Ouy;
                -Iy,Oyu,Iy;
                Iy,Oyu,Oyy];
                W2=[Iy,-G;
                Ouy,Iu;
                Iy,Oyu];
                P=W1*W2;
            end
            if ssSRT ==1 then
                P=[Iy,-G;
                Ouy,Iu;
                Oyy,G;
                Iy,-G]
            end
            return
        case 2 then
            if SRT=="SR" then
                if ssSRT==0 then
                    W1=[Iy,Oyu,Oyy;
                    Ouy,Iu,Ouy;
                    Iy,Oyu,Oyy];
                    W2=[Iy,-G;
                    Ouy,Iu;
                    Iy,Oyu];
                    P=W1*W2;
                end
                if ssSRT==1 then
                    P=[Iy,-G;
                    Ouy,Iu;
                    Iy,-G];
                end
                return
            end
            if SRT=="ST" then
                if ssSRT==0 then
                    W1=[Iy,Oyu,Oyy;
                    -Iy,Oyu,Iy;
                    Iy,Oyu,Oyy];
                    W2=[Iy,-G;
                    Ouy,Iu;
                    Iy,Oyu];
                    P=W1*W2;
                end
                if ssSRT ==1 then
                    P=[Iy, -G;
                    Oyy, G;
                    Iy, -G];
                end
                return
            end
            if SRT=="RT" then
                if ssSRT==0 then
                    W1=[Ouy,Iu,Ouy;
                    -Iy,Oyu,Iy;
                    Iy,Oyu,Oyy];
                    W2=[Iy,-G;
                    Ouy,Iu;
                    Iy,Oyu];
                    P=W1*W2;
                end;
                if ssSRT ==1 then
                    P=[Ouy,Iu;
                    Oyy,G;
                    Iy,-G];
                end
                return
            end
        case 1 then
            if SRT=="S" then
                if ssSRT==0 then
                    W1=[Iy,Oyu,Oyy;
                    Iy,Oyu,Oyy];
                    W2=[Iy,-G;
                    Ouy,Iu;
                    Iy,Oyu];
                    P=W1*W2;
                end;
                if ssSRT ==1 then
                    P=[Iy,-G;
                    Iy,-G];
                end
                return
            end
            if SRT=="R" then
                if ssSRT==0 then
                    W1=[Ouy,Iu,Ouy;
                    Iy,Oyu,Oyy];
                    W2=[Iy,-G;
                    Ouy,Iu;
                    Iy,Oyu];
                    P=W1*W2;
                end
                if ssSRT ==1 then
                    P=[Ouy,Iu;
                    Iy,-G];
                end
                return
            end
            if SRT=="T" then
                if ssSRT==0 then
                    W1=[-Iy,Oyu,Iy;
                    Iy,Oyu,Oyy];
                    W2=[Iy,-G;
                    Ouy,Iu;
                    Iy,Oyu];
                    P=W1*W2;
                end
                if ssSRT ==1 then
                    P=[Oyy,G;
                    Iy,-G];
                end
                return
            end
        end
    case "i"
        G1=G(1);
        r=size(G);
        [ny,nu]=size(G);Iu=eye(nu,nu);Iy=eye(ny,ny);
        Ouy=zeros(nu,ny);Oyu=zeros(ny,nu);Ouu=zeros(nu,nu);
        Oyy=zeros(ny,ny);
        ssSRT=0;
        if G1(1)=="r" then ssSRT=1;end
        long=length(SRT);
        select long
        case 3 then
            // 'SRT'
            if ssSRT==0 then
                W1=[Iu,-Iu;
                Oyu,Oyu;
                Ouu,Iu;
                Oyu,Oyu];
                W2=[Ouy;Iy;Ouy;Iy];
                W3=[Iu,-Iu];
                P=W1+W2*G*W3;
            end
            if ssSRT ==1 then
                P=[Iu,-Iu;
                G,-G;
                Ouu,Iu;
                G,-G]
            end
            return
        case 2 then
            if SRT=="SR" then
                if ssSRT==0 then
                    W1=[Iu,-Iu;
                    Oyu,Oyu;
                    Oyu,Oyu];
                    W2=[Ouy;Iy;Iy];
                    W3=[Iu,-Iu];
                    P=W1+W2*G*W3;
                end
                if ssSRT==1 then
                    P=[Iu,-Iu;
                    G,-G;
                    G,-G]
                end
                return
            end
            if SRT=="ST" then
                if ssSRT==0 then
                    W1=[Iu,-Iu;
                    Ouu,Iu;
                    Oyu,Oyu];
                    W2=[Ouy;Ouy;Iy];
                    W3=[Iu,-Iu];
                    P=W1+W2*G*W3;
                end
                if ssSRT ==1 then
                    P=[Iu,-Iu;
                    Ouu,Iu;
                    G,-G]
                end
                return
            end
            if SRT=="RT" then
                if ssSRT==0 then
                    W1=[Oyu,Oyu;
                    Ouu,Iu;
                    Oyu,Oyu];
                    W2=[Iy;Ouy;Iy];
                    W3=[Iu,-Iu];
                    P=W1+W2*G*W3;
                end;
                if ssSRT ==1 then
                    P=[G,-G;
                    Ouu,Iu;
                    G,-G]
                end
                return
            end

        case 1 then
            if SRT=="S" then
                if ssSRT==0 then
                    W1=[Iu,-Iu;
                    Oyu,Oyu];
                    W2=[Ouy;Iy];
                    W3=[Iu,-Iu];
                    P=W1+W2*G*W3;

                end;
                if ssSRT ==1 then
                    P=[Iu,-Iu;
                    G,-G]
                end
                return
            end
            if SRT=="R" then
                if ssSRT==0 then
                    W1=[Oyu,Oyu;
                    Oyu,Oyu];
                    W2=[Iy;Iy];
                    W3=[Iu,-Iu];
                    P=W1+W2*G*W3;
                end
                if ssSRT ==1 then
                    P=[G,-G;
                    G,-G]
                end
                return
            end
            if SRT=="T" then
                if ssSRT==0 then
                    W1=[Ouu,Iu;
                    Oyu,Oyu];
                    W2=[Ouy;Iy];
                    W3=[Iu,-Iu];
                    P=W1+W2*G*W3;
                end
                if ssSRT ==1 then
                    P=[Ouu,Iu;
                    G,-G]
                end
                return
            end
        end
    end
endfunction
