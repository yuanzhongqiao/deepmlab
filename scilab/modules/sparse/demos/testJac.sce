
function testJac()
    function y=f(x,p)
        x = x(p,:)
        j = size(x,2);
        z = zeros(1,j);
        y = -2*sin(x)+[z;x(1:$-1,:).^2]+[x(2:$,:).^3;z];
        y = [y+y($:-1:1,:)]
        y = [y;y]
    end
    
    N=30;
    rand('seed',7);
    p = samwr(N,1,1:N)
    p = 1:N;
    x0 = rand(N,1,'normal');
    sp = sparse(numderivative(list(f,p),x0));
    
    // get computation engine
    params = struct("FiniteDifferenceType","COMPLEXSTEP","Vectorized","on");
    
    jacobian = spCompJacobian(f,sp,FiniteDifferenceType="COMPLEXSTEP",Vectorized="on");
    
    // compute colored Jacobian
    J = jacobian(x0,p);
    clf;
    gcf().color_map = parula(max(jacobian.colors))

    subplot(1,2,1)
    spyCol(J,jacobian.colors)
    title("Colored Jacobian pattern")
    subplot(1,2,2)
    spyCol(jacobian.seed,0:size(jacobian.seed,2)-1)
    title("Seed matrix")
    
    demo_viewCode("testJac.sce")
    
endfunction

testJac()
clear testJac
