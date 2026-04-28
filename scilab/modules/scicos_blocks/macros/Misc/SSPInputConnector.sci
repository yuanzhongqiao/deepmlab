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
function [x, y, typ] = SSPInputConnector(job,arg1,arg2)
    x = []; y = []; typ = [];
    select job
    case 'set' then
        x = arg1;
        model = arg1.model;
        graphics = arg1.graphics;

        while %t do
            [ok, varnam, exprs] = scicos_getvalue(..
            msprintf(_("Set %s block parameters"),"SSPInputConnector"), ..
            _("Scilab variable name"), ...
            list("str", 1), graphics.exprs);

            if ~ok then
                break,
            end;
        
            graphics.exprs = exprs;
            graphics.out_label = exprs(1); // varname

            // this is always a FROMWS_c block
            objs = list();
            objs(1) = FROMWS_c("define");
            objs(1).graphics.exprs(1) = x.graphics.exprs; // label
            objs(2) = OUT_f("define");
            objs(3) = scicos_link(from=[1 1 0], to=[2 1 1]);
            objs(2).graphics.pin = 3;
            objs(1).graphics.pout = 3;
            objs(4) = scicos_link(ct=[5 -1], from=[1 1 0], to=[1 1 1]);
            objs(1).graphics.pein = 4;
            objs(1).graphics.peout = 4;
            
            model.rpar = do_eval(scicos_diagram(objs=objs),list(),%scicos_context);
            model.out = -1;
            
            x.model = model;
            x.graphics = graphics;
            return;
        end
    case 'define' then
        exprs = ["A"];
        model=scicos_model();
        
        model.sim="csuper";
        model.ipar=1;
        model.out = -1;
        
        // default to a FROMWS_c block
        objs = list();
        objs(1) = FROMWS_c("define");
        objs(1).graphics.exprs(1) = exprs(1); // varname
        objs(2) = OUT_f("define");

        objs(3) = scicos_link(from=[1 1 0],to=[2 1 1]);
        objs(2).graphics.pin = 3;
        objs(1).graphics.pout = 3;
        
        model.rpar = scicos_diagram(objs=objs)

        x = standard_define([9 5],model,exprs,[]);
        x.graphics.style = ["SSPInputConnector"];
    end
endfunction
