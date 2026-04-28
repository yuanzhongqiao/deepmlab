// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2000 - INRIA - Carlos Klimann
// Copyright (C) 2024 - Dassault Systèmes S.E. - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.
  
function [comprinc, score, lambda, tsquare, explainedvar, mu] = pca(x, varargin)

    if nargin == 0 then
        error(msprintf(_("%s: Wrong number of input argument: At least %d expected.\n"), "pca", 1));
    end

    if typeof(x) <> "constant" then
        error(msprintf(_("%s: Wrong type for input argument #%d: A double expected.\n"), "pca", 1));
    end

    if x == [] then
        comprinc = [];
        score = [];
        lambda = [];
        score = [];
        explainedvar = [];
        mu = %nan;
        return;
    end

    eco = %t;
    centered = %t;
    numcomp = size(x, 2);
    weights = ones(1, size(x, 1));
    isweights = %f;
    varweights = [];

    if nargin > 1 then
        for i = nargin-2:-2:1
            if type(varargin(i)) <> 10 || (type(varargin(i)) == 10 && ~isscalar(varargin(i))) then
                break;
            end

            select convstr(varargin(i), "l")
            case "centered"
                centered = varargin(i + 1);

                if typeof(centered) <> "boolean" then
                    error(msprintf(_("%s: Wrong type for ""%s"" argument: A boolean expected.\n"), "pca", "Centered"));
                end

                if size(centered, "*") <> 1 then
                    error(msprintf(_("%s: Wrong size for ""%s"" argument: A scalar expected.\n"), "pca", "Centered"));
                end
            case "economy"
                eco = varargin(i + 1);

                if typeof(eco) <> "boolean" then
                    error(msprintf(_("%s: Wrong type for ""%s"" argument: A boolean expected\n"), "pca", "Economy"));
                end

                if size(eco, "*") <> 1 then
                    error(msprintf(_("%s: Wrong size for ""%s"" argument: A scalar expected.\n"), "pca", "Economy"));
                end

            case "numcomponents"
                numcomp = varargin(i + 1);

                if typeof(numcomp) <> "constant" then
                    error(msprintf(_("%s: Wrong type for ""%s"" argument: A double expected.\n"), "pca", "NumComponents"));
                end

                if size(numcomp, "*") <> 1 then
                    error(msprintf(_("%s: Wrong size for ""%s"" argument: A scalar expected.\n"), "pca", "NumComponents"));
                end

                if numcomp <> int(numcomp) then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: An integer value expected.\n"), "pca", "NumComponents"));
                end

                if numcomp <= 0 || numcomp > size(x, 2) then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: Must be positive and lower than or equal to %d.\n"), "pca", "NumComponents", size(x, 1)));
                end

            case "weights"
                weights = varargin(i + 1);

                if typeof(weights) <> "constant" then
                    error(msprintf(_("%s: Wrong type for ""%s"" argument: A double expected.\n"), "pca", "Weights"));
                end

                if (and(size(weights) <> 1) || length(weights) <> size(x, 1)) then
                    error(msprintf(_("%s: Wrong size for ""%s"" argument: A vector of size %d expected.\n"), "pca", "Weights", size(x, 1)));
                end
                if or(weights <= 0) then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: A positive value expected.\n"), "pca", "Weights"));
                end

                weights = weights(:);
                isweights = %t;

            case "variableweights"
                varweights = varargin(i + 1);
                typ = typeof(varweights);

                if and(typ <> ["constant", "string"]) then
                    error(msprintf(_("%s: Wrong type for ""%s"" argument: A double or string expected.\n"), "pca", "VariableWeights"));
                end
                if typ == "string" && varweights <> "variance" then
                    error(msprintf(_("%s: Wrong value for ""%s"" argument: ""%s"" expected.\n"), "pca", "VariableWeights", "variance"));
                elseif typ == "constant" then
                    if (and(size(varweights) <> 1) || length(varweights) <> size(x, 2)) then
                        error(msprintf(_("%s: Wrong size for ""%s"" argument: A vector expected.\n"), "pca", "VariableWeights"));
                    end
                    if or(varweights <= 0) then
                        error(msprintf(_("%s: Wrong value for ""%s"" argument: A positive value expected.\n"), "pca", "VariableWeights"));
                    end
                end

            else
                error(msprintf(_("%s: unknown option ""%s"".\n"), "pca", varargin(i)));
            end
        end
    end
        
    [rowx, colx] = size(x);

    if centered then
        if isweights then
            mu = meanf(x, weights * ones(1, colx), 1);
        else
            mu = mean(x, 1);
        end
        y = x - ones(rowx, 1) * mu;
        r = rowx - 1;
    else
        y = x;
        mu = zeros(1, colx);
        r = rowx;
    end

    if isweights then
        c = sqrt(weights) * ones(1, colx);
        y = y .* c;
    end

    if varweights <> [] then
        if varweights == "variance" then
            if isweights then
                // weighted standard deviation from variance computation
                // https://stats.stackexchange.com/questions/47325/bias-correction-in-weighted-variance
                mw = meanf(x, w(:) * ones(1,colx), 1);
                s = sum((w(:) * ones(1, colx) .* (abs(x - ones(rowx, 1) * mw)) .^2), 1) ./ sum(w);
                sw = sqrt(s* (sum(w)^2)/(sum(w)^2 - sum(w.^2)));
                varweights = 1./sw;
            else
                varweights = 1./stdev(x, 1);
            end
        else
            varweights = sqrt(varweights);
        end
        y = y .* (ones(rowx, 1) * varweights);
    end

    //compute eigenvectors of  y'*y using svd
    if eco then
        [U, lambda, comprinc] = svd(y, "e");
    else
        [U, lambda, comprinc] = svd(y);
    end

    if isweights then
        U = U ./ c;
        y = y ./ c;
    end

    score = y * comprinc;
    lambda = diag(lambda).^2 / r;

    if varweights <> [] then
        comprinc = comprinc ./ (varweights' * ones(1, colx));
    end
    
    if r < colx then
        if eco then
            comprinc(:,r+1:$)=[];
            lambda(r+1:$)=[]
            score(:,r+1:$) = [];
        else
            lambda(r+1:$)=0
            score(:, r+1:$) = 0;
        end
    end
    q=find(lambda<=max(r,colx)*%eps*lambda(1),1)
    if q==[] then q=size(lambda,"*"),end
    tsquare = r * sum(U(:,1:q).^2,2)

    if nargout > 4 then
        // percentage of variance explained by each principal component
        explainedvar = 100 * lambda / sum(lambda);
    end

    [tmp, k] = max(abs(comprinc), "r");
    changesign = sign(diag(comprinc(k,:))');
    comprinc = changesign.*. ones(colx, 1) .* comprinc;
    score = changesign.*. ones(rowx, 1) .* score;

    if numcomp < rowx then
        comprinc = comprinc(:, 1: numcomp);
        score = score(:, 1:numcomp);
    end

    if nargout < 4 then
        warning(msprintf(_("Potential incompatibility with previous versions: the order of first three output arguments have changed. Please see pca documentation for more information.\n"), "pca"));
    end
endfunction