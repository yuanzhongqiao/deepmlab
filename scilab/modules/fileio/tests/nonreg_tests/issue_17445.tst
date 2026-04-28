// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- LINUX ONLY --> On windows, depending on the OS/permission this might not pass

// <-- Non-regression test for issue 17445 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17445
//
// <-- Short Description -->
// tbx_package and copyfile does not preserve symbolic links


// use a clean testing directory
if isdir("TMPDIR/issue_17445") then removedir("TMPDIR/issue_17445", "s"); end
assert_checktrue(createdir("TMPDIR/issue_17445"));

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

txt = "this is file content";
mputl(txt, "TMPDIR/issue_17445/dest_file.txt");
create_symbolic_link("dest_file.txt", "TMPDIR/issue_17445/link.txt");

// check the content is the same
assert_checkequal(mgetl("TMPDIR/issue_17445/dest_file.txt"), txt);
assert_checkequal(mgetl("TMPDIR/issue_17445/link.txt"), txt);

// copy archive the link and check its content
[st, msg] = copyfile("TMPDIR/issue_17445/link.txt", "TMPDIR/issue_17445/copied_link.txt", "preserve");
if (getos() == "Windows" && st == 0) then
    // symbolic link should be handled but this might not be the case depending on user permission
    // alternative implementation might parse the REPARSE_POINT data
    warning("skipped: no symbolic link support")
    disp(st, msg)
    exit(0);    
end
assert_checkequal(mgetl("TMPDIR/issue_17445/copied_link.txt"), txt);
listing = gsort(ls("TMPDIR/issue_17445/*"))
with_valid_links = fileinfo(listing)

// move the original link, will break symbolic links
movefile("TMPDIR/issue_17445/dest_file.txt", "TMPDIR/issue_17445/dest_file_moved.txt");
listing = gsort(ls("TMPDIR/issue_17445/*"))
with_invalid_links = fileinfo(listing)

// there was valid links (pointing to the same file)
assert_checkequal(diff(with_valid_links, 1, 'r'), zeros(2,13));
assert_checkequal(sum(isnan(with_valid_links(:,1))), 0);
// movefile() break them
assert_checkequal(sum(isnan(with_invalid_links(:,1))), 2);
