//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function sundials_lorenz()

    function dXdt=lorenz(t,X)
        x=X(1,:);
        y=X(2,:);
        z=X(3,:);
        dXdt=[sigma*(y-x)
              rho*x-y-x.*z
              x.*y-bet*z];
    endfunction
    
    function term=cb(t,X,state,stats)
        if state=="init"
            my_handle = scf(100001);
            clf(my_handle,"reset");
            demo_viewCode("lorenz.dem.sce");

            my_handle.color_map=parula(128)
            drawlater
            scatter3d(X(1,:),X(2,:),X(3,:),1,X(3,:));
            hdl = gce();
            isoview on
            a = gca();
            a.data_bounds=[-30 30 -30 30 0 60]
            a.rotation_angles=[60 130];
            a.box="off";
            b = uicontrol("string","Stop","Callback_Type",10,"tag","stop",...
            "callback","delete(gcbo)");
            b.position(3) = 60;
            drawnow
            realtimeinit(1)
            realtime(0)
        else
            if get("stop") == [] then term=%t; return; end
            
            a=gca();
            a.children.data=X';
            a.title.text=msprintf("t=%5.2f",t)
            realtime(t)
        end
        term=%f
    endfunction
    
    sigma=10;
    rho=28;
    bet=8/3;
    
    X0=rand(3,6000,"normal");
    s2=sqrt(sum(X0.*X0,1));
    X0=X0./s2([1 1 1],:)*30;
    X0(3,:)=X0(3,:)+30;
    
    arkode(lorenz,[0:1/100:20],X0,callback=cb,method="ERK_8");
end

sundials_lorenz()
clear sundials_minimal
