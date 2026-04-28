// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function h = hadamard(n)
    arguments
        n {mustBeA(n, "double"), mustBeScalarOrEmpty, mustBePositive}
    end

    select n
    case []
        h = [];
    case 1
        h = 1;
    case 2 
        h = [1 1; 1 -1];
    else
        f = factor(n);
        if and(f == 2) then
            // Sylvester construction
            s = size(f, "*");
            h = hadamard(2) .*. hadamard(2^(s-1));
        else
            // Paley construction
            q = n-1;
            p = primes(q);
            p = p($);

            if (modulo(q, 4) == 3) && (p == q) then
                // Paley construction 1
                // quadratic residues
                quadres = unique(modulo([1:n-2].^2, q));
                X = [1:n-2];
                Q = members(X, quadres);
                Q(Q == 0) = -1;
                Q = [0 Q];
                Q = toeplitz(Q, -Q);
                h = eye(n,n) + [0 ones(1, q); -ones(q, 1) Q]
            elseif (modulo((n/2-1), 4) == 1) then
                // Paley construction 2
                q = n/2 - 1;
                quadres = unique(modulo([1:q-1].^2, q));
                X = [1:q-1];
                Q = members(X, quadres);
                Q(Q == 0) = -1;
                Q = [0 Q];
                Q = toeplitz(Q, Q);
                H = [0 ones(1, q); ones(q, 1) Q];
                h = ones(n,n);
                for i = 1:q+1
                    for j = 1:q+1
                        select H(i,j)
                        case 0
                            r = [1 -1;-1 -1];
                        case 1
                            r = [1 1;1 -1];
                        case -1
                            r = [-1 -1;-1 1];
                        end
                        h(2*(i-1)+1:2*i,2*(j-1)+1:2*j) = r;
                    end
                end
            else
                error(msprintf(_("%s: Wrong value for input argument #%d: Must be %d, %d, or a multiple of %d.\n"), "hadamard", 1, 1, 2, 4));
            end
        end
    end

endfunction


