USE [ActivityLogsDB];

-- =========== Grades seeding =========== --
DECLARE @internGradeId INT;
DECLARE @staffGradeId INT;
DECLARE @seniorGradeId INT;
DECLARE @pmGradeId INT;

EXEC AddGrade 'Сотрудник на испытательном сроке', @internGradeId OUTPUT;
EXEC AddGrade 'Специалист', @staffGradeId OUTPUT;
EXEC AddGrade 'Ведущий специалист', @seniorGradeId OUTPUT;
EXEC AddGrade 'Руководитель проекта', @pmGradeId OUTPUT;
-- =========== ~Grades seeding =========== --

-- =========== Employees seeding =========== --
DECLARE @pm_ivanov INT;
DECLARE @sen_petrov INT;
DECLARE @stf_sidorov INT;
DECLARE @int_skvortsov INT;

EXEC RegisterEmployee 'i.ivanov', NULL, @pmGradeId, @pm_ivanov OUTPUT; 
EXEC RegisterEmployee 'p.petrov', NULL, @seniorGradeId, @sen_petrov OUTPUT; 
EXEC RegisterEmployee 's.sidorov', NULL, @staffGradeId, @stf_sidorov OUTPUT; 
EXEC RegisterEmployee 's.skvortsov', NULL, @internGradeId, @int_skvortsov OUTPUT;
-- =========== ~Employees seeding =========== --
 
-- =========== Departments seeding =========== --
DECLARE @devs_dep INT;

EXEC AddDepartment 'Отдел разработки', @pm_ivanov, @devs_dep OUTPUT;

EXEC ApplyEmpToDep @pm_ivanov, @devs_dep;
EXEC ApplyEmpToDep @sen_petrov, @devs_dep;
EXEC ApplyEmpToDep @stf_sidorov, @devs_dep;
EXEC ApplyEmpToDep @int_skvortsov, @devs_dep;
-- =========== ~Departments seeding =========== --

-- =========== Projects seeding =========== --
DECLARE @proj_internal INT;
DECLARE @proj_external INT;

EXEC CreateProject 'Internal project', 0, NULL, NULL, @proj_internal OUTPUT;
EXEC CreateProject 'External project', 1, '14:00:00', '20:00:00', @proj_external OUTPUT;

DECLARE @p_int_stage1 INT, @p_int_stage1_order INT;
DECLARE @p_int_stage2 INT, @p_int_stage2_order INT;
DECLARE @p_int_stage3 INT, @p_int_stage3_order INT;
DECLARE @p_ext_stage1 INT, @p_ext_stage1_order INT;
DECLARE @p_ext_stage2 INT, @p_ext_stage2_order INT;
DECLARE @p_ext_stage3 INT, @p_ext_stage3_order INT;

EXEC CreateProjectStage 'Internal project stage 1', NULL, NULL, @proj_internal, @p_int_stage1 OUTPUT, @p_int_stage1_order OUTPUT;
EXEC CreateProjectStage 'Internal project stage 2', NULL, NULL, @proj_internal, @p_int_stage2 OUTPUT, @p_int_stage2_order OUTPUT;
EXEC CreateProjectStage 'Internal project stage 3', NULL, NULL, @proj_internal, @p_int_stage3 OUTPUT, @p_int_stage3_order OUTPUT;
EXEC CreateProjectStage 'External project stage 1', NULL, NULL, @proj_external, @p_ext_stage1 OUTPUT, @p_ext_stage1_order OUTPUT;
EXEC CreateProjectStage 'External project stage 2', NULL, NULL, @proj_external, @p_ext_stage2 OUTPUT, @p_ext_stage2_order OUTPUT;
EXEC CreateProjectStage 'External project stage 3', NULL, NULL, @proj_external, @p_ext_stage3 OUTPUT, @p_ext_stage3_order OUTPUT;
-- =========== ~Projects seeding =========== --

-- =========== Permissions seeding =========== --
EXEC SetPermissionToProject @proj_internal, @pm_ivanov, NULL;
EXEC SetPermissionToProject @proj_internal, @sen_petrov, NULL;
EXEC SetPermissionToProject @proj_internal, @stf_sidorov, NULL;
EXEC SetPermissionToProject @proj_internal, @int_skvortsov, NULL;

EXEC SetPermissionToProject @proj_external, @pm_ivanov, NULL;
EXEC SetPermissionToProject @proj_external, @sen_petrov, NULL;
EXEC SetPermissionToProject @proj_external, @stf_sidorov, NULL;
EXEC SetPermissionToProject @proj_external, @int_skvortsov, NULL;
-- =========== ~Permissions seeding =========== --