// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - ESI Group - Clement DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//

// only check API there and ensure there is some instrumentation in progress

// with module path
info = covStart("SCI/modules/xcos");
assert_checktrue(info > 0);
info = covStart(["SCI/modules/xcos" ; "SCI/modules/scicos"]);
assert_checktrue(info > 0);

// with module name
info = covStart("elementary_functions");
assert_checktrue(info > 0);
info = covStart(["elementary_functions"; "core"]);
assert_checktrue(info > 0);

// with library name
info = covStart("elementary_functionslib");
assert_checktrue(info > 0);
info = covStart(["elementary_functionslib"; "corelib"]);
assert_checktrue(info > 0);

// with full path to the macro dir for dynamic modules
info = covStart(["SCI/modules/xcos/macros" ; ..
                 "SCI/modules/scicos/macros/scicos_auto" ; ..
                 "SCI/modules/scicos/macros/scicos_scicos" ; ..
                 "SCI/modules/scicos/macros/scicos_utils" ]);
assert_checktrue(info > 0);

// with full path to the macro dir and lib name for dynamic modules
info = covStart(["SCI/modules/xcos/macros" "xcoslib" ; ..
                 "SCI/modules/scicos/macros/scicos_auto" "scicos_autolib" ; ..
                 "SCI/modules/scicos/macros/scicos_scicos" "scicos_scicoslib" ; ..
                 "SCI/modules/scicos/macros/scicos_utils" "scicos_utilslib"]);
assert_checktrue(info > 0);

// with full path to the macro dir and function name
info = covStart(["SCI/modules/xcos/macros" "xcos"; ..
                 "SCI/modules/scicos/macros/scicos_auto" "lincos"]);
assert_checktrue(info > 0);

// with all loaded scilab libraries 
info = covStart(librarieslist());
assert_checktrue(info > 0);
