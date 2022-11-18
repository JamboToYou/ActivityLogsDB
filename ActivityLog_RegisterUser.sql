-- USE [ActivityLogsDB];

CREATE OR ALTER PROCEDURE RegisterEmployee
    @username INT,
    @departmentId INT,
    @gradeId INT
AS
BEGIN
    INSERT INTO [Employee]([Username], [DepartmentId], [GradeId]) OUTPUT INSERTED.[Id] VALUES(@username, @departmentId, @gradeId);
END;