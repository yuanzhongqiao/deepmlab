function res = atomsBuild(path)
    res = %f;
    if isfile(fullfile(path, "builder.sce"))
        ierr = exec(fullfile(path, "builder.sce"), "errcatch", -1);
        if ierr == 0 then
            res = %t;
        end
    end
endfunction