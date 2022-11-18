-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [RegisterEmployee]
    @username NVARCHAR(255),
    @departmentId INT,
    @gradeId INT,
    @employeeId INT OUTPUT
AS
BEGIN
    IF @gradeId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Grade] WHERE [Id] = @gradeId)
    BEGIN
        RAISERROR('Passed NULL value for @gradeId or given grade doesn`t exist', 16, 1);
        RETURN -1;
    END;

    IF @departmentId IS NOT NULL AND NOT EXISTS (SELECT [Id] FROM [Department] WHERE [Id] = @departmentId)
    BEGIN
        RAISERROR('Given department doesn`t exist', 16, 1);
        RETURN -1;
    END;

    DECLARE @newId TABLE([Id] INT NOT NULL);

    INSERT INTO [Employee]([Username], [DepartmentId], [GradeId])
    OUTPUT INSERTED.[Id] INTO @newId
    VALUES(@username, @departmentId, @gradeId);

    SET @employeeId = (SELECT [Id] FROM @newId);
END;