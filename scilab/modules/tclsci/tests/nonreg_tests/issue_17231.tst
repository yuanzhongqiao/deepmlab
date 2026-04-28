// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes S.E. - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17231 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17231
//
// <-- Short Description -->
// TCLsci failed to load due to permissions issues


// check file permissions
p="SCI/modules/tclsci";

all = [];
while size(p, 1) > 0
    next = [];
    for pp = p';
        listed = findfiles(pp);
        if listed == [] then 
            all = [all ; pp];
            continue;
        end
        
        full_listed = pp + "/" + listed;
        dir_mask = isdir(full_listed);
        file_mask = isfile(full_listed);

        all = [all ; pp ; full_listed(file_mask)];
        next = [next ; full_listed(dir_mask)];
    end
    p = next;
end

computed = dec2oct(fileinfo(all)(:,[2]));

expected = [];
// generic file permissions
select getos()
case "Windows" then
    dir_perms = "40777";
    file_perms = "100666";
else
    dir_perms = "40755";
    file_perms = "100644";
end
expected(isdir(all)) = dir_perms;
expected(isfile(all)) = file_perms;

// custom files
select getos()
case "Windows" then
    expected(grep(all, '.tcl')) = "100666";
else
    expected(grep(all, '.tcl')) = "100755";
end

select getos()
case "Windows" then
    expected(grep(all, '.bat')) = "100777";
else
    expected(grep(all, '.so')) = "100755";
end

invalid = computed <> expected;
disp("invalid permission on " + all(invalid) + " , computed " + computed(invalid) + " , expected " + expected(invalid));
assert_checkfalse(invalid)
