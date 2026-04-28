// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function c=%sp_f_sp(a,b) 

    if size(a, "*") == 0 then
        c = b;
    elseif size(b, "*") == 0 then
        c = a;
    else
        [ija va dimsa] = spget(a);
        [ijb vb dimsb] = spget(b);

        if ijb(:,1) <> [] then
            ijb(:, 1) = ijb(:, 1) + dimsa(1);
        end

        c = sparse([ija;ijb], [va;vb], [dimsa(1) + dimsb(1) dimsa(2)]);
    end
end
