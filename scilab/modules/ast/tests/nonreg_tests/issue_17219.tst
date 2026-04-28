// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17219 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17219
//
// <-- Short Description -->
// Cell creation with comments inside

/*** scalar cell ***/
expected = makecell([1, 1], "test");

computed = {
   "test"
};
assert_checkequal(computed, expected);

computed = {
//comment first line
   "test"
   //comment at last line
};
assert_checkequal(computed, expected);

computed = {
   "test"
   //comment at last line
};
assert_checkequal(computed, expected);

computed = {
//comment first line
   "test"
};
assert_checkequal(computed, expected);

computed = {
   /*multi
   comment 
   line*/
   "test"
};
assert_checkequal(computed, expected);

/*** column vector cell ***/
expected = makecell([2, 1], "test", 42);

computed = {
   "test"
   42
};
assert_checkequal(computed, expected);

computed = {
   "test" //comment at first element
   42 
};
assert_checkequal(computed, expected);

computed = {
   "test"
   42 //comment at last element
};
assert_checkequal(computed, expected);

computed = {
   "test"
   /*line begin*/42
};
assert_checkequal(computed, expected);

computed = {
   "test"
   /*multi
   comment 
   line*/42
};
assert_checkequal(computed, expected);

/*** row vector cell ***/
expected = makecell([1, 2], "test", 42);

computed = {
   "test", /*multi
   comment 
   line*/ 42
};
assert_checkequal(computed, expected);

computed = {
   "test", /*comment*/ 42
};
assert_checkequal(computed, expected);

/*** matrix cell ***/
expected = makecell([2, 2], "test", 42, "line", 2);

computed = {
   "test", /*comment*/ 42
   "line", 2
};
assert_checkequal(computed, expected);

computed = {
   "test", /*comment*/ 42
   "line", 2 // second line
};
assert_checkequal(computed, expected);