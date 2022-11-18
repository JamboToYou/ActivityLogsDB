-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE [AddGrade]
    @gradeTitle NVARCHAR(255),
    @gradeId INT OUTPUT
AS
BEGIN
    DECLARE @newId TABLE([Id] INT NOT NULL);

    INSERT INTO [Grade]([Title])
    OUTPUT INSERTED.[Id] INTO @newId
    VALUES(@gradeTitle);

    SET @gradeId = (SELECT [Id] FROM @newId)
END;