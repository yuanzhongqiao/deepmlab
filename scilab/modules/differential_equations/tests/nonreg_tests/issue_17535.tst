// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2026 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 17535 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17535
//
// <-- Short Description -->
// cvode may not always honor maxSteps

function dzdt=f(t,z)
    dzdt = horner(p2-p1,z)./horner(t*d1+(1-t)*d2,z);
end
n = 4;
p1 = poly((1:n)+0.5,"z");
p2 = %z^n-1;
d1 = derivat(p1);
d2 = derivat(p2);
z0 = exp(2*%pi*%i*(0:n-1)/n);

// Actual error message includes precise time where mxstep is reached, since
// this value can slightly differ vs. platform, we use the below code to compare
// only the second part of error message.

MESSAGE = "mxstep steps taken before reaching tout.";

try
  [t,y,info] = cvode(f,[0 1],z0);
  error("Should not be reached, anytime !")
catch
  assert_checkequal(strsplit(lasterror(),", ")(2), MESSAGE);
end
  
try
  [t,y,info] = arkode(f,[0 1],z0);
  error("Should not be reached, anytime !")
catch
  assert_checkequal(strsplit(lasterror(),", ")(2), MESSAGE);
end

try
  [t,y,info] = ida(#(t,y,yp)->(yp-f(t,y)),[0 1],z0,zeros(z0));
  error("Should not be reached, anytime !")
catch
  assert_checkequal(strsplit(lasterror(),", ")(2), MESSAGE);
end