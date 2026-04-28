//
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2022 - UTC - Stéphane MOTTELET
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// For more information, see the COPYING file which you should have received
//
//--------------------------------------------------------------------------

function testHessBoeing(filename)
    function y=f(x,p)
    end
    url = "https://math.nist.gov/pub/MatrixMarket2/Harwell-Boeing/smtape/"+filename+".gz";
    localfile = fullfile(TMPDIR,filename+".gz");
    [result, status] = http_get(url,localfile,cert="none");
    // Extract It
    // ----------------------------------------
    if getos() <> "Windows"
        extract_cmd = "gunzip -f "+ localfile;
    else
        gzip_path = getshortpathname(fullpath(pathconvert(SCI+"/tools/gzip/gzip.exe",%F)));
        if ~isfile(gzip_path) then
            error(msprintf(gettext("%s: gzip not found.\n"), "testJacBoeing"));
        end
        extract_cmd = """" + gzip_path + """" + " -f -d """ + localfile + """";
    end
    [stat, _ ,err] = host(extract_cmd);
    if stat ~= 0 then
        disp(err);
        error(msprintf(gettext("%s: Extraction of (''%s'') has failed.\n"),"testJacBoeing",localfile));
    end

    [sp,description,ref,mtype] = ReadHBSparse(fullfile(TMPDIR,filename));
    ij = spget(sp);

    // get computation engine

    hessian = spCompHessian(f,sp);
    col = hessian.colors;

    drawlater
    clf;
    gcf().axes_size = [755,377]
    gcf().figure_name = url;
    k = unique(col,"keepOrder");
    gcf().color_map = parula(max(k))
    delete(gcf().children)

    subplot(1,2,1)
    spyCol(sp,col)
    title(msprintf("Colored (%d x %d) Hessian\n%d colors",size(sp,1),size(sp,2),max(k)))

    subplot(1,4,3)
    compMat = sparse([ij(:,1) col(ij(:,2))],ones(ij(:,1)));
    spyCol(compMat(:,k),k)
    title("Compressed Hessian")

    subplot(1,4,4)
    spyCol(hessian.seed,1:size(hessian.seed,2))
    title("Seed matrix")
    drawnow
endfunction
