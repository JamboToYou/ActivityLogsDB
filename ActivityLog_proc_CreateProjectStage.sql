-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [CreateProjectStage]
    @title NVARCHAR(1024),
    @description NVARCHAR(2048),
    @order INT,
    @projectId INT,
    @stageId INT OUTPUT,
    @orderOut INT OUTPUT
AS
BEGIN
    IF @projectId IS NULL OR NOT EXISTS (SELECT [Id] FROM [Project] WHERE [Id] = @projectId)
    BEGIN
        RAISERROR('Passed NULL value for @projectId or given project doesn`t exist', 16, 1);
        RETURN -1;
    END;

    IF @title IS NULL
    BEGIN
        RAISERROR('Title must be specified', 16, 1);
        RETURN -1;
    END;

    DECLARE @newOrder INT = @order;

    IF @newOrder IS NULL
    BEGIN
        DECLARE @lastOrder INT =
        (
            SELECT TOP 1 [Order]
            FROM [ProjectStage]
            WHERE [ProjectId] = @projectId
            ORDER BY [Order] DESC
        );

        IF @lastOrder IS NULL
            SET @newOrder = 10;
        ELSE
            SET @newOrder = @lastOrder + 10;
    END;

    DECLARE @newId TABLE ([Id] INT NOT NULL);

    INSERT INTO [ProjectStage]([Title], [Description], [Order], [ProjectId])
    OUTPUT INSERTED.[Id] INTO @newId
    VALUES(@title, @description, @newOrder, @projectId);

    SET @stageId = (SELECT [Id] FROM @newId);
    SET @orderOut = @newOrder;
END;