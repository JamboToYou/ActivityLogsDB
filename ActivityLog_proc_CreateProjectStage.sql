-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [CreateProjectStage]
    @title NVARCHAR(1024),
    @description NVARCHAR(2048),
    @order INT,
    @projectId INT
AS
BEGIN
    IF @projectId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Project] WHERE [Id] = @projectId)
        RAISERROR('Passed NULL value for @projectId or given project doesn`t exist', 16, 1);

    IF @title IS NULL
        RAISERROR('Title must be specified', 16, 1);

    DECLARE @newOrder INT = @order;

    IF @newOrder IS NULL
    BEGIN
        DECLARE @lastOrder INT = (SELECT TOP 1 [Order] FROM [ProjectStage] WHERE [Id] = @projectId ORDER BY [Order] DESC);

        IF @lastOrder IS NULL
            SET @newOrder = 1;
        ELSE
            SET @newOrder = @lastOrder + 10;
    END;

    INSERT INTO [ProjectStage]([Title], [Description], [Order], [ProjectId])
        OUTPUT INSERTED.[Id]
        VALUES(@title, @description, @newOrder, @projectId);
END;