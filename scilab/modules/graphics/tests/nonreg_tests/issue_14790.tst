// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 14790 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/14790
//
// <-- Short Description -->
// The ticks_format and ticks_st properties are no more taken into account in Scilab-6.0-beta2

plot(1:10, 1:10);
a = gca();
x_ticks_locations = a.x_ticks.locations;
x_ticks_labels = a.x_ticks.labels;
assert_checkequal(x_ticks_locations, (1:10)');
assert_checkequal(x_ticks_labels, string(1:10)');
y_ticks_locations = a.y_ticks.locations;
y_ticks_labels = a.y_ticks.labels;
assert_checkequal(y_ticks_locations, (1:10)');
assert_checkequal(y_ticks_labels, string(1:10)');

// change ticks format => check display us updated
x_ticks_format = "** %.2f @@";
y_ticks_format = "## %.3f $$";
a.ticks_format = [x_ticks_format, y_ticks_format, ""];

x_ticks_locations = a.x_ticks.locations;
x_ticks_labels = a.x_ticks.labels;
N = size(x_ticks_locations, '*');
for i = 1:N
    assert_checkequal(x_ticks_labels(i), sprintf(x_ticks_format, x_ticks_locations(i)));
end
y_ticks_locations = a.y_ticks.locations;
y_ticks_labels = a.y_ticks.labels;
N = size(y_ticks_locations, '*');
for i = 1:N
    assert_checkequal(y_ticks_labels(i), sprintf(y_ticks_format, y_ticks_locations(i)));
end

// restore ticks format
// change ticks_st
a.ticks_format = ["", "", ""];
x_s = 10;
x_t = 0.5;
y_s = 0.1;
y_t = 10;
a.ticks_st = [x_s, y_s, 1 ; x_t, y_t, 0];
// display_x = x_s * (x - x_t) only if format is specified !!
x_ticks_locations = a.x_ticks.locations;
x_ticks_labels = a.x_ticks.labels;
assert_checkequal(x_ticks_locations, (1:10)');
assert_checkequal(x_ticks_labels, string(1:10)');
y_ticks_locations = a.y_ticks.locations;
y_ticks_labels = a.y_ticks.labels;
assert_checkequal(y_ticks_locations, (1:10)');
assert_checkequal(y_ticks_labels, string(1:10)');
// now add format
x_ticks_format = "** %.2f @@";
y_ticks_format = "## %.3f $$";
a.ticks_format = [x_ticks_format, y_ticks_format, ""];
x_ticks_locations = a.x_ticks.locations;
x_ticks_labels = a.x_ticks.labels;
N = size(x_ticks_locations, '*');
for i = 1:N
    display_x = x_s * (x_ticks_locations(i) - x_t);
    assert_checkequal(x_ticks_labels(i), sprintf(x_ticks_format, display_x));
end
y_ticks_locations = a.y_ticks.locations;
y_ticks_labels = a.y_ticks.labels;
N = size(y_ticks_locations, '*');
for i = 1:N
    display_y = y_s * (y_ticks_locations(i) - y_t);
    assert_checkequal(y_ticks_labels(i), sprintf(y_ticks_format, display_y));
end
// now add invalid format
x_ticks_format = "** %.2i @@";
y_ticks_format = "## %.3i $$";
a.ticks_format = [x_ticks_format, y_ticks_format, ""];
x_ticks_locations = a.x_ticks.locations;
x_ticks_labels = a.x_ticks.labels;
N = size(x_ticks_locations, '*');
assert_checkequal(x_ticks_labels, string(1:10)');
y_ticks_locations = a.y_ticks.locations;
y_ticks_labels = a.y_ticks.labels;
N = size(y_ticks_locations, '*');
assert_checkequal(y_ticks_labels, string(1:10)');
