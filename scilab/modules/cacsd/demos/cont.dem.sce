//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
// This file is distributed under the same license as the Scilab package.
//

function demo_cont()

  deff('[]=demoexc(fil)','exec(''SCI/modules/cacsd/demos/''+fil)')
  while %t do
    n=x_choose(['LQG','Mixed-sensitivity','PID'],'Select a demo');
    select n
    case 0
      break
    case 1
      demoexc('lqg/lqg.dem.sce')
    case 2
      demoexc('mixed.dem.sce')
    case 3
      demoexc('pid.dem.sce')
    end
  end
  
endfunction

demo_cont();
clear demo_cont;
