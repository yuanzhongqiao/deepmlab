//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is released under the 3-clause BSD license. See COPYING-BSD.

function handler(win, x, y, ibut)
    f = scf(win);
    u = f.user_data;
    [x,y]=xchange(x,y,'i2f');
    if ibut==0
        hn=u.hdl(1);
        hp=u.hdl(3);
        // catch pendulum pivot
        if norm(hp.data(1,:)-[x y])<0.1
            u.c=-1;
            u.hdl(5).data=hp.data(1,:);
            u.hdl(5).visible=%t;
        else
            // catch spline nodes
            for i=2:size(hn.data,1)-1;
                if norm(hn.data(i,:)-[x y])<0.1
                    u.c=i;
                    u.hdl(4).data=hn.data(i,:);
                    u.hdl(4).visible=%t;
                    break
                end
            end
        end
        // catch pendulum tip
        if norm(hp.data(2,:)-[x y])<0.1
            u.hdl(5).data=hp.data(2,:);
            u.hdl(5).visible=%t;
            u.c=-2;
        end
    elseif ibut==-5
        // mouse button release
        if u.c ~=0
            u.hdl(4).visible=%f;
            u.hdl(5).visible=%f
        end
        u.c=0;
    elseif ibut==-1
        // mouse move
        hn=u.hdl(1);
        hs=u.hdl(2);
        hp=u.hdl(3);      
        i = u.c;
        if i>0
            // spline node moving
            hc = u.hdl(4);
            xn = hn.data(:,1)';
            yn = hn.data(:,2)';
            if abs(y-yn(i)) > 0.05 && y > -2 && y < 2
                hn.data(i,2)=y;
                hc.data(1,2)=y;
                yn = hn.data(:,2)';
                //u.yn(i)=y;
                u.sp=splin(xn,yn);
                hs.data(:,2)=interp(hs.data(:,1), xn, yn, u.sp)';
                // update pendulum
                x=hp.data(1,1);
                y=hp.data(1,2);
                yp=interp(x,xn,yn,u.sp);
                hp.data(:,2)=hp.data(:,2)+yp-y;
            end
        elseif i==-1
            // pendulum pivot moving
            xn = hn.data(:,1)';
            yn = hn.data(:,2)';
            if  abs(x-hp.data(1,1)) > 0.05 && x > -2 && x < 2
                yp=interp(x,xn,yn,u.sp);
                hp.data(:,1)=hp.data(:,1)+x-hp.data(1,1);
                hp.data(:,2)=hp.data(:,2)+yp-hp.data(1,2);
                u.hdl(5).data=hp.data(1,:);
            end
        elseif i==-2
            // pendulum tip moving
            if  norm([x,y]-hp.data(2,:)) > 0.05
                v = [x,y]-hp.data(1,:);
                // preserve distance
                hp.data(2,:)=hp.data(1,:)+v/norm(v);
                u.hdl(5).data=hp.data(2,:);
            end
        end
    end
    f.user_data=u;
endfunction
    
function initialize()
    f = scf(100001);
    clf(f,"reset");
    demo_viewCode("demo_spline_pendulum.sce");

    xn=linspace(-2,2,7);
    yn=ones(xn)
    xx=linspace(-3,3,1000);
    sp=splin(xn,yn);
    hpt=plot(0,0,"ro","marksize",12,"thickness",2);
    hpt.visible=%f;
    hp=plot([0 0.5],[1 0],"r-o");
    hc=plot(0,0,"s","marksize",12,"thickness",2);
    hn=plot(xn,yn,"s");
    hc.visible=%f;
    hs=plot(xx,interp(xx, xn, yn, sp));
    f.info_message="Drag and drop curve and pendulum points then click Start button"
    f.event_handler="handler"
    f.event_handler_enable="on"
    f.user_data.c=0;
    f.user_data.sp=sp;
    f.user_data.hdl=[hn,hs,hp,hc,hpt];
    gca().data_bounds=[-2 2 -2 2]
    isoview on
    b=uicontrol("string","Start","tag","button","callback","start()");
    b.position(3)=60;
end

function start()
    // complex step aware Hermite interpolation
    function [y,yd]=myinterp(x,xs,ys,ds)
        [?,i]=gsort([real(x) xs],"g","i");
        n=length(xs);
        i=min(n-1,max(1,find(i==1)-1));
        h=xs(i+1)-xs(i)
        ab=[ys(i);h*ds(i)];
        cd=[1 1;2 3]\[ys(i+1)-ys(i)-h*ds(i);h*(ds(i+1)-ds(i))];
        s=(x-xs(i))/h;
        y=ab(1)+(ab(2)+(cd(1)+cd(2)*s)*s)*s;
        yd=(ab(2)+(2*cd(1)+3*cd(2)*s)*s)/h;
    end
    // define the potentials and the constraints:
    function [Vd,Dd,Fd]=spline_pend(t,x,u,mass,g,xs,ys,sp)
        //derivative of the Rayleigh function (Viscous forces)
        Dd = 0.1*[u(1) u(2) 0 0]
        //derivative of the potential
        Vd = [0 mass(1)*g 0 mass(2)*g];
        x1=x(1:2); x2=x(3:4);
        //derivative of the constraints functions 
        // 1:  (x^2+y^2+a*x)-a^2*(x^2+y^2) = 0
        [y,yd]=myinterp(x1(1),xs,ys,sp);
        F1d=[-yd,1,0,0];
        // 2: norm(x1-x2) = l
        F2d = 2*[x1-x2; x2-x1].'
        Fd = [F1d; F2d];
    end    
    //display callback
    function term=cbFn(t,y,yp,flag,stats,h)
        term=%f;
        try
            realtime(t)
            if get("button", "string") <> "Stop" then term=%t; return; end
            if is_handle_valid(h) 
                h.data=[y(1:2) y(3:4)]';    
                gca().title.text=msprintf("t=%4.1f",t);
                term=gcf().user_data.term;
            else
                term=%t;
            end
        catch
            term=%t
        end
    end
 
    //load Lagrangian DAE macros
    exec(fullfile(get_absolute_file_path(),"lagrangian_DAE.sce"),-1)

    f = scf(100001);
    f.event_handler=""
    f.event_handler_enable="off"
    f.user_data.term=%f;
    f.info_message=""
    u=f.user_data;
    hn=u.hdl(1);
    xs=hn.data(:,1)';
    ys=hn.data(:,2)';
    hp=u.hdl(3);
    x0=[hp.data(1,:) hp.data(2,:)]';
    u0=zeros(x0);
    mass=[1 1];
    
    realtimeinit(1)
    realtime(0)

    b=get("button")
    b.callback="gcf().user_data.term=%t;b=gcbo();b.string=""Start""";
    b.callback_type=10;
    b.string="Stop";

    compute(list(spline_pend,9.81,xs,ys,u.sp),[0:1/100:20],x0,u0,mass,callback=list(cbFn,hp))

    if get("button") == [] then return; end
    b.callback="start()";
    b.string="Start";
    b.callback_type=0;
    f.event_handler="handler"
    f.event_handler_enable="on"
    f.info_message="Drag and drop curve and pendulum points then click Start button"
end

initialize()
