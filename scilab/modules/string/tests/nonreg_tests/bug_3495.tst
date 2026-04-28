// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008-2008 - DIGITEO - Simon LIPP <simon.lipp@scilab.org>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 3495 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/3495
//
// Short description:
// Crash with PCRE when matching the whole string

regexp('hello, world', '/hello, world/');
regexp('hello, world', '/.+/');
