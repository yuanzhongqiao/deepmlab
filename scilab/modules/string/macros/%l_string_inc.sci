// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024-2025 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function t = %l_string_inc(x, level)
    // Internal function called by %st_p, %l_p, %object_p and %l_string_inc itself
    // Can be called with s = struct | Tlist | list | Object

    maxlevel = evstr(xmlGetValues("//general/body/environment","container_disp_max_depth"));
    if ~exists("level","local") then
        level = maxlevel;
    end

    fmt = "%s";

    if isa(x, "object")
        fields = properties(x)';
    elseif type(x) == 15 || (isstruct(x) == %f && (fieldnames(x) == [] && length(x)>0))
        fields = 1:length(x);
    else
        fields = fieldnames(x)(:)';
    end
    if type(fields) == 1
        fmt = "(%d)";
    end

    if isstruct(x) && ~isscalar(x)
        t = fields(:);
    else
        t = [];
        for i = fields
            if type(x) == 9 && i == " "
                t = [t;""];
            else
                prehead = sprintf(fmt,i);
                [head,str]=%l_field_format(x,i,level,maxlevel);
                t = [t;prehead+head;str];
            end
        end
    end
endfunction

function [head,str]=%l_field_format(x,i,level,maxlevel)
    str = [];
    head = emptystr();
    char = ": ";
    verb =  0+(level>0);
    try
        value = x(i);
    catch
        try
            value = getfield(i,x);
        catch
        end
        // clear error
        lasterror()
    end
    if ~exists("value","local")
        head = "void";
    elseif type(value) == 15
        head = %l_outline(value, verb);
        if level > 0  & size(value)>0
            str = blanks(4) + %l_string_inc(value, level-1);
        end
    elseif isstruct(value)
        head = %st_outline(value, verb);
        if level > 0 & size(value,"*")>0
            str = blanks(4) + %l_string_inc(value, level-1);
        end
    elseif or(type(value) == [16,17]) & ~isdef("%"+typeof(value)+"_outline")
        head = %tlist_outline(value, verb);
        if level > 0 & fieldnames(value) <> []
            str = blanks(4) + %l_string_inc(value, level-1);
        end
    elseif or(type(value) == [1,2,4,5,6,8,10]) || iscell(value)
        // almost-native arrayOf types
        L = lines()(1)/2;
        if (value == []) || (size(value, "*") < L)
            head = sci2exp(value);
            if size(head, "*") > 1 || length(head) > L then
                head = emptystr();
            else
                char = " = ";
            end
        end
    elseif or(type(value) == [13 130])
        head = "function";
    elseif type(value) == 21
        head = typeof(value)+" object";
    end
    if isempty(head)
        [head,err] = evstr("%"+typeof(value)+"_outline(value,0)")
        if err <> 0
            [otype, onames] = typename();
            [head,err] = evstr("%"+onames(otype==type(value))+"_outline(value,0)");
            if err <> 0
                head = typeof(value);
            end
        end
    end
    head = char + head;
endfunction
