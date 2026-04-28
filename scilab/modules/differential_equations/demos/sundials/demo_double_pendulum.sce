//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function demo_double_pendulum()

    //double pendulum: define the potential and the constraints:
    function [Vd,Dd,Fd]=double_pend(t,x,u,mass,g)
        //derivative of the Rayleigh function (Viscous forces)
        Dd = 0.1*[u(1) u(2) 0 0]
        //derivative of the potential
        Vd = [0 mass(1)*g 0 mass(2)*g];
        //derivative of the constraints functions 
        // 1 - norm(x1)=l,
        // 2 - norm(x1-x2)=l
        x1=x(1:2); x2=x(3:4);
        Fd = 2*[x1.',0, 0
                 (x1-x2).', (x2-x1).'];
    end
    
    //display callback
    function term=cbFn(t,y,yp,flag,stats,h)
        term=%f;
        realtime(t)
        try
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
 
    exec(fullfile(get_absolute_file_path(),"lagrangian_DAE.sce"),-1)

    mass=[1 1];
    x0=[1 0 1 -1]';
    u0=[0 0 0 0]';

    clf
    demo_viewCode("demo_double_pendulum.sce")
    th=linspace(0,2*%pi,200);
    plot(cos(th),sin(th),'r')
    gca().data_bounds=[-2 2 -2 2]
    isoview on
    h=plot(x0([1,3]), x0([2,4]),'-o')
    title("")
    realtimeinit(1)
    realtime(0)
    
    compute(list(double_pend,9.81),[0 15],x0,u0,mass,callback=list(cbFn,h))
end

demo_double_pendulum()
clear demo_double_pendulum
