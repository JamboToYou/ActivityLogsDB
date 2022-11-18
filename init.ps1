sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i .\ActivityLog_init.sql

$procScripts = Get-Childitem .\ActivityLog_proc_*.sql

foreach ($procScript in $procScripts)
{
    sqlcmd -S "(localdb)\mssqllocaldb" -d ActivityLogsDB -i $procScript
}