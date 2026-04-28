//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) - 2024 - Dassault Systèmes S.E. - Clément David
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
function [x, y, typ] = SSPOutputConnector(job,arg1,arg2)
    x = []; y = []; typ = [];
    select job
    case 'set' then
        x = arg1;
        model = arg1.model;
        graphics = arg1.graphics;

        while %t do
            [ok, varnam, nz, exprs] = scicos_getvalue(..
            msprintf(_("Set %s block parameters"),"SSPOutputConnector"), ..
            _(["Scilab variable name";
               "Size of buffer"]), ...
            list("str", 1, "vec", 1), graphics.exprs);

            if ~ok then
                break,
            end;
            
            graphics.exprs = exprs;
            graphics.in_label = exprs(1); // varname

            objs = list();
            if isdef("flag") && flag == "nw" then
                // use a TOWS_c block if this is not an graphic mode
                objs(1) = TOWS_c("define");
                objs(1).graphics.exprs(2) = exprs(1); // varname
                objs(1).graphics.exprs(1) = exprs(2); // nz
                objs(1).graphics.exprs(3) = "1"; // inherit
            else
                // default to a CSCOPE
                objs(1) = CSCOPE("define");
                objs(1).graphics.exprs(10) = exprs(1); // varname
                objs(1).graphics.exprs(8) = exprs(2); // nz
                objs(1).graphics.exprs(9) = "1"; // inherit
            end
            objs(2) = IN_f("define");
            objs(3) = scicos_link(from=[2 1 0],to=[1 1 1]);
            objs(1).graphics.pin = 3;
            objs(2).graphics.pout = 3;

            model.rpar = do_eval(scicos_diagram(objs=objs),list(),%scicos_context);
            model.in = -1;

            x.model = model;
            x.graphics = graphics;
            return;
        end
    case 'define' then
        exprs = ["A" ; "256"];
        model=scicos_model();
        
        // compiled superblock that will update itself as a block
        model.sim="csuper";
        model.ipar = 1;
        model.in = -1;
        
        // default to a CSCOPE
        objs = list();
        objs(1) = CSCOPE("define");
        objs(1).graphics.exprs(10) = exprs(1); // varname
        objs(1).graphics.exprs(8) = exprs(2); // nz
        objs(1).graphics.exprs(9) = "1"; // inherit
        objs(2) = IN_f("define");

        objs(3) = scicos_link(from=[2 1 0],to=[1 1 1]);
        objs(1).graphics.pin = 3;
        objs(2).graphics.pout = 3;

        model.rpar = scicos_diagram(objs=objs)
        x = standard_define([9 5],model,exprs,[]);
        x.graphics.style = ["SSPOutputConnector"];
    end
endfunction
