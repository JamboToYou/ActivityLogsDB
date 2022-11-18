-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [AddDepartment]
    @depName NVARCHAR(255),
    @depHeadId INT,
    @depId INT OUTPUT
AS
BEGIN
    IF NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @depHeadId)
    BEGIN
        RAISERROR('User doesn`t exist', 16, 1);
        RETURN -1;
    END;

    DECLARE @newId TABLE ([Id] INT NOT NULL);

    INSERT INTO [Department]([Name], [DepartmentHeadId])
    OUTPUT INSERTED.[Id] INTO @newId
    VALUES(@depName, @depHeadId);

    SET @depId = (SELECT [Id] FROM @newId);
END;