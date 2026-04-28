// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

function checkIcons(xmlFile)
    doc = xmlRead(xmlFile);
    buttonWithIconNodes =  xmlXPath(doc, "//*[@icon]");

    iconDirs = ls(SCI + "/modules/gui/images/icons/16x16/")
    for iButton = 1: size(buttonWithIconNodes, "*")
        iconFound = %F;
        for iDir = 1:size(iconDirs, "*")
            if isfile(SCI + "/modules/gui/images/icons/16x16/" + iconDirs(iDir) + "/" + buttonWithIconNodes(iButton).attributes.icon + ".png") then
                iconFound = %T
                break
            end
        end
        assert_checktrue(iconFound);
    end
endfunction

checkIcons(SCI + "/modules/gui/etc/main_toolbar.xml");
checkIcons(SCI + "/modules/gui/etc/graphics_toolbar.xml");
