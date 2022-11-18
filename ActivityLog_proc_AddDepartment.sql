-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE AddDepartment
    @depName NVARCHAR(255),
    @depHeadId INT
AS
BEGIN
    IF NOT EXISTS (SELECT [Id] FROM [Employee] WHERE [Id] = @depHeadId)
        RAISERROR('User doesn`t exist', 16, 1);

    INSERT INTO [Department]([Name]) OUTPUT INSERTED.[Id] VALUES(@depName);
END;