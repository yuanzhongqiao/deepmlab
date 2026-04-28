// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Antoine ELIAS

function %lss_p(lss)

    head = [];//%lss_outline(lss, 1);
    //A
    head = [head; "  A (matrix)" + lss_field(lss.A)];
    //B
    head = [head; "  B (matrix)" + lss_field(lss.B)];
    //C
    head = [head; "  C (matrix)" + lss_field(lss.C)];
    //D
    head = [head; "  D (matrix)" + lss_field(lss.D)];
    //X0
    head = [head; "  X0 (initial state)" + lss_field(lss.X0)];
    //dt
    head = [head; "  dt (time domain)" + lss_field(lss.dt)];

    printf("%s\n", head);
endfunction


function tmp = lss_field(x)
    tmp = sci2exp(x);
    char = " = ";
    if size(tmp, "*") > 1 || length(tmp) > lines() / 2 then
        char = ": ";
        [otype, onames] = typename();
        [tmp, err] = evstr("%"+onames(otype==type(x))+"_outline(x,0)");
    end

    tmp = char + tmp;
end
