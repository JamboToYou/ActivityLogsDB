-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [ApplyEmpToDep]
    @employeeId INT,
    @depId INT
AS
BEGIN
    IF @depId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Department] WHERE [Id] = @depId)
    BEGIN
        RAISERROR('Passed NULL value for @depId or given department stage doesn`t exist', 16, 1);
        RETURN -1;
    END;

    IF @employeeId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @employeeId)
    BEGIN
        RAISERROR('Passed NULL value for @employeeId or given employee doesn`t exist', 16, 1);
        RETURN -1;
    END;

    UPDATE [Employee]
    SET [DepartmentId] = @depId
    WHERE [Id] = @employeeId;
END;