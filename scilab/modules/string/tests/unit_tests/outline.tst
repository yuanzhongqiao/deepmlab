// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stephane MOTTELET
//

// <-- TEST WITH GRAPHIC -->

data.d0 = [];
data.d = 1;
data.D = rand(5, 5);
data.b = %t;
data.B = [%t %f;%f %t];
data.s = "outline";
data.S = ["outline" "outline";"outline", "outline"];
data.i8 = int8(1);
data.I8 = int8([1 2 3 4]);
data.i16 = int16(1);
data.I16 = int16([1 2 3 4]);
data.i32 = int32(1);
data.I32 = int32([1 2 3 4]);
data.i64 = int64(1);
data.I64 = int64([1 2 3 4]);
data.l = list();
data.L = list(1, 2, 3);
data.ce0 = {[]};
data.ce = {[1 2 3 4], ["outline"]};
data.p = %s;
data.P = [%s %s;%s %s];
data.r = 1/%s;
data.R = 1 ./ [%s %s;%s %s];
data.sp = sparse([1 2 3]);
data.spb = sparse([1 2 3] > 1);
data.st0 = struct();
data.st = struct("a", [1 2 3]);
data.st2 = struct("", [1 2 3]);
data.ST = [struct("a", [1 2 3]) struct("a", [1 2 3]) struct("a", [1 2 3])];
data.ST0 = [struct() struct() struct()];
data.h = plot(1:10);
data.H = [plot(1:10) plot(1:10)];
data.tl0 = tlist(["e"]);
data.tl = tlist(["e","x"],1);
data.ml0 = mlist(["e"]);
data.ml = mlist(["e","x"],1);
jimport java.lang.String;
data.j = String.new("Hello world");
doc = xmlReadStr("<root><a xmlns:scilab=""http://www.scilab.org"">" + ..
            "<b>Hello </b><scilab:c>World</scilab:c></a></root>");
data.xmlDoc = doc; // xmlDoc
data.xmlNs = xmlGetNsByHref(doc.root.children(1).children(2), "http://www.scilab.org"); // xmlNs
e = xmlElement(doc, "c"); // xmlElem
e.attributes.attr = "value";
e.content = "!";
data.xmlElem = e;
data.xmlValid = xmlDTD("SCI/modules/xml/tests/unit_tests/library.dtd"); // xmlValid
data.xmlList = doc.root.children;
data.xmlSet = xmlXPath(doc, "//a"); // xmlSet
data.dt = datetime(2024, 7, 4);
data.DT = [datetime(2024, 7, 4) datetime(2024, 7, 4) datetime(2024, 7, 4)];
data.dura = duration(1);
data.caldura = caldays(1);
data.DURA = [duration(1) duration(1) duration(1)];
data.DT = [datetime(2024, 7, 4) datetime(2024, 7, 4) datetime(2024, 7, 4)];
data.table = table(["AF"; "NA"], ["Africa"; "North America"]);
data.ts = timeseries(hours(1:2)', ["AF"; "NA"], ["Africa"; "North America"]);

// data.fig = gcf(); // figure_size is not always the same
data.ax = gca();
grayplot(1:10,1:10,rand(10,10))
data.gp = gce();
x = 1:10;
X = ndgrid(x);
[fx, fy] =  (rand(X)-0.5, rand(X)-0.5);
champ(x, x, fx, fy);
data.champ = gce();

data.tlist1 = tlist(["t1", "x"], 1);
data.mlist1 = mlist(["t1", "x"], 2);
data.tlist2 = tlist(["t2", "x"], 1);
data.mlist2 = mlist(["t2", "x"], 2);
data.tlist3 = tlist(["t3", ""], 1);
data.mlist3 = mlist(["t3", ""], 2);

function %t1_p(x), disp("test");end
function %t2_p(x), disp("test");end
function s = %t2_outline(x, verbose), s = "t2 outline";end

//mode cannot be check in test, test_run remove empty lines in dia.ref
for i = fieldnames(data)'
	data(i)
	disp(data(i))
end

data
