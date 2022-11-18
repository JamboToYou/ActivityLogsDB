-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [StartActivity]
    @employeeId INT,
    @projectStageId INT,
    @startedAt DATETIME2
AS
BEGIN
    IF @projectStageId IS NULL OR NOT EXISTS (SELECT [Id] FROM [ProjectStage] WHERE [Id] = @projectStageId)
        RAISERROR('Passed NULL value for @projectStageId or given project doesn`t exist', 16, 1);

    IF @employeeId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @employeeId)
        RAISERROR('Passed NULL value for @employeeId or given project doesn`t exist', 16, 1);

    IF @startedAt IS NULL
        SET @startedAt = SYSDATETIME();

    INSERT INTO [ActivityLog]([EmployeeId], [ProjectStageId], [WorkedFrom])
    OUTPUT INSERTED.[Id]
    VALUES(@employeeId, @projectStageId, @startedAt);
END;