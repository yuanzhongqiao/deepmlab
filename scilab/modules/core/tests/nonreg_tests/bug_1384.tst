// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2005-2008 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 1384 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/1384
//
// <-- Short Description -->
// Missing test and error for resume called with indexed output arguments
clear foo;deff('foo()','a(2)=resume(1)');
if execstr('foo()','errcatch')<>79 then pause,end

clear foo;deff('foo()','a=resume(1)');
if execstr('foo()','errcatch')<>0 then pause,end


clear foo;deff('foo()','[a(3),b]=resume(1,2)');
if execstr('foo()','errcatch')  <>79 then pause,end

clear foo;deff('foo()','[a,b]=resume(1,2)');
if execstr('foo()','errcatch')<>0 then pause,end


clear foo;deff('foo()','a(2)=resume(1)');
if execstr('foo()','errcatch')<>79 then pause,end

clear foo;deff('foo()','a=resume(1)');
if execstr('foo()','errcatch')<>0 then pause,end

clear foo;deff('foo()','[a(3),b]=resume(1,2)');
if execstr('foo()','errcatch')<>79 then pause,end


clear foo;deff('foo()','[a,b]=resume(1,2)');
if execstr('foo()','errcatch')<>0 then pause,end


