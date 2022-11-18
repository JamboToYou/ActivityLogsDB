echo "Initializing database schema. . ."
sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i .\ActivityLog_init.sql

$procScripts = Get-Childitem .\ActivityLog_proc_*.sql

echo "Initializing stored procedures. . ."
foreach ($procScript in $procScripts)
{
    $procNameStr = Select-String `
        -Path $procScript `
        -Pattern "CREATE OR ALTER PROCEDURE ([a-zA-Z_0-9\[\]]*)" | `
            % { $_.Matches } | % { $_.Value }
    $procName = $procNameStr.ToString().Substring(26, $procNameStr.Length - 26)

    echo "Initializing procedure ""$procName"". . ."
    sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i $procScript
}
echo "Initializing stored procedures completed."

echo "Seeding database. . ."
sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i .\ActivityLog_seed_test.sql > NULL
echo "Seeding done."