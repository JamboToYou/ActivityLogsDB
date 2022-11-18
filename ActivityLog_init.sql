-- DROP DATABASE [ActivityLogsDB];
-- CREATE DATABASE [ActivityLogsDB];

USE [ActivityLogsDB];

IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'Grade' AND TYPE = 'U')
BEGIN
    IF (OBJECT_ID('FK_Employee_Grade_EmpsGrade', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [Employee] DROP CONSTRAINT [FK_Employee_Grade_EmpsGrade];
    END;
    DROP TABLE [Grade];
END;
CREATE TABLE [Grade]
(
    [Id] INT IDENTITY(1, 1),
    [Title] NVARCHAR(255) NOT NULL,
    CONSTRAINT [PK_Grade] PRIMARY KEY ([Id])
);

IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'Employee' AND TYPE = 'U')
BEGIN
    IF (OBJECT_ID('FK_Department_Employee_DepHead', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [Department] DROP CONSTRAINT [FK_Department_Employee_DepHead];
    END;
    IF (OBJECT_ID('FK_Permission_Employee_EmpPerm', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [Permission] DROP CONSTRAINT [FK_Permission_Employee_EmpPerm];
    END;
    IF (OBJECT_ID('FK_ActivityLog_Employee_LogEmployee', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [ActivityLog] DROP CONSTRAINT [FK_ActivityLog_Employee_LogEmployee];
    END;
    DROP TABLE [Employee];
END;
CREATE TABLE [Employee]
(
    [Id] INT IDENTITY(1, 1),
    [Username] NVARCHAR(255) NOT NULL,
    [GradeId] INT NOT NULL,
    [DepartmentId] INT NOT NULL,
    CONSTRAINT [PK_Employee] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Employee_Grade_EmpsGrade] FOREIGN KEY ([GradeId]) REFERENCES [Grade]([Id])
);

IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'Department' AND TYPE = 'U')
BEGIN
    IF (OBJECT_ID('FK_Department_Employee_DepHead', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [Department] DROP CONSTRAINT [FK_Department_Employee_DepHead];
    END;
    DROP TABLE [Department];
END;
CREATE TABLE [Department]
(
    [Id] INT IDENTITY(1, 1),
    [Name] NVARCHAR(255),
    [DepartmentHeadId] INT NOT NULL,
    CONSTRAINT [PK_Department] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Department_Employee_DepHead] FOREIGN KEY ([DepartmentHeadId]) REFERENCES [Employee]([Id])
);

IF (OBJECT_ID('FK_Employee_Department_EmpDep', 'F') IS NOT NULL)
BEGIN
    ALTER TABLE [Employee] DROP CONSTRAINT [FK_Employee_Department_EmpDep];
END;
ALTER TABLE [Employee]
    ADD CONSTRAINT [FK_Employee_Department_EmpDep]
    FOREIGN KEY ([DepartmentId])
    REFERENCES [Department]([Id]);


IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'Project' AND TYPE = 'U')
BEGIN
    IF (OBJECT_ID('FK_Project_ProjectStage_ProjOfStage', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [ProjectStage] DROP CONSTRAINT [FK_Project_ProjectStage_ProjOfStage];
    END;
    IF (OBJECT_ID('FK_Permission_Project_ProjPerm', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [Permission] DROP CONSTRAINT [FK_Permission_Project_ProjPerm];
    END;
    DROP TABLE [Project];
END;
CREATE TABLE [Project]
(
    [Id] INT IDENTITY(1, 1),
    [Title] NVARCHAR(1024) NOT NULL,
    [IsExternal] BIT DEFAULT 0,
    [ApprovedToExecFrom] TIME(0),
    [ApprovedToExecTo] TIME(0),
    CONSTRAINT [PK_Project] PRIMARY KEY ([Id])
);

IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'ProjectStage' AND TYPE = 'U')
BEGIN
    IF (OBJECT_ID('FK_ActivityLog_ProjectStage_LogProjectStage', 'F') IS NOT NULL)
    BEGIN
        ALTER TABLE [ActivityLog] DROP CONSTRAINT [FK_ActivityLog_ProjectStage_LogProjectStage];
    END;
    DROP TABLE [ProjectStage];
END;
CREATE TABLE [ProjectStage]
(
    [Id] INT IDENTITY(1, 1),
    [Title] NVARCHAR(1024) NOT NULL,
    [Description] NVARCHAR(2048),
    [Order] INT NOT NULL,
    [ProjectId] INT NOT NULL,
    CONSTRAINT [PK_ProjectStage] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Project_ProjectStage_ProjOfStage] FOREIGN KEY ([ProjectId]) REFERENCES [Project]([Id]),

    UNIQUE([Order])
);

IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'Permission' AND TYPE = 'U')
BEGIN
    DROP TABLE [Permission];
END;
CREATE TABLE [Permission]
(
    [Id] INT IDENTITY(1, 1),
    [EmployeeId] INT NOT NULL,
    [ProjectId] INT,
    CONSTRAINT [PK_Permission] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_Permission_Employee_EmpPerm] FOREIGN KEY ([EmployeeId]) REFERENCES [Employee]([Id]),
    CONSTRAINT [FK_Permission_Project_ProjPerm] FOREIGN KEY ([ProjectId]) REFERENCES [Project]([Id])
);

IF EXISTS (SELECT * FROM sys.tables WHERE NAME = 'ActivityLog' AND TYPE = 'U')
BEGIN
    DROP TABLE [ActivityLog];
END;
CREATE TABLE [ActivityLog]
(
    [Id] INT IDENTITY(1, 1),
    [EmployeeId] INT NOT NULL,
    [Message] NVARCHAR(2048),
    [ProjectStageId] INT NOT NULL,
    [WorkedFrom] DATETIME2,
    [WorkedTo] DATETIME2,
    CONSTRAINT [PK_ActivityLog] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_ActivityLog_Employee_LogEmployee] FOREIGN KEY ([EmployeeId]) REFERENCES [Employee]([Id]),
    CONSTRAINT [FK_ActivityLog_ProjectStage_LogProjectStage] FOREIGN KEY ([ProjectStageId]) REFERENCES [ProjectStage]([Id])
);

