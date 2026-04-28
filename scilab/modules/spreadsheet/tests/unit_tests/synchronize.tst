// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for synchronize function
// =============================================================================

// -----------------------------------------------------------------------
// tsout = synchronize(ts1, ts2)
// -----------------------------------------------------------------------
ts1 = timeseries(datetime(2022, 10, 1, 0:2:4, 0, 0)', [1;2;3]);
ts2 = timeseries(datetime(2022, 10, 1, 1:2:5, 0, 0)', [4;5;6]);
ts3 = timeseries(datetime(2022, 10, 2:2:6)', [1;2;3]);
ts4 = timeseries(datetime(2022, 10, 1:2:5)', [4;5;6]);

newtime1 = datetime(2022, 10, 1, (0:5)', 0, 0);
c1 = [1; %nan; 2; %nan; 3; %nan];
c2 = [%nan; 4; %nan; 5; %nan; 6];
c11 = [1; 0; 2; 0; 3; 0];
c22 = [0; 4; 0; 5; 0; 6];
c111 = [1; 1; 2; 1; 3; 1];
c222 = [1; 4; 1; 5; 1; 6];

newtime2 = datetime(2022, 10, (1:6)');
c3 = [%nan; 1; %nan; 2; %nan; 3];
c4 = [4; %nan; 5; %nan; 6; %nan];
c33 = [0; 1; 0; 2; 0; 3];
c44 = [4; 0; 5; 0; 6; 0];
c333 = [1; 1; 1; 2; 1; 3];
c444 = [4; 1; 5; 1; 6; 1];

tscomputed = synchronize(ts1, ts2);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c1);
assert_checkequal(tscomputed.Var1_ts2, c2);

tscomputed2 = synchronize(ts3, ts4);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c3);
assert_checkequal(tscomputed2.Var1_ts2, c4);

// -----------------------------------------------------------------------
// tsout = synchronize(ts1, ts2, newTimeStep)
// -----------------------------------------------------------------------

tscomputed = synchronize(ts1, ts2, "hourly");
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c1);
assert_checkequal(tscomputed.Var1_ts2, c2);

tscomputed2 = synchronize(ts3, ts4, "daily");
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c3);
assert_checkequal(tscomputed2.Var1_ts2, c4);


// -----------------------------------------------------------------------
// tsout = synchronize(tsin, newTimeStep, method)
// -----------------------------------------------------------------------

tscomputed = synchronize(ts1, ts2, "hourly", "fillwithmissing");
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c1);
assert_checkequal(tscomputed.Var1_ts2, c2);

tscomputed = synchronize(ts1, ts2, ts2, "hourly", "fillwithconstant");
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c11);
assert_checkequal(tscomputed.Var1_ts2, c22);

tscomputed = synchronize(ts1, ts2, "hourly", "linear");
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, [1; 1.5; 2; 2.5; 3; 3.5]);
assert_checkequal(tscomputed.Var1_ts2, [3.5; 4; 4.5; 5; 5.5; 6]);

tscomputed = synchronize(ts1, ts2, "hourly", "spline");
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, [1; 1.5; 2; 2.5; 3; 3.5]);
assert_checkalmostequal(tscomputed.Var1_ts2, [3.5; 4; 4.5; 5; 5.5; 6]);

tscomputed = synchronize(ts1, ts2, "hourly", sum);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c11);
assert_checkequal(tscomputed.Var1_ts2, c22);

tscomputed = synchronize(ts1, ts2, "hourly", prod);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c111);
assert_checkequal(tscomputed.Var1_ts2, c222);


tscomputed2 = synchronize(ts3, ts4, "daily", "fillwithmissing");
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c3);
assert_checkequal(tscomputed2.Var1_ts2, c4)

tscomputed2 = synchronize(ts3, ts4, "daily", "fillwithconstant");
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c33);
assert_checkequal(tscomputed2.Var1_ts2, c44);

tscomputed2 = synchronize(ts3, ts4, "daily", "linear");
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, [0.5; 1; 1.5; 2; 2.5; 3]);
assert_checkequal(tscomputed2.Var1_ts2, [4; 4.5; 5; 5.5; 6; 6.5]);

tscomputed2 = synchronize(ts3, ts4, "daily", "spline");
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkalmostequal(tscomputed2.Var1_ts1, [0.5; 1; 1.5; 2; 2.5; 3]);
assert_checkalmostequal(tscomputed2.Var1_ts2, [4; 4.5; 5; 5.5; 6; 6.5]);

tscomputed2 = synchronize(ts3, ts4, "daily", sum);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c33);
assert_checkequal(tscomputed2.Var1_ts2, c44);

tscomputed2 = synchronize(ts3, ts4, "daily", prod);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c333);
assert_checkequal(tscomputed2.Var1_ts2, c444);


// -----------------------------------------------------------------------
// tsout = synchronize(tsin, newTimes)
// -----------------------------------------------------------------------
t1 = datetime(2022, 10, 1, 3:8, 0, 0)';
r1 = [%nan; 3; %nan; %nan; %nan; %nan];
r2 = [5; %nan; 6; %nan; %nan; %nan];
r11 = [0; 3; 0; 0; 0; 0];
r22 = [5; 0; 6; 0; 0; 0];
r111 = [1; 3; 1; 1; 1; 1];
r222 = [5; 1; 6; 1; 1; 1];

tscomputed = synchronize(ts1, ts2, t1);
assert_checktrue(tscomputed.Time == t1);
assert_checkequal(tscomputed.Var1_ts1, r1);
assert_checkequal(tscomputed.Var1_ts2, r2);

t2 = datetime(2022, 10, 2:5)';
r3 = [1; %nan; 2; %nan];
r4 = [%nan; 5; %nan; 6];
r33 = [1; 0; 2; 0];
r44 = [0; 5; 0; 6];
r333 = [1; 1; 2; 1];
r444 = [1; 5; 1; 6];
tscomputed2 = synchronize(ts3, ts4, t2);
assert_checktrue(tscomputed2.Time == t2);
assert_checkequal(tscomputed2.Var1_ts1, r3);
assert_checkequal(tscomputed2.Var1_ts2, r4);


// -----------------------------------------------------------------------
// tsout = synchronize(tsin, newTimes, method)
// -----------------------------------------------------------------------
tscomputed = synchronize(ts1, ts2, t1, "fillwithmissing");
assert_checktrue(tscomputed.Time == t1);
assert_checkequal(tscomputed.Var1_ts1, r1);
assert_checkequal(tscomputed.Var1_ts2, r2);

tscomputed = synchronize(ts1, ts2, t1, "fillwithconstant");
assert_checktrue(tscomputed.Time == t1);
assert_checkequal(tscomputed.Var1_ts1, r11);
assert_checkequal(tscomputed.Var1_ts2, r22);

tscomputed = synchronize(ts1, ts2, t1, "linear");
assert_checktrue(tscomputed.Time == t1);
assert_checkequal(tscomputed.Var1_ts1, [2.5; 3; 3.5; 4; 4.5; 5]);
assert_checkequal(tscomputed.Var1_ts2, [5; 5.5; 6; 6.5; 7; 7.5]);

tscomputed = synchronize(ts1, ts2, t1, "spline");
assert_checktrue(tscomputed.Time == t1);
assert_checkalmostequal(tscomputed.Var1_ts1, [2.5; 3; 3.5; 4; 4.5; 5]);
assert_checkalmostequal(tscomputed.Var1_ts2, [5; 5.5; 6; 6.5; 7; 7.5]);

tscomputed = synchronize(ts1, ts2, t1, sum);
assert_checktrue(tscomputed.Time == t1);
assert_checkequal(tscomputed.Var1_ts1, r11);
assert_checkequal(tscomputed.Var1_ts2, r22);

tscomputed = synchronize(ts1, ts2, t1, prod);
assert_checktrue(tscomputed.Time == t1);
assert_checkequal(tscomputed.Var1_ts1, r111);
assert_checkequal(tscomputed.Var1_ts2, r222);


tscomputed2 = synchronize(ts3, ts4, t2, "fillwithmissing");
assert_checktrue(tscomputed2.Time == t2);
assert_checkequal(tscomputed2.Var1_ts1, r3);
assert_checkequal(tscomputed2.Var1_ts2, r4);

tscomputed2 = synchronize(ts3, ts4, t2, "fillwithconstant");
assert_checktrue(tscomputed2.Time == t2);
assert_checkequal(tscomputed2.Var1_ts1, r33);
assert_checkequal(tscomputed2.Var1_ts2, r44);

tscomputed2 = synchronize(ts3, ts4, t2, "linear");
assert_checktrue(tscomputed2.Time == t2);
assert_checkequal(tscomputed2.Var1_ts1, [1; 1.5; 2; 2.5]);
assert_checkequal(tscomputed2.Var1_ts2, [4.5; 5; 5.5; 6]);

tscomputed2 = synchronize(ts3, ts4, t2, "spline");
assert_checktrue(tscomputed2.Time == t2);
assert_checkalmostequal(tscomputed2.Var1_ts1, [1; 1.5; 2; 2.5]);
assert_checkalmostequal(tscomputed2.Var1_ts2, [4.5; 5; 5.5; 6]);

tscomputed2 = synchronize(ts3, ts4, t2, sum);
assert_checktrue(tscomputed2.Time == t2);
assert_checkequal(tscomputed2.Var1_ts1, r33);
assert_checkequal(tscomputed2.Var1_ts2, r44);

tscomputed2 = synchronize(ts3, ts4, t2, prod);
assert_checktrue(tscomputed2.Time == t2);
assert_checkequal(tscomputed2.Var1_ts1, r333);
assert_checkequal(tscomputed2.Var1_ts2, r444);


// -----------------------------------------------------------------------
// tsout = synchronize(tsin, 'regular', 'TimeStep', dt)
// -----------------------------------------------------------------------
tscomputed = synchronize(ts1, ts2, "regular", "TimeStep", hours(1));
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c1);
assert_checkequal(tscomputed.Var1_ts2, c2);

tscomputed2 = synchronize(ts3, ts4, "regular", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c3);
assert_checkequal(tscomputed2.Var1_ts2, c4);


// -----------------------------------------------------------------------
// tsout = synchronize(tsin, 'regular', method, 'TimeStep', dt)
// -----------------------------------------------------------------------
tscomputed = synchronize(ts1, ts2, 'regular', "fillwithmissing", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c1);
assert_checkequal(tscomputed.Var1_ts2, c2);

tscomputed = synchronize(ts1, ts2, 'regular', "fillwithconstant", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c11);
assert_checkequal(tscomputed.Var1_ts2, c22);

tscomputed = synchronize(ts1, ts2, 'regular', "linear", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, [1; 1.5; 2; 2.5; 3; 3.5]);
assert_checkequal(tscomputed.Var1_ts2, [3.5; 4; 4.5; 5; 5.5; 6]);

tscomputed = synchronize(ts1, ts2, 'regular', "spline", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, [1; 1.5; 2; 2.5; 3; 3.5]);
assert_checkalmostequal(tscomputed.Var1_ts2, [3.5; 4; 4.5; 5; 5.5; 6]);

tscomputed = synchronize(ts1, ts2, 'regular', sum, 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c11);
assert_checkequal(tscomputed.Var1_ts2, c22);

tscomputed = synchronize(ts1, ts2, 'regular', prod, 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c111);
assert_checkequal(tscomputed.Var1_ts2, c222);


tscomputed2 = synchronize(ts3, ts4, "regular", "fillwithmissing", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c3);
assert_checkequal(tscomputed2.Var1_ts2, c4);

tscomputed2 = synchronize(ts3, ts4, "regular", "fillwithconstant", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c33);
assert_checkequal(tscomputed2.Var1_ts2, c44);

tscomputed2 = synchronize(ts3, ts4, "regular", "linear", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, [0.5; 1; 1.5; 2; 2.5; 3]);
assert_checkequal(tscomputed2.Var1_ts2, [4; 4.5; 5; 5.5; 6; 6.5]);

tscomputed2 = synchronize(ts3, ts4, "regular", "spline", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkalmostequal(tscomputed2.Var1_ts1, [0.5; 1; 1.5; 2; 2.5; 3]);
assert_checkalmostequal(tscomputed2.Var1_ts2, [4; 4.5; 5; 5.5; 6; 6.5]);

tscomputed2 = synchronize(ts3, ts4, "regular", sum, "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c33);
assert_checkequal(tscomputed2.Var1_ts2, c44);

tscomputed2 = synchronize(ts3, ts4, "regular", prod, "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c333);
assert_checkequal(tscomputed2.Var1_ts2, c444);


// -----------------------------------------------------------------------
// tsout = synchronize(tsin, 'regular', 'SampleRate', Fs)
// -----------------------------------------------------------------------
tscomputed = synchronize(ts1, ts2, "regular", "SampleRate", 1/3600);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c1);
assert_checkequal(tscomputed.Var1_ts2, c2);

tscomputed2 = synchronize(ts3, ts4, "regular", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c3);
assert_checkequal(tscomputed2.Var1_ts2, c4);


// -----------------------------------------------------------------------
// tsout = synchronize(tsin, 'regular', method, 'SampleRate', Fs)
// -----------------------------------------------------------------------
tscomputed = synchronize(ts1, ts2, 'regular', "fillwithmissing", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c1);
assert_checkequal(tscomputed.Var1_ts2, c2);

tscomputed = synchronize(ts1, ts2, 'regular', "fillwithconstant", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c11);
assert_checkequal(tscomputed.Var1_ts2, c22);

tscomputed = synchronize(ts1, ts2, 'regular', "linear", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, [1; 1.5; 2; 2.5; 3; 3.5]);
assert_checkequal(tscomputed.Var1_ts2, [3.5; 4; 4.5; 5; 5.5; 6]);

tscomputed = synchronize(ts1, ts2, 'regular', "spline", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, [1; 1.5; 2; 2.5; 3; 3.5]);
assert_checkalmostequal(tscomputed.Var1_ts2, [3.5; 4; 4.5; 5; 5.5; 6]);

tscomputed = synchronize(ts1, ts2, 'regular', sum, 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c11);
assert_checkequal(tscomputed.Var1_ts2, c22);

tscomputed = synchronize(ts1, ts2, 'regular', prod, 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c111);
assert_checkequal(tscomputed.Var1_ts2, c222);

tscomputed2 = synchronize(ts3, ts4, "regular", "fillwithmissing", 'SampleRate', 1/86400);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c3);
assert_checkequal(tscomputed2.Var1_ts2, c4);

tscomputed2 = synchronize(ts3, ts4, "regular", "fillwithconstant", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c33);
assert_checkequal(tscomputed2.Var1_ts2, c44);

tscomputed2 = synchronize(ts3, ts4, "regular", "linear", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, [0.5; 1; 1.5; 2; 2.5; 3]);
assert_checkequal(tscomputed2.Var1_ts2, [4; 4.5; 5; 5.5; 6; 6.5]);

tscomputed2 = synchronize(ts3, ts4, "regular", "spline", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkalmostequal(tscomputed2.Var1_ts1, [0.5; 1; 1.5; 2; 2.5; 3]);
assert_checkalmostequal(tscomputed2.Var1_ts2, [4; 4.5; 5; 5.5; 6; 6.5]);

tscomputed2 = synchronize(ts3, ts4, "regular", sum, "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c33);
assert_checkequal(tscomputed2.Var1_ts2, c44);

tscomputed2 = synchronize(ts3, ts4, "regular", prod, "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, c333);
assert_checkequal(tscomputed2.Var1_ts2, c444);

// -----------------------------------------------------------------------
// tsout = synchronize(..., Name, Value)
// -----------------------------------------------------------------------
tscomputed = synchronize(ts1, ts2, "hourly", "fillwithconstant", "Constant", 1);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c111);
assert_checkequal(tscomputed.Var1_ts2, c222);

tscomputed = synchronize(ts1, ts2, t1, "fillwithconstant", "Constant", 1);
assert_checktrue(tscomputed.Time == t1);
assert_checkequal(tscomputed.Var1_ts1, r111);
assert_checkequal(tscomputed.Var1_ts2, r222);

tscomputed = synchronize(ts1, ts2, 'regular', "fillwithconstant", 'TimeStep', hours(1), "Constant", 1);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c111);
assert_checkequal(tscomputed.Var1_ts2, c222);

tscomputed = synchronize(ts1, ts2, 'regular', "fillwithconstant", 'SampleRate', 1/3600, "Constant", 1);
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c111);
assert_checkequal(tscomputed.Var1_ts2, c222);

tscomputed2 = synchronize(ts3, ts4, "daily", "fillwithconstant", "Constant", 0.5);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, [0.5;1;0.5;2;0.5;3]);
assert_checkequal(tscomputed2.Var1_ts2, [4;0.5;5;0.5;6;0.5]);

tscomputed2 = synchronize(ts3, ts4, t2, "fillwithconstant", "Constant", 0.5);
assert_checktrue(tscomputed2.Time == t2);
assert_checkequal(tscomputed2.Var1_ts1, [1;0.5;2;0.5]);
assert_checkequal(tscomputed2.Var1_ts2, [0.5;5;0.5;6]);

tscomputed2 = synchronize(ts3, ts4, "regular", "fillwithconstant", "TimeStep", caldays(1), "Constant", 0.5);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, [0.5;1;0.5;2;0.5;3]);
assert_checkequal(tscomputed2.Var1_ts2, [4;0.5;5;0.5;6;0.5]);

tscomputed2 = synchronize(ts3, ts4, "regular", "fillwithconstant", "SampleRate", 1/86400, "Constant", 0.5);
assert_checktrue(tscomputed2.Time == newtime2);
assert_checkequal(tscomputed2.Var1_ts1, [0.5;1;0.5;2;0.5;3]);
assert_checkequal(tscomputed2.Var1_ts2, [4;0.5;5;0.5;6;0.5]);

// includededge
tscomputed = synchronize(ts1, ts2, "hourly", sum, "IncludedEdge", "right");
assert_checktrue(tscomputed.Time == newtime1);
assert_checkequal(tscomputed.Var1_ts1, c11);
assert_checkequal(tscomputed.Var1_ts2, c22);

// Test case-sensitivity on options
assert_checktrue(execstr("synchronize(ts1, ts2, ""regular"", ""tiMEstEP"", hours(1))", "errcatch") == 0);
assert_checktrue(execstr("synchronize(ts1, ts2, ""regular"", ""SaMPLeRaTe"", 1/3600)", "errcatch") == 0);
assert_checktrue(execstr("synchronize(ts1, ts2, ""hourly"", sum, ""InclUDEdEdGE"", ""right"")", "errcatch") == 0);

// -----------------------------------------------------------------------
// ERRORS
// -----------------------------------------------------------------------
msg = msprintf(_("%s: Wrong number of input arguments: At least %d expected.\n"), "synchronize", 2);
assert_checkerror("synchronize()", msg);
assert_checkerror("synchronize(ts1)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A timeseries expected.\n"), "synchronize", 1);
assert_checkerror("synchronize([1, 2; 3 4], ts2)", msg);
msg = msprintf(_("%s: Wrong type for input argument #%d: A timeseries expected.\n"), "synchronize", 2);
assert_checkerror("synchronize(ts1, [1, 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A duration, datetime or string expected.\n"), "synchronize", 3);
assert_checkerror("synchronize(ts1, ts2, %t)", msg);
assert_checkerror("synchronize(ts1, ts2, sum)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: %s, %s, %s, %s, %s, %s, %s, %s or %s expected.\n"), "synchronize", 3, """union""", """intersection""", """regular""", """yearly""", """monthly""", """daily""", """hourly""", """minutely""", """secondly""");
assert_checkerror("synchronize(ts1, ts2, ""year"")", msg);
assert_checkerror("synchronize(ts1, ts2, ""timestep"")", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: Column vector expected.\n"), "synchronize", 3);
assert_checkerror("synchronize(ts1, ts2, hours([1 2]))", msg);
assert_checkerror("synchronize(ts1, ts2, hours([1 2; 3 4]))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A string or function expected.\n"), "synchronize", 4);
assert_checkerror("synchronize(ts1, ts2, hours([1; 2]), 1)", msg);
assert_checkerror("synchronize(ts1, ts2,  hours([1; 2; 3; 4]), %t)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: An user function or %s, %s, %s, %s, %s, %s, %s or %s methods expected.\n"), "synchronize", 4, """fillwithmissing""", """fillwithconstant""", """linear""", """spline""", """count""", """firstvalue""", """lastvalue""", """mode""");
assert_checkerror("synchronize(ts1, ts2, hours([1; 2]), ""method"")", msg);
assert_checkerror("synchronize(ts1, ts2, hours([1; 2; 3; 4]), ""interp"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A real scalar expected.\n"), "synchronize", 5);
assert_checkerror("synchronize(ts1, ts2, ""regular"", ""SampleRate"", ""1"")", msg);
assert_checkerror("synchronize(ts1, ts2, ""regular"", ""SampleRate"", %t)", msg);
assert_checkerror("synchronize(ts1, ts2, ""regular"", ""SampleRate"", [1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A duration or calendarDuration expected.\n"), "synchronize", 5);
assert_checkerror("synchronize(ts1, ts2, ""regular"", ""TimeStep"", 1)", msg);
assert_checkerror("synchronize(ts1, ts2, ""regular"", ""TimeStep"", ""1"")", msg);
assert_checkerror("synchronize(ts1, ts2, ""regular"", ""TimeStep"", hours([1 2; 3 4]))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A real scalar expected.\n"), "synchronize", 6);
assert_checkerror("synchronize(ts1, ts2, ""hourly"", ""fillwithconstant"", ""Constant"", ""1"")", msg);
assert_checkerror("synchronize(ts1, ts2, ""hourly"", ""fillwithconstant"", ""Constant"", [1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: %s or %s expected.\n"), "synchronize", 6, """left""", """right""");
assert_checkerror("synchronize(ts1, ts2, ""hourly"", sum, ""IncludedEdge"", ""1"")", msg);
assert_checkerror("synchronize(ts1, ts2, ""hourly"", sum, ""IncludedEdge"", 1)", msg);

msg = msprintf(_("%s: Wrong value of input argument #%d: %s, %s, %s or %s expected.\n"), "synchronize", 5, """TimeStep""", """SampleRate""", """Constant""", """IncludedEdge""");
assert_checkerror("synchronize(ts1, ts2, ""hourly"", ""fillwithconstant"", ""toto"", 0)", msg);
assert_checkerror("synchronize(ts1, ts2, ""hourly"", sum, ""toto"", ""right"")", msg);

msg = msprintf(_("%s: Wrong value of input argument #%d: %s, %s, %s or %s expected.\n"), "synchronize", 4, """TimeStep""", """SampleRate""", """Constant""", """IncludedEdge""");
assert_checkerror("synchronize(ts1, ts2, ""regular"", ""toto"", 0)", msg);
