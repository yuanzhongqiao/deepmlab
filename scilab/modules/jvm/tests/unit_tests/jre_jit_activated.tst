// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- NO CHECK REF -->

// Get JRE version info with default options
[_, defaultVersionInfo] = host(fullfile(jre_path(), "bin", "java") + " --version");

// Get JRE version info with JIT disabled
[_, nojitVersionInfo] = host(fullfile(jre_path(), "bin", "java") + " -Djava.compiler=NONE --version");

// Compare version information, should not match:
// - Adoptium JRE displays 'mixed mode' (JIT enabled) vs 'interpreted mode' (JIT disabled)
// - Semeru JRE displays 'JIT enabled' (JIT enabled) vs 'JIT disabled' (JIT disabled)
// - ...

assert_checkfalse(and(defaultVersionInfo == nojitVersionInfo));
