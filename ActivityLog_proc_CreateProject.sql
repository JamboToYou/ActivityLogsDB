-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [CreateProject]
    @title NVARCHAR(1024),
    @isExternal BIT = 0,
    @approvedToExecFrom TIME(0),
    @approvedToExecTo TIME(0),
    @projectId INT OUTPUT
AS
BEGIN
    IF @isExternal = 1 AND (@approvedToExecFrom IS NULL OR @approvedToExecTo IS NULL)
    BEGIN
        RAISERROR('Time range is required for external projects', 16, 1);
        RETURN -1;
    END;

    DECLARE @newId TABLE([Id] INT NOT NULL);

    INSERT INTO [Project]([Title], [IsExternal], [ApprovedToExecFrom], [ApprovedToExecTo])
    OUTPUT INSERTED.[Id] INTO @newId
    VALUES(@title, @isExternal, @approvedToExecFrom, @approvedToExecTo);

    SET @projectId = (SELECT [Id] FROM @newId);
END;