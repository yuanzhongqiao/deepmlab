// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// /!\ This file is used for profile unit tests. /!\
// /!\ Absolute position of function declaration will be tested. /!\

// /!\ First line of function foo will be tested /!\
function coverageTest_foo()
    2
endfunction

// /!\ First line of function foo will be tested /!\
function coverageTest_with_inner()
    2
    function coverageTest_inner()
        4
    endfunction
    6
endfunction

function coverageTest_sleepStructure(x, y, z)
    sleep(200)
    // some comment here
    sleep(500)
    // and here again
    if x then
        sleep(100)
        if y then
            sleep(100)
        else
            sleep(300)
        end
    else
        sleep(300)
    end
    sleep(200)
endfunction
