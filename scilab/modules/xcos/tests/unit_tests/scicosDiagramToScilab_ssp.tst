// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.

// <-- XCOS TEST -->
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Short Description -->
// Test the SSP file format supported by Xcos
//

// load, extract ssd file and indent it
function load_and_indent(ssp_file, ssd_file, do_indent)
    arguments
        ssp_file string
        ssd_file string
        do_indent boolean = %t
    end    

    if isfile("TMPDIR/SystemStructure.ssd") then deletefile("TMPDIR/SystemStructure.ssd"); end
    decompress(ssp_file, TMPDIR);
    l = mgetl("TMPDIR/SystemStructure.ssd");

    // reindent
    if do_indent then
        l_withoutindent = stripblanks(l, %f, -1);
        indent = length(l) - length(l_withoutindent) + 1;
        tab = [""];
        base_indent = "";
        for i=1:max(indent)
            base_indent = base_indent + "    ";
            tab = [tab ; base_indent];
        end
        l_indent = tab(indent);

        mputl(l_indent + l_withoutindent, ssd_file);
    else
        mputl(l, ssd_file);
    end
endfunction

// can be used to further debug the test
//scicos_log("DEBUG");

// reference file
load_and_indent("SCI/modules/xcos/tests/unit_tests/DC Motor.ssp", "SystemStructure.ssd", %f);


// load and save
if isfile("TMPDIR/sample.ssp") then deletefile("TMPDIR/sample.ssp"); end
scs_m1 = scicosDiagramToScilab("SCI/modules/xcos/tests/unit_tests/DC Motor.ssp");
scicosDiagramToScilab("TMPDIR/sample.ssp", scs_m1);
scicosDiagramToScilab("TMPDIR/sample.dot", scs_m1);

load_and_indent("TMPDIR/sample.ssp", "SystemStructure_1.ssd");


// twice the same file
scs_m2 = scicosDiagramToScilab("TMPDIR/sample.ssp");
if isfile("TMPDIR/sample2.ssp") then deletefile("TMPDIR/sample2.ssp"); end
scicosDiagramToScilab("TMPDIR/sample2.ssp", scs_m2);
scicosDiagramToScilab("TMPDIR/sample2.dot", scs_m2);

load_and_indent("TMPDIR/sample2.ssp", "SystemStructure_2.ssd");

// with an Xcos block
scs_m3 = scs_m2;
scs_m3.objs(1) = scs_m2.objs(1);

loadXcosLibs();
scs_m3 = scs_m2;
scs_m3.objs($+1) = BIGSOM_f("define");

if isfile("TMPDIR/sample3.ssp") then deletefile("TMPDIR/sample3.ssp"); end
scicosDiagramToScilab("TMPDIR/sample3.ssp", scs_m3);
load_and_indent("TMPDIR/sample3.ssp", "SystemStructure_3.ssd");

// ensure that we can load the block back
scicosDiagramToScilab("TMPDIR/sample3.ssp");
scicosDiagramToScilab("TMPDIR/sample3.dot", scs_m3);

// with an Xcos superblock
scs_m4 = scs_m3;
scs_m4.objs($+1) = CLOCK_c("define");

if isfile("TMPDIR/sample4.ssp") then deletefile("TMPDIR/sample4.ssp"); end
scicosDiagramToScilab("TMPDIR/sample4.ssp", scs_m4);
scicosDiagramToScilab("TMPDIR/sample4.dot", scs_m4);
load_and_indent("TMPDIR/sample4.ssp", "SystemStructure_4.ssd");

// ensure that we can load the block back
scicosDiagramToScilab("TMPDIR/sample4.ssp");
