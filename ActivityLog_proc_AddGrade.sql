-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [AddGrade]
    @gradeTitle NVARCHAR(255)
AS
BEGIN
    INSERT INTO [Grade]([Title]) OUTPUT INSERTED.[Id] VALUES(@gradeTitle);
END;