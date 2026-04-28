// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- MACOSX ONLY -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15817 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15817
//
// <-- Short Description -->
// ascii(c); with c>=128 crashes on OSX

// ascii(128)=="€" is false under Linux and OSX hence we test only 
// visible chars starting from ascii code 161
assert_checkequal(ascii([161:255]),"¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿ")