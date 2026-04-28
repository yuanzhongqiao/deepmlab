// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Charlotte HECQUET
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function c=cross(a,b)
    // This function returns the cross product of a and b
    arguments
        a {mustBeA(a, ["double", "boolean", "polynomial", "sparse", "int"])}
        b {mustBeA(b, ["double", "boolean", "polynomial", "sparse", "int"]), mustBeEqualDims(b, a)}
    end

    if (size(a,1)<>1 | size(a,2)<>3) & size(a,1)<>3 then
        error(msprintf(_("%s: Wrong size for input argument #%d: A matrix of size 1x3 or 3xN expected.\n"), "cross", 1));
    end

    if size(a,2)==3 & size(a,1)==1 then
        c=a(:,[2 3 1]).*b(:,[3 1 2]) - a(:,[3 1 2]).*b(:,[2 3 1]);
    else
        c=a([2 3 1],:).*b([3 1 2],:) - a([3 1 2],:).*b([2 3 1],:);
    end
endfunction
