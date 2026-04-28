// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - INRIA - Serge Steer
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- Non-regression test for bug 4359 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4359
//
// <-- Short Description -->
// M(:,:)='anything' produces erroneous result.

M="x";
M(:,:)="anything";
if M<>"anything" then pause,end
M="x";
M(:)="anything";
if M<>"anything" then pause,end

M=["xqsdq","qzdqsdq"];
M(:,:)=["anything" "blabla"];
if or(M<>["anything" "blabla"]) then pause,end

M=["xqsdq","qzdqsdq"];
M(:)=["anything" "blabla"];
if or(M<>["anything" "blabla"]) then pause,end
