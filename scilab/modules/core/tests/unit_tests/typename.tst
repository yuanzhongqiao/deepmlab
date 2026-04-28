// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
//typename

[typs,nams]=typename();
if or(typs<>[1;2;4;5;6;8;9;10;13;14;15;16;17;128;129;130]) then pause,end
if or(nams<>["s";"p";"b";"sp";"spb";"i";"h";"c";"function";"f";"l";"tl";"ml";"ptr";"ip";"fptr"])  then pause,end
