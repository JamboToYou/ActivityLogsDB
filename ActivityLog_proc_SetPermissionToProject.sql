-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [SetPermissionToProject]
    @projectId INT,
    @employeeId INT
AS
BEGIN
    IF @projectId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Project] WHERE [Id] = @projectId)
        RAISERROR('Passed NULL value for @projectId or given project doesn`t exist', 16, 1);

    IF @employeeId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @employeeId)
        RAISERROR('Passed NULL value for @employeeId or given project doesn`t exist', 16, 1);

    IF EXISTS (SELECT [Id] FROM [Permission] WHERE [ProjectId] != NULL)
    BEGIN
        PRINT('Employee already has permission to this project');
        RETURN;
    END;
    ELSE
        INSERT INTO [Permission]([ProjectId], [EmployeeId])
        OUTPUT INSERTED.[Id]
        VALUES(@projectId, @employeeId);
END;