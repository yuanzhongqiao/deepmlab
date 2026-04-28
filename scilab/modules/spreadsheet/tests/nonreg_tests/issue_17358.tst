// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
//
// <-- Non-regression test for issue 17358 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17358
//
// <-- Short Description -->
// when lines function is set to [0,0], the whole table is displayed

l = lines();
NameContinent = ["Africa"; "North America"; "Oceania"; "Antarctica"; "Asia"; "Europe"; "South America"];
Area = [30065000; 24256000; 7687000; 13209000; 44579000; 9938000; 17819000]; // in km2

bigNames = strcat(NameContinent(:, ones(100, 1)), " ", "c");

t = table(NameContinent, Area, bigNames);

lines(0, 0);
disp(t)

t = table(rand(60,20));
disp(t)

// same behavior for duration, datetime, calendarDuration and timeseries
lines(l(2), l(1))
h = floor(rand(100,1)*23)+1;
mn = floor(rand(100,1)*59)+1;
s = floor(rand(100,1)*59)+1;
d = duration(h, mn, s)

lines(0,0);
disp(d)

lines(l(2), l(1))
y = 2025*ones(100,1);
m = floor(rand(100,1)*12)+1;
dd = floor(rand(100,1)*28)+1;
dt = datetime(y,m, dd) + d

lines(0,0);
disp(dt)

lines(l(2), l(1))
Y = floor(rand(100,1)*2);
M = floor(rand(100,1)*12)+1;
D = floor(rand(100,1)*2);
c = calendarDuration(Y, M, D);


lines(0,0);
disp(c)

lines(l(2), l(1))
ts = timeseries(d(1:7), NameContinent, Area, bigNames)

lines(0, 0);
disp(ts)

lines(l(2), l(1))
ts = timeseries(dt(1:7), NameContinent, Area, bigNames)

lines(0, 0);
disp(ts)