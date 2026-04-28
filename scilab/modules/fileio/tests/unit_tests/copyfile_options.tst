// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->
// <-- NO CHECK REF -->
// <-- LINUX ONLY --> On windows, depending on the OS/permission this might not pass

//
// copyfile() have an option argument to copy or preserve symlink
//


// use a clean testing directory
if isdir("TMPDIR/copyfile_options") then removedir("TMPDIR/copyfile_options"); end
assert_checktrue(createdir("TMPDIR/copyfile_options"));

// helper function to create symbolic links
function create_symbolic_link(target, link_name)
    target = pathconvert(target, %f);
    link_name = pathconvert(link_name, %f);

    if getos() == "Windows" then
        if isdir(target) then
            status = host("mklink /D " + link_name + " " + target);
        else
            status = host("mklink " + link_name + " " + target);
        end
    else
        status = host("ln -s " + target + " " + link_name);
    end
    
    if status <> 0 then
        error("Failed to create symbolic link from " + target + " to " + link_name);
    end
endfunction

// helper function to assert a symbolic link, eg. both file are the same
function assert_check_symbolic_link(src, dest)
    fi = fileinfo([src dest]);
    assert_checkequal(fi(1,:), fi(2,:))
endfunction

// directory
d = "TMPDIR/copyfile_options/d";
createdir(d)

// file
f = "TMPDIR/copyfile_options/f.txt";
mputl("this is a file", f)

// file in directory
fd = "TMPDIR/copyfile_options/d/f.txt";
mputl("this is a file", fd)


// symbolic links are created
dl = "TMPDIR/copyfile_options/dl";
create_symbolic_link(d, dl);
fl = "TMPDIR/copyfile_options/fl.txt";
create_symbolic_link(f, fl);
assert_check_symbolic_link(f, fl);
d_fl = d + "/fl_link.txt"
create_symbolic_link("../fl.txt", d_fl);
assert_check_symbolic_link(d_fl, fl);

// TMPDIR
// │   f.txt
// │   fl.txt  [ -> TMPDIR/copyfile_options/f.txt ]
// │
// ├───d
// │       f.txt
// │       fl_link.txt  [ -> ../f.txt ]
// │
// └───dl  [ -> TMPDIR/copyfile_options/d ]
//         f.txt
//         fl_link.txt  [ -> ../f.txt ]


// copy links without options will copy the content
copied_fl = "TMPDIR/copyfile_options/fl_copy.txt"
copied_d = "TMPDIR/copyfile_options/d_copy"
copied_dl = "TMPDIR/copyfile_options/dl_copy"

copyfile(fl, copied_fl)
if ~isfile(copied_fl) then pause, end
deletefile(copied_fl)

copyfile(dl, copied_dl)
if ~isdir(copied_dl) then pause, end
if ~isfile(copied_dl + "/f.txt") then pause, end
if ~isfile(copied_dl + "/fl_link.txt") then pause, end
rmdir(copied_dl)


// copy links "resolve" will copy the content
copied_fl = "TMPDIR/copyfile_options/fl_copy.txt"
copied_dl = "TMPDIR/copyfile_options/dl_copy"

copyfile(fl, copied_fl, "resolve")
if ~isfile(copied_fl) then pause, end
deletefile(copied_fl)

copyfile(dl, copied_dl, "resolve")
if ~isdir(copied_dl) then pause, end
if ~isfile(copied_dl + "/f.txt") then pause, end
if ~isfile(copied_dl + "/fl_link.txt") then pause, end
rmdir(copied_dl)

copyfile(d, copied_d, "resolve")
if ~isdir(copied_d) then pause, end
if ~isfile(copied_d + "/f.txt") then pause, end
if ~isfile(copied_d + "/fl_link.txt") then pause, end
rmdir(copied_d)


// copy links "preserve" will keep symbolic links
copied_fl = "TMPDIR/copyfile_options/fl_copy.txt"
copied_d = "TMPDIR/copyfile_options/d_copy"
copied_dl = "TMPDIR/copyfile_options/dl_copy"

copyfile(fl, copied_fl, "preserve")
if ~isfile(copied_fl) then pause, end
deletefile(copied_fl)

copyfile(dl, copied_dl, "preserve")
if ~isdir(copied_dl) then pause, end
if ~isfile(copied_dl + "/f.txt") then pause, end
if ~isfile(copied_dl + "/fl_link.txt") then pause, end
rmdir(copied_dl)

copyfile(d, copied_d, "preserve")
if ~isdir(copied_d) then pause, end
if ~isfile(copied_d + "/f.txt") then pause, end
if ~isfile(copied_d + "/fl_link.txt") then pause, end
rmdir(copied_d)
