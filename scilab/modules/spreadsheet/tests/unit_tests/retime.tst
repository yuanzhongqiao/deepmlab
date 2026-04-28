// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2022 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for retime function
// =============================================================================

// -----------------------------------------------------------------------
// tsout = retime(tsin, newTimeStep)
// -----------------------------------------------------------------------
Time_exp = ["2010-03-15 01:00:00"; "2010-03-15 02:00:00"; "2010-03-15 03:00:00"; ...
            "2010-03-15 04:00:00"; "2010-03-15 05:00:00"; "2010-03-15 06:00:00"];
I_exp = [1 %nan 2 %nan %nan 4]';
D_exp = [5 %nan 6 %nan %nan 8]';

T = datetime(["2010-03-15 01:00:00"; "2010-03-15 03:00:00"; "2010-03-15 04:12:05"; "2010-03-15 06:00:00"]);
I = [1 2 3 4]';
D = [5 6 7 8]';
ts = timeseries(T, I, D, "VariableNames", ["Time", "Intensity", "Distance"]);

tscomputed = retime(ts, "hourly");

assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

T = datetime(["2010-03-15"; "2010-03-16"; "2010-03-18"; "2010-03-20"]);
I = [1 2 3 4]';
D = [5 6 7 8]';
ts2 = timeseries(T, I, D, "VariableNames", ["Time", "Intensity", "Distance"]);

dt_expected = datetime(2010, 3, 15:20)';
newTimes3 = datetime(2010, 3, (15:20)');
tscomputed2 = retime(ts2, "daily");
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8]);


// -----------------------------------------------------------------------
// tsout = retime(tsin, newTimeStep, method)
// -----------------------------------------------------------------------
tscomputed = retime(ts, "hourly", "fillwithmissing");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

tscomputed = retime(ts, "hourly", "fillwithconstant");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 0; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 0; 0; 8]);

tscomputed = retime(ts, "hourly", "linear");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time));

tscomputed = retime(ts, "hourly", "spline");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time, "spline", "extrap"));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time, "spline", "extrap"));

tscomputed = retime(ts, "hourly", sum);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 3; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 7; 0; 8]);

tscomputed = retime(ts, "hourly", prod);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 1; 2; 3; 1; 4]);
assert_checkequal(tscomputed.Distance, [5; 1; 6; 7; 1; 8]);

tscomputed = retime(ts, "hourly", "count");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 1; 1; 0; 1]);
assert_checkequal(tscomputed.Distance, [1; 0; 1; 1; 0; 1]);

tscomputed = retime(ts, "hourly", "mode");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, "hourly", "firstvalue");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, "hourly", "lastvalue");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);


tscomputed2 = retime(ts2, "daily", "fillwithmissing");
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8]);

tscomputed2 = retime(ts2, "daily", "fillwithconstant");
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8]);

tscomputed2 = retime(ts2, "daily", "linear");
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "linear", "extrap"));
assert_checkequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "linear", "extrap"));

tscomputed2 = retime(ts2, "daily", "spline");
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkalmostequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "spline", "extrap"));
assert_checkalmostequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "spline", "extrap"));

tscomputed2 = retime(ts2, "daily", sum);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8]);

tscomputed2 = retime(ts2, "daily", prod);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; 1; 3; 1; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 1; 7; 1; 8]);

tscomputed2 = retime(ts2, "daily", "count");
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 1; 0; 1; 0; 1]);
assert_checkequal(tscomputed2.Distance, [1; 1; 0; 1; 0; 1]);

tscomputed2 = retime(ts2, "daily", "mode");
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8]);

tscomputed2 = retime(ts2, "daily", "firstvalue");
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8]);

tscomputed2 = retime(ts2, "daily", "lastvalue");
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8]);


// -----------------------------------------------------------------------
// tsout = retime(tsin, newTimes)
// -----------------------------------------------------------------------
newTimes1 = datetime(2010, 3, 15, (1:6)', 0, 0);
tscomputed = retime(ts, newTimes1);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

newTimes2 = datetime(2010, 3, (15:21)');
tscomputed2 = retime(ts2, newTimes2);
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4; %nan]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8; %nan]);


// -----------------------------------------------------------------------
// tsout = retime(tsin, newTimes, method)
// -----------------------------------------------------------------------
tscomputed = retime(ts, newTimes1, "fillwithmissing");
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

tscomputed = retime(ts, newTimes1, "fillwithconstant");
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 0; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 0; 0; 8]);

tscomputed = retime(ts, newTimes1, "linear");
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time));

tscomputed = retime(ts, newTimes1, "spline");
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time, "spline", "extrap"));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time, "spline", "extrap"));

tscomputed = retime(ts, newTimes1, sum);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 3; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 7; 0; 8]);

tscomputed = retime(ts, newTimes1, prod);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 1; 2; 3; 1; 4]);
assert_checkequal(tscomputed.Distance, [5; 1; 6; 7; 1; 8]);

tscomputed = retime(ts, newTimes1, "count");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 1; 1; 0; 1]);
assert_checkequal(tscomputed.Distance, [1; 0; 1; 1; 0; 1]);

tscomputed = retime(ts, newTimes1, "mode");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, newTimes1, "firstvalue");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, newTimes1, "lastvalue");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed2 = retime(ts2, newTimes2, "fillwithmissing");
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4; %nan]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8; %nan]);

tscomputed2 = retime(ts2, newTimes2, "fillwithconstant");
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4; 0]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8; 0]);

tscomputed2 = retime(ts2, newTimes2, "linear");
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "linear", "extrap"));
assert_checkequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "linear", "extrap"));

tscomputed2 = retime(ts2, newTimes2, "spline");
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkalmostequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "spline", "extrap"));
assert_checkalmostequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "spline", "extrap"));

tscomputed2 = retime(ts2, newTimes2, sum);
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4; 0]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8; 0]);

tscomputed2 = retime(ts2, newTimes2, prod);
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkequal(tscomputed2.Intensity, [1; 2; 1; 3; 1; 4; 1]);
assert_checkequal(tscomputed2.Distance, [5; 6; 1; 7; 1; 8; 1]);


// -----------------------------------------------------------------------
// tsout = retime(tsin, 'regular', 'TimeStep', dt)
// -----------------------------------------------------------------------
tscomputed = retime(ts, "regular", "TimeStep", hours(1));
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

tscomputed2 = retime(ts2, "regular", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8]);


// -----------------------------------------------------------------------
// tsout = retime(tsin, 'regular', method, 'TimeStep', dt)
// -----------------------------------------------------------------------
tscomputed = retime(ts, 'regular', "fillwithmissing", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

tscomputed = retime(ts, 'regular', "fillwithconstant", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 0; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 0; 0; 8]);

tscomputed = retime(ts, 'regular', "linear", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time));

tscomputed = retime(ts, 'regular', "spline", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time, "spline", "extrap"));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time, "spline", "extrap"));

tscomputed = retime(ts, 'regular', sum, 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 3; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 7; 0; 8]);

tscomputed = retime(ts, "regular", prod, 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 1; 2; 3; 1; 4]);
assert_checkequal(tscomputed.Distance, [5; 1; 6; 7; 1; 8]);

tscomputed = retime(ts, "regular", "count", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 1; 1; 0; 1]);
assert_checkequal(tscomputed.Distance, [1; 0; 1; 1; 0; 1]);

tscomputed = retime(ts, "regular", "mode", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, "regular", "firstvalue", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, "regular", "lastvalue", 'TimeStep', hours(1));
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed2 = retime(ts2, "regular", "fillwithmissing", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; %nan; 3; %nan; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; %nan; 7; %nan; 8]);

tscomputed2 = retime(ts2, "regular", "fillwithconstant", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8]);

tscomputed2 = retime(ts2, "regular", "linear", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "linear", "extrap"));
assert_checkequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "linear", "extrap"));

tscomputed2 = retime(ts2, "regular", "spline", "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkalmostequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "spline", "extrap"));
assert_checkalmostequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "spline", "extrap"));

tscomputed2 = retime(ts2, "regular", sum, "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8]);

tscomputed2 = retime(ts2, "regular", prod, "TimeStep", caldays(1));
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1; 2; 1; 3; 1; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 1; 7; 1; 8]);


// -----------------------------------------------------------------------
// tsout = retime(tsin, 'regular', 'SampleRate', Fs)
// -----------------------------------------------------------------------
tscomputed = retime(ts, "regular", "SampleRate", 1/3600);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

tscomputed2 = retime(ts2, "regular", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1 2 %nan 3 %nan 4]');
assert_checkequal(tscomputed2.Distance, [5 6 %nan 7 %nan 8]');


// -----------------------------------------------------------------------
// tsout = retime(tsin, 'regular', method, 'SampleRate', Fs)
// -----------------------------------------------------------------------
tscomputed = retime(ts, 'regular', "fillwithmissing", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, I_exp);
assert_checkequal(tscomputed.Distance, D_exp);

tscomputed = retime(ts, 'regular', "fillwithconstant", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 0; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 0; 0; 8]);

tscomputed = retime(ts, 'regular', "linear", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time));

tscomputed = retime(ts, 'regular', "spline", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, interp1(ts.Time.time, I, tscomputed.Time.time, "spline", "extrap"));
assert_checkequal(tscomputed.Distance, interp1(ts.Time.time, D, tscomputed.Time.time, "spline", "extrap"));

tscomputed = retime(ts, "regular", sum, 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 3; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 7; 0; 8]);

tscomputed = retime(ts, "regular", prod, 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1; 1; 2; 3; 1; 4]);
assert_checkequal(tscomputed.Distance, [5; 1; 6; 7; 1; 8]);

tscomputed = retime(ts, "regular", "count", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 1; 1; 0; 1]);
assert_checkequal(tscomputed.Distance, [1; 0; 1; 1; 0; 1]);

tscomputed = retime(ts, "regular", "mode", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, "regular", "firstvalue", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed = retime(ts, "regular", "lastvalue", 'SampleRate', 1/3600);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; %nan; 2; 3; %nan; 4]);
assert_checkequal(tscomputed.Distance, [5; %nan; 6; 7; %nan; 8]);

tscomputed2 = retime(ts2, "regular", "fillwithmissing", 'SampleRate', 1/86400);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1 2 %nan 3 %nan 4]');
assert_checkequal(tscomputed2.Distance, [5 6 %nan 7 %nan 8]');

tscomputed2 = retime(ts2, "regular", "fillwithconstant", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8]);

tscomputed2 = retime(ts2, "regular", "linear", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "linear", "extrap"));
assert_checkequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "linear", "extrap"));

tscomputed2 = retime(ts2, "regular", "spline", "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkalmostequal(tscomputed2.Intensity, interp1(ts2.Time.date, I, tscomputed2.Time.date, "spline", "extrap"));
assert_checkalmostequal(tscomputed2.Distance, interp1(ts2.Time.date, D, tscomputed2.Time.date, "spline", "extrap"));

tscomputed2 = retime(ts2, "regular", sum, "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; 0; 3; 0; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 0; 7; 0; 8]);

tscomputed2 = retime(ts2, "regular", prod, "SampleRate", 1/86400);
assert_checktrue(tscomputed2.Time == newTimes3);
assert_checkequal(tscomputed2.Intensity, [1; 2; 1; 3; 1; 4]);
assert_checkequal(tscomputed2.Distance, [5; 6; 1; 7; 1; 8]);


// -----------------------------------------------------------------------
// tsout = retime(..., Name, Value)
// -----------------------------------------------------------------------
tscomputed = retime(ts, "hourly", "fillwithconstant", "Constant", 1);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1 1 2 1 1 4]');
assert_checkequal(tscomputed.Distance, [5 1 6 1 1 8]');

tscomputed = retime(ts, newTimes1, "fillwithconstant", "Constant", 1);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1 1 2 1 1 4]');
assert_checkequal(tscomputed.Distance, [5 1 6 1 1 8]');

tscomputed = retime(ts, 'regular', "fillwithconstant", 'TimeStep', hours(1), "Constant", 1);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1 1 2 1 1 4]');
assert_checkequal(tscomputed.Distance, [5 1 6 1 1 8]');

tscomputed = retime(ts, 'regular', "fillwithconstant", 'SampleRate', 1/3600, "Constant", 1);
assert_checktrue(tscomputed.Time == newTimes1);
assert_checkequal(tscomputed.Intensity, [1 1 2 1 1 4]');
assert_checkequal(tscomputed.Distance, [5 1 6 1 1 8]');

tscomputed2 = retime(ts2, "daily", "fillwithconstant", "Constant", 0.5);
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1 2 0.5 3 0.5 4]');
assert_checkequal(tscomputed2.Distance, [5 6 0.5 7 0.5 8]');

tscomputed2 = retime(ts2, newTimes2, "fillwithconstant", "Constant", 0.5);
assert_checktrue(tscomputed2.Time == newTimes2);
assert_checkequal(tscomputed2.Intensity, [1 2 0.5 3 0.5 4 0.5]');
assert_checkequal(tscomputed2.Distance, [5 6 0.5 7 0.5 8 0.5]');

tscomputed2 = retime(ts2, "regular", "fillwithconstant", "TimeStep", caldays(1), "Constant", 0.5);
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1 2 0.5 3 0.5 4]');
assert_checkequal(tscomputed2.Distance, [5 6 0.5 7 0.5 8]');

tscomputed2 = retime(ts2, "regular", "fillwithconstant", "SampleRate", 1/86400, "Constant", 0.5);
assert_checktrue(tscomputed2.Time == dt_expected);
assert_checkequal(tscomputed2.Intensity, [1 2 0.5 3 0.5 4]');
assert_checkequal(tscomputed2.Distance, [5 6 0.5 7 0.5 8]');


// -----------------------------------------------------------------------
// tsout = retime(..., 'IncludedEdge', 'left'|'right')
// -----------------------------------------------------------------------

tscomputed = retime(ts, "hourly", sum, "IncludedEdge", "right");
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1 0 2 0 3 4]');
assert_checkequal(tscomputed.Distance, [5 0 6 0 7 8]');

T = datetime(["2010-03-15 01:10:00"; "2010-03-15 03:00:00"; "2010-03-15 04:12:05"; "2010-03-15 06:10:00"]);
I = [1 2 3 4]';
D = [5 6 7 8]';
ts = timeseries(T, I, D, "VariableNames", ["Time", "Intensity", "Distance"]);

tscomputed = retime(ts, "hourly", sum);
assert_checktrue(tscomputed.Time == Time_exp);
assert_checkequal(tscomputed.Intensity, [1; 0; 2; 3; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 0; 6; 7; 0; 8]);

tscomputed = retime(ts, "hourly", sum, "IncludedEdge", "right");
assert_checktrue(tscomputed.Time == (datetime(Time_exp) + hours(1)));
assert_checkequal(tscomputed.Intensity, [1; 2; 0; 3; 0; 4]);
assert_checkequal(tscomputed.Distance, [5; 6; 0; 7; 0; 8]);

// -----------------------------------------------------------------------
// OTHERS TESTS
// -----------------------------------------------------------------------
Time = datetime([2017 3 4; 2017 3 2; 2017 3 15; 2017 3 10; ...
                       2017 3 14; 2017 4 2; 2017 3 25; ...
                       2017 3 29; 2017 3 21; 2017 3 18]);
A = [2032 3071 1185 2587 1998 2899 3112 909 2619 3085]';
B = [14 13 8 5 10 16 8 6 7 11]';
ts = timeseries(Time,A,B, "VariableNames", ["Time", "A", "B"]);

tscomputed = retime(ts, "monthly");
tsTimeExpected = (datetime(2017,3,1):calmonths(1):datetime(2017,5,1))';
assert_checktrue(tscomputed.Time == tsTimeExpected);
tscomputed = retime(ts, "monthly", "count");
assert_checktrue(tscomputed.Time == tsTimeExpected(1:2));
tscomputed = retime(ts, "monthly", "count", "IncludedEdge", "left");
assert_checktrue(tscomputed.Time == tsTimeExpected(1:2));
tscomputed = retime(ts, "monthly", "count", "IncludedEdge", "right");
assert_checktrue(tscomputed.Time == tsTimeExpected(2:3));

// Test case-sensitivity on options
assert_checktrue(execstr("retime(ts, ""regular"", ""tIMEstep"", hours(1))", "errcatch") == 0);
assert_checktrue(execstr("retime(ts, ""regular"", ""sAmplErAtE"", 1/3600)", "errcatch") == 0);
assert_checktrue(execstr("retime(ts, ""hourly"", ""fillwithconstant"", ""COnSTanT"", 1)", "errcatch") == 0);
assert_checktrue(execstr("retime(ts, ""hourly"", sum, ""InCLudedeDGe"", ""right"")", "errcatch") == 0);


// -----------------------------------------------------------------------
// ERRORS
// -----------------------------------------------------------------------
msg = msprintf(_("%s: Wrong number of input arguments: %d to %d expected.\n"), "retime", 2, 9);
assert_checkerror("retime()", msg);
assert_checkerror("retime(ts)", msg);
assert_checkerror("retime(ts, ""hourly"", sum, ""TimeStep"", hours(1), ""Constant"", 0, ""IncludedEdge"", ""right"", ""IncludedEdge"", ""right"")", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A timeseries expected.\n"), "retime", 1);
assert_checkerror("retime([1, 2; 3 4], hours(1:10))", msg);
assert_checkerror("retime(""toto"", hours(1:10))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A duration, datetime or string expected.\n"), "retime", 2);
assert_checkerror("retime(ts, %t)", msg);
assert_checkerror("retime(ts, sum)", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: A single string expected.\n"), "retime", 2);
assert_checkerror("retime(ts, [""regular"", ""regular""])", msg);
assert_checkerror("retime(ts, [""regular""; ""regular""])", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: %s, %s, %s, %s, %s, %s or %s expected.\n"), "retime", 2, """regular""", """yearly""", """monthly""", """daily""", """hourly""", """minutely""", """secondly""");
assert_checkerror("retime(ts, ""year"")", msg);
assert_checkerror("retime(ts, ""timestep"")", msg);

msg = msprintf(_("%s: Wrong size for input argument #%d: Column vector expected.\n"), "retime", 2);
assert_checkerror("retime(ts, hours([1 2]))", msg);
assert_checkerror("retime(ts, hours([1 2; 3 4]))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A string or function expected.\n"), "retime", 3);
assert_checkerror("retime(ts, hours([1; 2]), 1)", msg);
assert_checkerror("retime(ts, hours([1; 2; 3; 4]), %t)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: An user function or %s, %s, %s, %s, %s, %s, %s or %s methods expected.\n"), "retime", 3, """fillwithmissing""", """fillwithconstant""", """linear""", """spline""", """count""", """firstvalue""", """lastvalue""", """mode""");
assert_checkerror("retime(ts, hours([1; 2]), ""method"")", msg);
assert_checkerror("retime(ts, hours([1; 2; 3; 4]), ""interp"")", msg);

msg = msprintf(_("%s: Wrong number of input arguments: %s or %s are missing.\n"), "retime", """TimeStep""", """SampleRate""");
assert_checkerror("retime(ts, ""regular"")", msg);
assert_checkerror("retime(ts, ""regular"", sum)", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A real scalar expected.\n"), "retime", 4);
assert_checkerror("retime(ts, ""regular"", ""SampleRate"", ""1"")", msg);
assert_checkerror("retime(ts, ""regular"", ""SampleRate"", %t)", msg);
assert_checkerror("retime(ts, ""regular"", ""SampleRate"", [1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A duration or calendarDuration expected.\n"), "retime", 4);
assert_checkerror("retime(ts, ""regular"", ""TimeStep"", 1)", msg);
assert_checkerror("retime(ts, ""regular"", ""TimeStep"", ""1"")", msg);
assert_checkerror("retime(ts, ""regular"", ""TimeStep"", hours([1 2; 3 4]))", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: A real scalar expected.\n"), "retime", 5);
assert_checkerror("retime(ts, ""hourly"", ""fillwithconstant"", ""Constant"", ""1"")", msg);
assert_checkerror("retime(ts, ""hourly"", ""fillwithconstant"", ""Constant"", [1 2; 3 4])", msg);

msg = msprintf(_("%s: Wrong type for input argument #%d: %s or %s expected.\n"), "retime", 5, """left""", """right""");
assert_checkerror("retime(ts, ""hourly"", sum, ""IncludedEdge"", ""1"")", msg);
assert_checkerror("retime(ts, ""hourly"", sum, ""IncludedEdge"", 1)", msg);

msg = msprintf(_("%s: Wrong value of input argument #%d: %s, %s, %s or %s expected.\n"), "retime", 4, """TimeStep""", """SampleRate""", """Constant""", """IncludedEdge""");
assert_checkerror("retime(ts, ""hourly"", ""fillwithconstant"", ""toto"", 0)", msg);
assert_checkerror("retime(ts, ""hourly"", sum, ""toto"", ""right"")", msg);

msg = msprintf(_("%s: Wrong value of input argument #%d: %s, %s, %s or %s expected.\n"), "retime", 3, """TimeStep""", """SampleRate""", """Constant""", """IncludedEdge""");
assert_checkerror("retime(ts, ""regular"", ""toto"", 0)", msg);
