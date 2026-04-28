// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Jean-Baptiste Silvy
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
//
// <-- Non-regression test for bug 3339 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3339
//
// <-- Short Description -->
//    When closing metanet demo (metro demo) some java Excpetion occure.

// create figures with uimenus and destroy them
// this used to generate java exceptions
for i = 1:100,
  f=figure('position', [10 10 300 200]);
  // create a figure
  m=uimenu(f,'label', 'windows');
  // create an item on the menu bar
  m1=uimenu(m,'label', 'operations');
  m2=uimenu(m,'label', 'quit scilab', 'callback', "exit");
  //create two items in the menu "windows"
  m11=uimenu(m1,'label', 'new window', 'callback',"show_window()");
  m12=uimenu(m1,'label', 'clear  window', 'callback',"clf()");
  // create a submenu to the item "operations"
  close(f);
end




