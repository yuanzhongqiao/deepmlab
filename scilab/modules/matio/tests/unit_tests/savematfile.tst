// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2008 - INRIA - Vincent Couvert <vincent.couvert@inria.fr>
// Copyright (C) 2018, 2019 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// unitary tests for savematfile() (using loadmatfile()..)
//  => in binary mode
//
// ===============================================================
// Naming conventions:
// ------------------
// Initials of variables names:
//  - "b" = booleans
//  - "d" = decimal real numbers
//  - "c" = complex numbers
//  - "spd" = sparse arrays of decimal real numbers
//  - "spc" = sparse arrays of complex numbers
//  - "spb" = sparse arrays of booleans
//  - "int"|"uint" = encoded integers
//  - "t" = text arrays
//  - "ce" = cells arrays
//  - "s"  = structures arrays
//
// Last character of variable names:
//  - "s" = Scalar
//  - "v" = Vectors
//  - "m" = Matrices
//  - "h" = Hyperarrays

// ---------------------------------------------------------------

clear
i = sqrt(-1);

// Real numbers
// ============
Empty = [];
ds = (rand(1,1)-0.5)*100;
dv = (rand(1,3)-0.5)*100;
dm = (rand(2,3)-0.5)*100;
dh = (rand(1,3,2)-0.5)*100;

// Complex numbers
// ===============
cs = ds*(1+i);
cv = dv*(1+i);
cm = dm*(1+i);
ch = dh*(1+i);

// Sparse reals
// ------------
spEmpty = sparse([]);
spds = sparse(ds);
spdv = sparse(dv);
spdm = sparse(dm);
// v4 save Scilab OK (Octave)  load Scilab crash    sparse([])=>[]  (savematfile)
// v6,7,7.3: save OK. load OK in both sides.        sparse([])=>[]
// -v4 load crash: https://gitlab.com/scilab/scilab/-/issues/15731

// Sparse complexes
// ----------------
spcs = sparse(cs);
spcv = sparse(cv);
spcm = sparse(cm);
// v4,6,7,7.3: save OK: read from Octave. load crash // https://gitlab.com/scilab/scilab/-/issues/15731

// Booleans
// ========
bs = abs(ds)<25
bv = abs(dv)<25
bm = abs(dm)<25
bh = abs(dh)<25

// Booleans sparse
// ---------------
// Not supported by the versions 6, 7, 7.3.
spbs = sparse(bs);
spbv = sparse(bv);
spbm = sparse(bm);
// v4: Saved as sparse doubles 0|1 (read from Octave)

// Encoded integers
// ================
// Supported in versions 6, 7 and 7.3, NOT in 4
// int8 uint8
int8s = int8(ds);
int8v = int8(dv);
int8m = int8(dm);
int8h = int8(dh);
uint8s = uint8(abs(ds));
uint8v = uint8(abs(dv));
uint8m = uint8(abs(dm));
uint8h = uint8(abs(dh));

// int16 uint16
int16s = int16(ds);
int16v = int16(dv);
int16m = int16(dm);
int16h = int16(dh);
uint16s = uint16(abs(ds));
uint16v = uint16(abs(dv));
uint16m = uint16(abs(dm));
uint16h = uint16(abs(dh));

// int32 uint32
int32s = int32(ds);
int32v = int32(dv);
int32m = int32(dm);
int32h = int32(dh);
uint32s = uint32(abs(ds));
uint32v = uint32(abs(dv));
uint32m = uint32(abs(dm));
uint32h = uint32(abs(dh));

// int64 uint64
int64s = int64(ds);
int64v = int64(dv);
int64m = int64(dm);
int64h = int64(dh);
uint64s = uint64(abs(ds));
uint64v = uint64(abs(dv));
uint64m = uint64(abs(dm));
uint64h = uint64(abs(dh));

// TEXT
// ====
EmptyStr = "";
ts = "Bonjour";
tv = ["a" "bc" "def" "ghij"];
tm = ["a" "bc" "def" ; "ghij" "klm" "no"];
th = cat(3,tv,tv);
// v4: row, matrix, hypermatrix => column (right-padded with spaces)
// TODO: Add tests with UTF8
// Issues for Text columns in v7: https://gitlab.com/scilab/scilab/-/issues/15569

// CELLS ARRAYS
// ============
EmptyC = {};
ces = {rand(2,3)};
cev = { "ABC", rand(1,3,2), bs};
cem = {1.1, int8(-5), bv; rand(10,10), "abc", bv};
ceh = cat(3,cev, cev);
ceNested = {cev, cem};
ceWithSparse = {1.1, int8(-5); sprand(10,10,0.1), "abc"};
// v4: not accepted
// v6,7,7.3: save/load OK (Scilab & read from Octave)(Octave does not read 7.3)

// STRUCTURES
// ==========
// v4  not accepted
s0 = struct();
s0f.r = struct();
ss.r = %pi;             // Scalar structure
sv(1,2).r = rand(1,3);  // Vector of structures
sm(2,3).r = %e;         // Matrix of structures
sm(2,3).bm = bm;        // With booleans
struc = struct("age",30, "type","software");
// TODO: add more complex cases
// Case from https://gitlab.com/scilab/scilab/-/issues/6372 : only with v7.3
savgg_mes.x_values = struct("quantity", struct("label","Hz"), ..
                           "values", [], ..
                           "start_value", 1, ..
                           "increment", 4, ..
                           "number_of_values", 125);
savgg_mes.y_values = savgg_mes.x_values;
savgg_mes.function_record = struct("r",%pi);
//
structS = struct('f1', 10, 'ftwo', 'Hello', 'field3', int8(12));
structRow = struct('field1', 10, 'field2', 'Hello', 'field3', int8(12));
structRow(1,2).field1 = 'test';
structRow(1,2).field2 = eye(10, 10);
structRow(1,3).field2 = 'a f*%ield contents';
structRow(1,3).field3 = 1.23+4.56*%i;
structCol = structRow';
structMat = struct('field1', 10, 'field2', 'Hello', 'field3', int8(12));
structMat(1,2).field1 = 'test';
structMat(1,2).field2 = eye(10, 10);
structMat(1,3).field2 = 'a field contents';
structMat(1,3).field3 = 1.23+4.56*%i;
structMat(2,1).name = 'test';
structMat(2,1).phone = eye(10, 10);
structMat(3,1).phone = 'a field contents';
structMat(3,1).address = 1.23+4.56*%i;


// ===============================================================
// Collects names of all defined variables
varnames = who_user(%f);
// Remove unwished variables coming from the processing
varnames(grep(varnames,"/^"+["i"]+"$/","r")) = [];
// Start tests from a given name (to shorten)
//varnames(strcmp(varnames, "tv")<0) = [];

File = TMPDIR + "/tmp.mat";
ver = ["-v4" "-v6" "-v7" "-v7.3"];
// List of known problems ==> skipped
pbs = [ "s0"       "*"        // crash for all versions
        "s0f"      "*"        // crash for all versions
        "ceWithSparse" "*"    // loadmatfile bug https://gitlab.com/scilab/scilab/-/issues/15731
        "int64m"   "*"        // No int64 support in Scilab
        "int64s"   "*"        // No int64 support in Scilab
        "int64v"   "*"        // No int64 support in Scilab
        "th"       "-v4"      // Saved _or_ loaded as a column vector instead of row
        "th"       "-v6"      // GetCharMatVar: 2D array of strings saving is not implemented.
        "th"       "-v7"      // GetCharMatVar: 2D array of strings saving is not implemented.
        "th"       "-v7.3"    // GetCharMatVar: 2D array of strings saving is not implemented.
        "tm"       "-v6"      // GetCharMatVar: 2D array of strings saving is not implemented.
        "tm"       "-v7"      // GetCharMatVar: 2D array of strings saving is not implemented.
        "tm"       "-v7.3"    // GetCharMatVar: 2D array of strings saving is not implemented.
        "tv"       "-v6"      // GetCharMatVar: Row array of strings saving is not implemented.
        "tv"       "-v7"      // GetCharMatVar: Row array of strings saving is not implemented.
        "tv"       "-v7.3"    // GetCharMatVar: Row array of strings saving is not implemented.
        "ts"       "-v7.3"    // Only first char is loaded (ts = "B" after loadmatfile)
        "spbm"     "*"        // Random issues: wrong number of non-zero values and/or wrong index for non-zeros values.
      ];
// Cases with exclusive versions to be tested
only = [];

for n = varnames'
    onlyVersion = only(find(only(:,1)==n),2);
    for v = ver
        execstr("t=type("+n+"); to=typeof("+n+");")
        if or(t==[13 130])  // functions not supported
            break
        end
        
        mprintf("\n%s %s",n,v);

        if ((t==8 | to=="ce"| to=="st") &  v=="-v4") | ..// Integers, cells, structs only in version >= 6
            t==6 & v~="-v4" | ..       // Sparse boolean (only with v4)
            (onlyVersion~=[] & onlyVersion~=v)
            mprintf(" : Not supported");
            continue
        else
            if vectorfind(pbs, [n "*"])~=[] | vectorfind(pbs, [n v])~=[]
                mprintf(" : Not fixed");
                continue
            end
        end

        ierr = execstr("savematfile(File, v, n);","errcatch");
        assert_checkequal(ierr,0);

        if t==5                  // Sparse
            execstr("r=isreal("+n+");");
            if ~r | v=="-v4"
                continue
            end
        end

        execstr("ref = "+n+";"); // Keep initial value to compare to loaded one
        clear(n);
        loadmatfile(File);
        err = execstr("assert_checktrue(isdef(n,""l""));", "errcatch");
        if err
            disp(["-------" n v]);
            continue
        end
        
        if t==6        // Sparse boolean
            execstr("assert_checkequal(nnz("+n+"), nnz(ref));"); // Check non-zeros values to be sure there are no fake values
            execstr("assert_checkequal("+n+", bool2s(ref));");
        elseif t==10   // String
            execstr("assert_checkequal("+n+", justify(ref(:),''l''));");
        else
            if v=="-v4" then // manage specific case for -v4 format
                v4ref = ref;
                v4refsize = size(v4ref);
                if length(v4refsize) > 2 then  // In -v4 format, only first plan of N-D arrays is saved (only 2-D arrays managed in -v4 format)
                    v4ref = matrix(v4ref,v4refsize(1),-1);
                    v4ref = v4ref(1:prod(v4refsize(1:2)));
                end
                if t==4 then // Booleans saved as -v4 are saved as double and reloaded as double too (no logical flag in V4 format)
                    execstr("assert_checkequal("+n+", bool2s(v4ref))");
                else
                    execstr("assert_checkequal("+n+", v4ref)");
                end
            else
                if t==4 then
                    execstr("assert_checkequal(nnz("+n+"), nnz(ref));"); // Check non-zeros values to be sure there are no fake values
                end
                execstr("assert_checkequal("+n+", ref)");
            end
        end

        execstr(n+"=ref;"); // Restore initial value (in case load failed and it was not detected above, which should not happen if this checks are well written)
    end
end
