//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_cardioid_pendulum()

    //double pendulum: define the potentials and the constraints:
    function [Vd,Dd,Fd]=cardiod_pend(t,x,u,mass,g,a)
        //derivative of the Rayleigh function (Viscous forces)
        Dd = 0.2*[u(1) u(2) 0 0]
        //derivative of the potential
        Vd = [0 mass(1)*g 0 mass(2)*g];
        x1=x(1:2); x2=x(3:4);
        //derivative of the constraints functions 
        // 1:  (x^2+y^2+a*x)-a^2*(x^2+y^2) = 0
        F1d=2*[(2*x1(1)+a)*(x1.'*x1+a*x1(1))-a^2*x1(1)
                2*x1(2)*(x1.'*x1+a*x1(1))-a^2*x1(2)
                0
                0].';
        // 2: norm(x1-x2) = l
        F2d = 2*[x1-x2; x2-x1].'
        Fd = [F1d; F2d];
    end
    
    //display callback
    function term=cbFn(t,y,yp,flag,stats,h)
        term=%f;
        realtime(t)
        if get("stop") == [] then term=%t; return; end
        try
            if get("stop") == [] then
                term=%t;
                return
            end
            if is_handle_valid(h) 
                h.data=[y(1:2) y(3:4)]';    
                gca().title.text=msprintf("t=%4.1f",t);
            else
                term=%t;
            end
        catch
            term=%t
        end
    end
 
    //load Lagrangian DAE macros
    exec(fullfile(get_absolute_file_path(),"lagrangian_DAE.sce"),-1)

    my_handle = scf(100001);
    clf(my_handle,"reset");
    demo_viewCode("demo_cardioid_pendulum.sce");

    N=200;
    th=linspace(0,2*%pi,N);
    a=1/2;
    r=a*(1-cos(th));
    x=r.*cos(th);
    y=r.*sin(th);
    plot(r.*cos(th),r.*sin(th),'r')

    mass=[1 1];
    i=N/2;
    x0=[x(i) y(i) x(i) y(i)+1]';
    u0=[0 0 0 0]';
    gca().data_bounds=[-2 1 -2 1]
    isoview on
    h=plot(x0([1,3]), x0([2,4]),'-o')
    title("")
    b = uicontrol("string","Stop","Callback_Type",10,"tag","stop",...
            "callback","delete(gcbo)");
    b.position(3) = 60;
    realtimeinit(1)
    realtime(0)

    compute(list(cardiod_pend,9.81,a),[0:1/50:60],x0,u0,mass,rtol=1e-6,atol=1e-8,callback=list(cbFn,h))
    delete(b)
end

demo_cardioid_pendulum()
clear demo_cardioid_pendulum
