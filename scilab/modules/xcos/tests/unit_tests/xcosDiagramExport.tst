// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
// This file is distributed under the same license as the Scilab package.

// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// Internal test to export all demos files as images
//

all_demos = [ ...
"modules/xcos/demos/Bouncing_ball.zcos"
"modules/xcos/demos/CodeGen/controller.zcos"
"modules/xcos/demos/CodeGen/fibo.zcos"
"modules/xcos/demos/Command.zcos"
"modules/xcos/demos/Command_bode.zcos"
"modules/xcos/demos/Cont.Disc-Observer.zcos"
"modules/xcos/demos/Controller.zcos"
"modules/xcos/demos/Discrete-KalmanFilter.zcos"
"modules/xcos/demos/Electrical/AND_Gate.zcos"
"modules/xcos/demos/Electrical/Boost_Converter.zcos"
"modules/xcos/demos/Electrical/Bridge_Rectifier.zcos"
"modules/xcos/demos/Electrical/Colpitts_Oscillator.zcos"
"modules/xcos/demos/Electrical/DC_DC_Buck_Converter.zcos"
"modules/xcos/demos/Electrical/Difference_amplifier.zcos"
"modules/xcos/demos/Electrical/NOR_Gate.zcos"
"modules/xcos/demos/Electrical/Opamp_Amplifier.zcos"
"modules/xcos/demos/Electrical/Switched_capacitor_integrator.zcos"
"modules/xcos/demos/Electrical/Transformer.zcos"
"modules/xcos/demos/Event/event_and.zcos"
"modules/xcos/demos/Event/if_then_else.zcos"
"modules/xcos/demos/Fibonacci.zcos"
"modules/xcos/demos/IF_block.zcos"
"modules/xcos/demos/Ifsub.zcos"
"modules/xcos/demos/Inverted_pendulum.zcos"
"modules/xcos/demos/Kalman.zcos"
"modules/xcos/demos/Kalman_1.zcos"
"modules/xcos/demos/Lorenz.zcos"
"modules/xcos/demos/ModelicaBlocks/Ball_Platform.zcos"
"modules/xcos/demos/ModelicaBlocks/BouncingBall_Modelica.zcos"
"modules/xcos/demos/ModelicaBlocks/Chaos_Modelica.zcos"
"modules/xcos/demos/ModelicaBlocks/Heat_conduction.zcos"
"modules/xcos/demos/ModelicaBlocks/Hydraulics.zcos"
"modules/xcos/demos/ModelicaBlocks/RLC_Modelica.zcos"
"modules/xcos/demos/ModelicaBlocks/Rotational_system.zcos"
"modules/xcos/demos/OldGainTest.zcos"
"modules/xcos/demos/Plant_DiscreteController.zcos"
"modules/xcos/demos/Scilab_Block.zcos"
"modules/xcos/demos/Signal_Builder.zcos"
"modules/xcos/demos/Simple_Demo.zcos"
"modules/xcos/demos/Simple_Thermostat.zcos"
"modules/xcos/demos/System-Observer.zcos"
"modules/xcos/demos/Table_Lookup.zcos"
"modules/xcos/demos/Temperature_Controller.zcos"
"modules/xcos/demos/Thermique_bloc.zcos"
"modules/xcos/demos/Threshold_ZeroCrossing.zcos"
"modules/xcos/demos/batch_simulation.zcos"
"modules/xcos/demos/bounce.zcos"
"modules/xcos/demos/demo_Datatype.zcos"
"modules/xcos/demos/demo_watertank.zcos"
"modules/xcos/demos/goto_demo.zcos"
"modules/xcos/demos/optimal_link.zcos"
"modules/xcos/demos/optimal_split_block.zcos"
"modules/xcos/demos/pendulum_anim5.zcos"
"modules/xcos/demos/susp.zcos" ];

for f = all_demos'
    scs_m = xcosDiagramToScilab(fullfile(SCI,f));
    xcosDiagramExport(scs_m, "TMPDIR/root.png");
    xcosDiagramExport(scs_m, "TMPDIR/all_layers_%s.png");
end
