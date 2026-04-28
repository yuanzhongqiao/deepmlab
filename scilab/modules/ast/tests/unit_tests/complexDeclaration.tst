// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- NO CHECK REF -->
// <-- CLI SHELL MODE -->
assert_checkequal(0i, complex(0, 0));
assert_checkequal(0j, complex(0, 0));


assert_checkequal(2i, complex(0, 2));
assert_checkequal(2j, complex(0, 2));

assert_checkequal(3 + 2i, complex(3, 2));
assert_checkequal(3 + 2j, complex(3, 2));

assert_checkequal(-.456i, complex(0, -0.456));
assert_checkequal(- .456i, complex(0, -0.456));
assert_checkequal(1 -.456i, complex(1, -0.456));
assert_checkequal(1 - .456i, complex(1, -0.456));

assert_checkequal(-3.456i, complex(0, -3.456));
assert_checkequal(- 3.456i, complex(0, -3.456));
assert_checkequal(1 -3.456i, complex(1, -3.456));
assert_checkequal(1 - 3.456i, complex(1, -3.456));

assert_checkequal(-.456e7i, complex(0, -0.456e7));
assert_checkequal(- .456e7i, complex(0, -0.456e7));
assert_checkequal(1 -.456e7i, complex(1, -0.456e7));
assert_checkequal(1 - .456e7i, complex(1, -0.456e7));

assert_checkequal(-3.456e7i, complex(0, -3.456e7));
assert_checkequal(- 3.456e7i, complex(0, -3.456e7));
assert_checkequal(1 -3.456e7i, complex(1, -3.456e7));
assert_checkequal(1 - 3.456e7i, complex(1, -3.456e7));
