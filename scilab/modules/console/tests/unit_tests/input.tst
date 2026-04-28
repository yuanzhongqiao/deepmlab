// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- INTERACTIVE TEST -->
//
// <-- input() unitary tests -->
// ==============================

// LITERAL STRING MODE
// -------------------
a = input("Just press enter : ","string")
// a must be equal to ""
// The regular prompt must follow

b = input("Give the string àăåéêěėíîïõöōůüűýŷÿ with extended characters : ","string")
// Enter an UTF-8 string like àăåéêěėíîïõöōůüűýŷÿ, without quotes, + enter
// => The prompt message must be correctly displayed, including extended characters.
// => b must be equal to the same string correctly encoded.
// => The regular prompt must follow

c = input("Enter a string with % \n \t \r : ","string")
// Enter a string including the \t \n and % sequences, and anything else, + press <enter>
// c must be equal to the same string, with no special processing.
// The regular prompt must follow.


// EVALUATION MODE
// ---------------
f = input("Give a boolean, literal number, integer, real or complex : ")
// and press enter
// f must be equal to the given value
// The regular prompt must follow

g = input("Enter %pi (the variable name) : ")
// and press enter
// g must be equal to the %pi value
// The regular prompt must follow

h = input("Enter a valid Scilab expression : ")
// for instance [1 3; 5 -1], or rand(2,2), and press enter
// h must be equal to the value of the evaluated expression
// The regular prompt must follow

i = input("Enter a invalid Scilab expression : ")
// for instance [1 3; 5], or grand(2,2), and press enter
// =>  a) an error message must be displayed
//     b) you must be reprompted for an input
// Enter now a valid expression, + <enter>
// => you get its result in i, and go back to the regular prompt
