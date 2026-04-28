// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function fields = %model_fieldnames(model)
    fields = getfield(1,model)(2:$)(:);
    if size(fields, "*") > 4 then // Rule out the Annotations
        if or(fields == "rpar") && typeof(model.rpar) == "diagram" then // Do nothing if model("rpar") is already a mlist
            fields = [
            "sim"      
            "in"       
            "in2"      
            "intyp"    
            "out"      
            "out2"     
            "outtyp"   
            "evtin"    
            "evtout"   
            "state"    
            "dstate"   
            "odstate"  
            "rpar"     
            "ipar"     
            "opar"     
            "blocktype"
            "firing"   
            "dep_ut"   
            "label"    
            "nzcross"  
            "nmode"    
            "equations"
            "uid"       
            ];
        end
    end
endfunction

