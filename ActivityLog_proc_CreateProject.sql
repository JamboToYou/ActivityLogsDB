-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [CreateProject]
    @title NVARCHAR(1024),
    @isExternal BIT = 0,
    @approvedToExecFrom TIME(0),
    @approvedToExecTo TIME(0)
AS
BEGIN
    IF @isExternal = 1 AND (@approvedToExecFrom IS NULL OR @approvedToExecTo IS NULL)
        RAISERROR('Time range is required for external projects', 16, 1);

    INSERT INTO [Project]([Title], [IsExternal], [ApprovedToExecFrom], [ApprovedToExecTo])
        OUTPUT INSERTED.[Id]
        VALUES(@title, @isExternal, @approvedToExecFrom, @approvedToExecTo);
END;