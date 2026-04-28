//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_npend()

    //collapsing chain
    function [Vd,Dd,Fd]=npend(t,x,u,mass,g)
        nb = length(mass);
        n = length(x);
        //derivative of the potential
        Vd = zeros(1,n);
        Vd(2:2:$)=g*mass;
        //derivative of the Rayleigh function (Viscous forces)
        Dd = 0.5*u.';
        //derivative of the constraints functions
        Fd = zeros(nb,n);
        Fd(1,1:2) = x(1:2).';
        for i=1:nb-1
            xi=x(2*i-1:2*i);
            xip1=x(2*i+1:2*i+2);
            Fd(i+1,2*i-1:2*i+2)=[-(xi-xip1);(xi-xip1)].'; 
        end
    endfunction 

    //display callback
    function term=cbFn(t,y,yp,flag,stats)
        term=%f;
        if flag=="init"
            clf
            demo_viewCode("demo_npend.sce")
            x0=y(1:2*nb);
            h=plot([0;x0(1:2:$)],[0;x0(2:2:$)],"-o","thickness",2);
            h.tag="chain";
            isoview on
            gca().data_bounds=[-1 1 -1.2 0.2]
            title(msprintf("t=%4.1f",t))
        else
            try
                realtime(t)
                data = get("chain", "data");
                if data == [] then term=%t; return; end

                nb=size(data,1)-1;
                x=y(1:2*nb);
                data(2:$,:)=[x(1:2:$), x(2:2:$)];
                set("chain", "data", data);
                gca().title.text=msprintf("t=%4.1f",t);
            catch
                term = %t
            end
        end
    end

    exec(fullfile(get_absolute_file_path(),"lagrangian_DAE.sce"),-1)

    nb = 10;   
    mass = ones(1,nb);
    x0 = zeros(2*nb,1);
    x0(1:2:$)=linspace(0,1,nb+1)(2:$);
    u0=zeros(x0);

    realtimeinit(1)
    realtime(0)
    compute(list(npend,9.81),[0:1/30:20],x0,u0,mass,callback=cbFn,rtol=1e-6,atol=1e-6)

endfunction

demo_npend()
clear demo_npend
