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


$triggers = Get-Childitem .\ActivityLog_trigger_*.sql
echo "Initializing triggers. . ."
foreach ($trigger in $triggers)
{
    $triggerNameStr = Select-String `
        -Path $trigger `
        -Pattern "CREATE OR ALTER TRIGGER ([a-zA-Z_0-9\[\]]*)" | `
            % { $_.Matches } | % { $_.Value }
    $triggerName = $triggerNameStr.ToString().Substring(26, $triggerNameStr.Length - 26)

    echo "Initializing trigger ""$triggerName"". . ."
    sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i $trigger
}
echo "Initializing triggers completed."


echo "Seeding database. . ."
sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i .\ActivityLog_seed.sql | out-null
echo "Seeding done."


echo "Running tests. . ."
sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i .\ActivityLog_test.sql
echo "Tests done."