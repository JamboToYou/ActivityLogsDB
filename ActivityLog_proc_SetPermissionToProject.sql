-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [SetPermissionToProject]
    @projectId INT,
    @employeeId INT,
    @permissionId INT OUTPUT
AS
BEGIN
    IF @projectId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Project] WHERE [Id] = @projectId)
    BEGIN
        RAISERROR('Passed NULL value for @projectId or given project doesn`t exist', 16, 1);
        RETURN -1;
    END;

    IF @employeeId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @employeeId)
    BEGIN
        RAISERROR('Passed NULL value for @employeeId or given employee doesn`t exist', 16, 1);
        RETURN -1;
    END;

    IF EXISTS (SELECT [Id] FROM [Permission] WHERE [ProjectId] != NULL)
    BEGIN
        PRINT('Employee already has permission to this project');
        RETURN;
    END;
    ELSE
    BEGIN
        DECLARE @newId TABLE([Id] INT NOT NULL);

        INSERT INTO [Permission]([ProjectId], [EmployeeId])
        OUTPUT INSERTED.[Id] INTO @newId
        VALUES(@projectId, @employeeId);
        
        SET @permissionId = (SELECT [Id] FROM @newId);
    END;
END;