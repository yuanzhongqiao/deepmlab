//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_chain()

    //collapsing chain
    function [Vd,Dd,Fd]=chain(t,x,u,mass,g)
        nb = length(mass);
        n = length(x);
        //derivative of the potential
        Vd = zeros(1,n);
        Vd(2:2:$)=g*mass;
        //derivative of the Rayleigh function (Viscous forces)
        Dd = 2*u.';
        //derivative of the constraints functions
        Fd = zeros(nb+1,n);
        Fd(1,1:2) = (x(1:2)-xl).';
        for i=1:nb-1
            xi=x(2*i-1:2*i);
            xip1=x(2*i+1:2*i+2);
            Fd(i+1,2*i-1:2*i+2)=[-(xi-xip1);(xi-xip1)].'; 
        end
        Fd(nb+1,$-1:$) = (x($-1:$)-xr).';        
    endfunction 

    //display callback
    function term=cbFn(t,y,yp,flag,stats,xl,xr)
        term=%f;
        if flag=="init"
            clf
            demo_viewCode("demo_chain.sce")
            x0=y(1:2*nb);
            h=plot([xl(1);x0(1:2:$);xr(1)],[xl(2);x0(2:2:$);xr(2)],"-o","thickness",2);
            h.tag="chain";
            isoview on
            gca().data_bounds=[-1 1 -1 1]
            title(msprintf("t=%4.1f",t))
        else
            try
                realtime(t)
                data = get("chain", "data");
                if data == [] then term=%t; return; end 
                nb=size(data,1)-2;
                x=y(1:2*nb);
                data(2:$-1,:)=[x(1:2:$), x(2:2:$)];
                set("chain", "data", data);
                gca().title.text=msprintf("t=%4.1f",t);
            catch
                term=%t
            end
        end
    end

    exec(fullfile(get_absolute_file_path(),"lagrangian_DAE.sce"),-1)

    nb = 16;   
    mass = ones(1,nb);
    x0 = zeros(2*nb,1);
    t=linspace(-1,1,nb+2)';
    y=sin(%pi*t)/3;
    xl=[t(1);y(1)];
    xr=[t($);y($)];
    x0(1:2:$)=t(2:$-1);
    x0(2:2:$)=y(2:$-1);
    u0=zeros(x0);

    realtimeinit(1)
    realtime(0)
    compute(list(chain,9.81),[0:1/50:5],x0,u0,mass,rtol=1e-2,atol=1e-4,callback=list(cbFn,xl,xr))

endfunction

demo_chain()
clear demo_chain
