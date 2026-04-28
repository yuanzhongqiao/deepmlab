// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->

// colormap function

// error cases
assert_checkerror("colormap(list())", msprintf(gettext("%s: Wrong type for input argument #%d: a string, a function, or a Nx3 matrix expected.\n"), "colormap", 1));
assert_checkerror("colormap(uicontrol())", msprintf(gettext("%s: Wrong type for input argument #%d: a ''Figure'' or an ''Axes'' handle expected.\n"), "colormap", 1));
assert_checkerror("colormap([""a"", ""b""])", msprintf(gettext("%s: Wrong size for input argument #%d: a string expected.\n"), "colormap", 1));
assert_checkerror("colormap(12)", msprintf(gettext("%s: Wrong size for input argument #%d: a Nx3 matrix expected.\n"), "colormap", 1));
assert_checkerror("colormap([gcf(),gcf()])", msprintf(gettext("%s: Wrong size for input argument #%d: a ''Figure'' or an ''Axes'' handle expected.\n"), "colormap", 1));
assert_checkerror("colormap(1, 1, 1)", msprintf(gettext("%s: Wrong number of input argument(s): %d to %d expected.\n"), "colormap", 0, 2));

// test with a function returning a matrix of wrong size
assert_checkerror("colormap(rand)", msprintf(gettext("%s: Wrong number of columns for generated colormap: 3 expected but got %d.\n"), "colormap", 1));
assert_checkerror("colormap(""rand"")", msprintf(gettext("%s: Wrong number of columns for generated colormap: 3 expected but got %d.\n"), "colormap", 1));
// test with a non-existing function
try
    _rand_
catch
    msg = lasterror();
end
assert_checkerror("colormap(""_rand_"")", msprintf(gettext("%s: Error while generating colormap:\n%s"), "colormap", msg));

assert_checkerror("colormap(gcf(), list())", msprintf(gettext("%s: Wrong type for input argument #%d: a string, a function, or a Nx3 matrix expected.\n"), "colormap", 2));
assert_checkerror("colormap(gcf(), [""a"", ""b""])", msprintf(gettext("%s: Wrong size for input argument #%d: a string expected.\n"), "colormap", 2));
assert_checkerror("colormap(gcf(), 12)", msprintf(gettext("%s: Wrong size for input argument #%d: a Nx3 matrix expected.\n"), "colormap", 2));

// working cases
assert_checkequal(colormap(), gcf().color_map);
assert_checkequal(colormap(gcf()), gcf().color_map);
assert_checkequal(gda().color_map, []); // Check that default axes colormap is []
assert_checkequal(colormap(gca()), []); // No colormap on current axes

//assert_checkequal(colormap(jet), jet());

assert_checkequal(colormap(jet(32)), jet(32)); // Set new colormap to current figure
assert_checkequal(gcf().color_map, jet(32)); // Check that current figure colormap is OK

h=scf(42);
assert_checkequal(colormap(h, jet(32)), jet(32)); // Set new colormap to figure #42
assert_checkequal(h.color_map, jet(32)); // Check that figure #42 colormap is OK
;
assert_checkequal(colormap(gca(), parula(32)), parula(32)); // Set new colormap to current axes
assert_checkequal(gca().color_map, parula(32)); // Check that current axes colormap is OK

assert_checkequal(colormap("default"), gdf().color_map); // Set default colormap to current figure
assert_checkequal(gcf().color_map, gdf().color_map); // Check that current figure colormap is "default"


// predefined colormaps
cmapFunctionsMisc = ["autumn", "bone", "cool", "copper", "gray", "hot", "hsv", "jet", ...
                 "ocean", "parula", "pink", "rainbow", "spring", "summer", "white", "winter"];

cmapFunctionsColorbrewer = [
    "blues", "BrBG", "BuGn", "BuPu", ...
    "coolwarm", ...
    "GnBu", "greens", "greys", ...
    "oranges", "OrRd", ...
    "PiYG", "PRGn", "PuBu", "PuBuGn", "PuOr", "PuRd", "purples", ...
    "RdBu", "RdGy", "RdPu", "RdYlBu", "RdYlGn", "reds", ...
    "spectral", ...
    "YlGn", "YlGnBu", "YlOrBr", "YlOrRd"];

cmapFunctionsNewOnes = "turbo";

cmapFunctionsQualitatives = ["flag", "prism", "Accent", "Dark2", "Paired", "Pastel1", "Pastel2", "Set1", "Set2", "Set3"];


cmapFunctions = [cmapFunctionsNewOnes, cmapFunctionsColorbrewer, cmapFunctionsMisc, cmapFunctionsQualitatives];

for cmapFun = cmapFunctions

    // Call function directly
    execstr("cmap1 = " + cmapFun + "(42);");
    assert_checkequal(size(cmap1), [42, 3]);

    // Back to "default"
    execstr("cmap2 = colormap(""default"");");
    assert_checkequal(size(cmap2), [32, 3]);

    // Use colormap function with a string
    execstr("cmap2 = colormap(""" + cmapFun + """);");
    if or(cmapFun == cmapFunctionsQualitatives) then
        assert_checktrue(size(cmap2, 1) <= 12);
        assert_checkequal(size(cmap2, 2), 3);
    else
        assert_checkequal(size(cmap2), [32, 3]);
    end

    // Use colormap function with a function
    execstr("cmap3 = colormap(" + cmapFun + "(42));");
    assert_checkequal(size(cmap3), [42, 3]);

    assert_checkequal(cmap1, cmap3);

    // Test with 0 as input
    execstr("cmap4 = " + cmapFun + "(0);");
    assert_checkequal(cmap4, []);
end

// Check default size for colormaps
close(winsid());
// No figure then use the size of the default figure colormap
for cmapFun = cmapFunctions
    cmap = [];
    execstr("cmap = " + cmapFun + "();");
    if or(cmapFun == cmapFunctionsQualitatives) then
        assert_checktrue(size(cmap2, 1) <= 12);
        assert_checkequal(size(cmap2, 2), 3);
    else
        assert_checkequal(size(cmap), size(gdf().color_map));
    end
end
// Existing figure then use the size of this figure colormap
f = gcf();
colormap(f, jet(48));
for cmapFun = cmapFunctions
    cmap = [];
    execstr("cmap = " + cmapFun + "();");
    if or(cmapFun == cmapFunctionsQualitatives) then
        assert_checktrue(size(cmap2, 1) <= 12);
        assert_checkequal(size(cmap2, 2), 3);
    else
        assert_checkequal(size(cmap), size(f.color_map));
    end
end
