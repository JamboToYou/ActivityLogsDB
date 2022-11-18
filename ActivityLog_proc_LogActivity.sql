-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [LogActivity]
    @employeeId INT,
    @message NVARCHAR(2048),
    @projectStageId INT,
    @from DATETIME2,
    @to DATETIME2
AS
BEGIN
    IF @projectStageId IS NULL OR NOT EXISTS (SELECT [Id] FROM [ProjectStage] WHERE [Id] = @projectStageId)
        RAISERROR('Passed NULL value for @projectStageId or given project doesn`t exist', 16, 1);

    IF @employeeId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @employeeId)
        RAISERROR('Passed NULL value for @employeeId or given project doesn`t exist', 16, 1);

    IF @from IS NULL OR @to IS NULL
        RAISERROR('Working time range must be specified', 16, 1);

    INSERT INTO [ActivityLog]([EmployeeId], [Message], [ProjectStageId], [WorkedFrom], [WorkedTo])
    OUTPUT INSERTED.[Id]
    VALUES(@employeeId, @message, @projectStageId, @from, @to);
END;