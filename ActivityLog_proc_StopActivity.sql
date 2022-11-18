-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [StopActivity]
    @logId INT,
    @stoppedAt DATETIME2
AS
BEGIN
    IF @logId IS NULL OR NOT EXISTS (SELECT [Id] FROM [ActivityLog] WHERE [Id] = @logId)
        RAISERROR('Passed NULL value for @logId or given project doesn`t exist', 16, 1);

    IF @stoppedAt IS NULL
        SET @stoppedAt = SYSDATETIME();

    UPDATE [ActivityLog]
    SET [WorkedTo] = @stoppedAt
    WHERE [Id] = @logId;
END;