// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2025 - Dassault Systèmes S.E. - Cédric DELAMARRE
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17473 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
// <-- WINDOWS ONLY -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17473
//
// <-- Short Description -->
// Under Windows, background launch of Scilab creates zombies

function pids = launchScilex()
    script = fullfile(TMPDIR,"test.sce");
    cmd = "powershell -Command """"$p = Start-Process \"""""+SCI+"\bin\Scilex.exe\"""" -ArgumentList \""""-quit\"""",\""""-nb\"""",\""""-e\"""",\""""a=1;\"""" -PassThru -NoNewWindow; write-host $p.Id"""""
    mputl(sprintf("host(""%s"")",cmd),script)
    cmd2 = "powershell -Command ""$pp = Start-Process \"""+SCI+"\bin\Scilex.exe\"" -ArgumentList \""-quit\"",\""-nb\"",\""-f\"",\"""+script+"\"" -PassThru -NoNewWindow; Write-Output $pp.Id""";
    [status, pids, err] = host(cmd2)
    assert_checkequal(status, 0);
endfunction

pids=[];
for i=1:10
    pids = [pids; launchScilex()];
end

for pid=pids'
    cmd = "powershell -Command ""$p = Get-Process -Id "+pid+" -ErrorAction SilentlyContinue; if ($p -and $p.ProcessName -eq \""Scilex\"") { Write-Output 1 } else { Write-Output 0 }""";
    [status, out, err] = host(cmd);
    assert_checkequal(status, 0);
    assert_checkfalse(out == "1");
end
