// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15528 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15528
//
// <-- Short Description -->
// savewave  write null signal if 24 bits resolution and more than 2 channels

s=[sin([1:0.1:100]);sin([1:0.1:100]);sin([1:0.1:100])];
wavfile=fullfile(TMPDIR,"bug_15528.wav")
wavwrite(s,22500,24,wavfile);
b=wavread(wavfile);
assert_checkalmostequal(b,s,1e-4,[],'element');
mdelete(wavfile);
