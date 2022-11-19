-- USE [ActivityLogsDB];

CREATE OR ALTER TRIGGER [TGR_DailyLogLimtitation]
ON [ActivityLog]
AFTER INSERT
AS
BEGIN
    SET XACT_ABORT OFF;

    DECLARE @diffs TABLE ([Diff] INT NOT NULL);

    DECLARE @employeeId INT = (SELECT TOP 1 [EmployeeId] FROM INSERTED);
    DECLARE @workedFrom DATETIME2 = (SELECT TOP 1 [WorkedFrom] FROM INSERTED);
    DECLARE @workedTo DATETIME2 = (SELECT TOP 1 [WorkedTo] FROM INSERTED);

    INSERT INTO @diffs([Diff]) 
    (
        SELECT DATEDIFF(HOUR, [WorkedFrom], [WorkedTo]) AS [Diff]
        FROM [ActivityLog]
        WHERE
            [EmployeeId] = @employeeId AND
            [WorkedFrom] IS NOT NULL AND
            [WorkedTo] IS NOT NULL AND
            YEAR([WorkedFrom]) = YEAR(@workedFrom) AND
            MONTH([WorkedFrom]) = MONTH(@workedFrom) AND
            DAY([WorkedFrom]) = DAY(@workedFrom)
    );

    DECLARE @diff INT = (SELECT SUM([Diff]) FROM @diffs);
    DECLARE @newDiff INT = DATEDIFF(HOUR, @workedFrom, @workedTo);

    IF @diff + @newDiff > 10
    BEGIN
        RAISERROR('Working more than 10 hours per day is restricted', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;