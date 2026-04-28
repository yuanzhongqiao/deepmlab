// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systèmes S.E. - Adeline CARNIS
// Copyright (C) 2023 - Dassault Systèmes S.E. - Antoine ELIAS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for readtimeseries/writetimeseries function
// =============================================================================

function checkstring(d, v)
    if isduration(d) then
        d = %duration_string(d);
    elseif isdatetime(d) then
        d = %datetime_string(d);
    end
    assert_checkequal(d, v);
endfunction

// Read csv file with duration time column
filename = fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests", "results_with_duration.csv");

tt = readtimeseries(filename);
assert_checkequal(size(tt), [51 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "duration");
checkstring(tt.Time, string(seconds(0:0.01:0.5)'));
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


tt = readtimeseries(filename, "VariableNames", ["Time", "b"]);
assert_checkequal(size(tt), [51 1]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "b"]);
checkstring(tt.Time, string(seconds(0:0.01:0.5)'));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


tt = readtimeseries(filename, "VariableNames", ["a", "Time", "c"]);
assert_checkequal(size(tt), [51 2]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "c"]);
assert_checkequal(typeof(tt.Time), "duration");
checkstring(tt.Time, string(seconds(0:0.01:0.5)'));
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


tt = readtimeseries(filename, "VariableNames", ["a", "b", "c"], "TimeStep", minutes(15));
assert_checkequal(size(tt), [51 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "duration");
checkstring(tt.Time, string(minutes(0:15:50*15)'));
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1.vars == tt.vars);


tt = readtimeseries(filename, "VariableNames", ["a", "b", "c"], "StartTime", datetime(2023,6,1), "TimeStep", caldays(1));
assert_checkequal(size(tt), [51 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "datetime");
checkstring(tt.Time, string(datetime(2023,6,1):caldays(1):datetime(2023,7,21))');
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1.vars == tt.vars);


// Read csv file with datetime time column
filename = fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests", "results_with_datetime.csv");
d = datetime(2023,6,1):hours(1):datetime(2023,6,3,2,0,0);

tt = readtimeseries(filename);
assert_checkequal(size(tt), [51 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "datetime");
checkstring(tt.Time, string(d'));
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


tt = readtimeseries(filename, "VariableNames", ["Time", "b"]);
assert_checkequal(size(tt), [51 1]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "b"]);
checkstring(tt.Time, string(d'));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


tt = readtimeseries(filename, "VariableNames", ["a", "Time", "c"]);
assert_checkequal(size(tt), [51 2]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "c"]);
assert_checkequal(typeof(tt.Time), "datetime");
checkstring(tt.Time, string(d'));
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


tt = readtimeseries(filename, "VariableNames", ["a", "b", "c"], "TimeStep", minutes(15));
assert_checkequal(size(tt), [51 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "duration");
checkstring(tt.Time, string(minutes(0:15:50*15)'));
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


tt = readtimeseries(filename, "VariableNames", ["a", "b", "c"], "StartTime", datetime(2023,6,1), "TimeStep", calmonths(1));
assert_checkequal(size(tt), [51 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "datetime");
checkstring(tt.Time, string(datetime(2023,6,1):calmonths(1):datetime(2027,8,1))');
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1.vars == tt.vars);


d = seconds(0:0.01:0.5);
filename = fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests", "results.csv");
tt = readtimeseries(filename, "RowTimes", "Time", "ConvertTime", seconds);
assert_checkequal(size(tt), [51 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "duration");
checkstring(tt.Time, string(d'));
assert_checkequal(tt.a, ones(51, 1));
assert_checkequal(tt.b, 0.42 * ones(51, 1));
assert_checkequal(tt.c, "version" + emptystr(51, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1 == tt);


d = datetime(2023, 1:3, 10)';
filename = fullfile(SCI, "modules", "spreadsheet", "tests", "unit_tests", "results_without_time.csv");
tt = readtimeseries(filename, "RowTimes", d);
assert_checkequal(size(tt), [3 3]);
assert_checkequal(tt.Properties.VariableNames, ["Time", "a", "b", "c"]);
assert_checkequal(typeof(tt.Time), "datetime");
checkstring(tt.Time, string(d));
assert_checkequal(tt.a, ones(3, 1));
assert_checkequal(tt.b, 0.42 * ones(3, 1));
assert_checkequal(tt.c, "version" + emptystr(3, 1));
writetimeseries(tt, fullfile(TMPDIR, "test.csv"));
tt1 = readtimeseries(fullfile(TMPDIR, "test.csv"));
assert_checktrue(tt1.vars == tt.vars);

ts = timeseries(hours(1:3)', [1;2;3], ["a"; "b"; "c"]);
writetimeseries(ts, fullfile(TMPDIR, "ts.csv"), "Delimiter", ascii(9));
ts1 = readtimeseries(fullfile(TMPDIR, "ts.csv"));
assert_checktrue(ts.vars == ts1.vars);

// Test case-sensitivity on options
assert_checktrue(execstr("readtimeseries(filename, ""rowtImES"", d)", "errcatch") == 0);
