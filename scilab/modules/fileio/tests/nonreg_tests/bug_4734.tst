// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2009 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 4734 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4734
//
// msscanf make sometime Scilab-5.1.x and Scilab-4.1.2 crash

chdir(TMPDIR);

t = [];
for i=1:1000
    t = [t string(i)];
end
t = t';
warning("off");
save(TMPDIR + filesep() + "pb.dat","t");
clear t;

load(TMPDIR + filesep() + "pb.dat");
ierr = execstr("r = msscanf(-1,t,''%f\n'');","errcatch");
if ierr <> 0 then pause,end
if size(r,"*") <> 1000 then pause,end




