-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [StartActivity]
    @employeeId INT,
    @projectStageId INT,
    @startedAt DATETIME2,
    @logId INT OUTPUT 
AS
BEGIN
    IF @projectStageId IS NULL OR NOT EXISTS (SELECT [Id] FROM [ProjectStage] WHERE [Id] = @projectStageId)
    BEGIN
        RAISERROR('Passed NULL value for @projectStageId or given project stage doesn`t exist', 16, 1);
        RETURN -1;
    END;

    IF @employeeId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @employeeId)
    BEGIN
        RAISERROR('Passed NULL value for @employeeId or given employee doesn`t exist', 16, 1);
        RETURN -1;
    END;

    IF @startedAt IS NULL
        SET @startedAt = SYSDATETIME();

    DECLARE @newId TABLE([Id] INT NOT NULL);

    INSERT INTO [ActivityLog]([EmployeeId], [ProjectStageId], [WorkedFrom])
    OUTPUT INSERTED.[Id] INTO @newId
    VALUES(@employeeId, @projectStageId, @startedAt);

    SET @logId = (SELECT [Id] FROM @newId);
END;