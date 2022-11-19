USE [ActivityLogsDB];

DECLARE @pm_ivanov INT = (SELECT [Id] FROM [Employee] WHERE [Username] = 'i.ivanov');
DECLARE @p_int_stage1 INT = (SELECT [Id] FROM [ProjectStage] WHERE [Title] = 'Internal project stage 1');

DECLARE @dt1 DATETIME2 = CONVERT(DATETIME2, N'2022-10-01 08:00:00');
DECLARE @dt2 DATETIME2 = CONVERT(DATETIME2, N'2022-10-01 10:00:00');
DECLARE @dt3 DATETIME2 = CONVERT(DATETIME2, N'2022-10-01 15:00:00');
DECLARE @dt4 DATETIME2 = CONVERT(DATETIME2, N'2022-10-01 20:00:00');

EXEC LogActivity @pm_ivanov, NULL, @p_int_stage1, @dt1, @dt2, NULL;
-- EXEC LogActivity @pm_ivanov, NULL, @p_int_stage1, @dt2, @dt3, NULL;s
-- EXEC LogActivisty @pm_ivanov, NULL, @p_int_stage1, @dt3, @dt4, NULL;

SELECT
    [Id],
    [EmployeeId],
    [ProjectStageId],
    [WorkedFrom],
    [WorkedTo]
FROM [ActivityLog];