
GO
--Get all Instructor Info
CREATE VIEW InstructorInfo AS
SELECT
    inst.id_instructor AS InstructorID,
    us.user_name AS UserName,
    us.email AS Email,
    us.phone AS Phone,
    us.f_name AS FirstName,
    us.l_name AS LastName,
    us.city AS City,
    us.street_name AS StreetName,
    us.birthdate AS Birthdate
FROM
    [dbo].[Instructor] AS inst
JOIN
    [dbo].[Useraccount] AS us 

ON inst.user_id = us.id_user;

GO

SELECT * FROM InstructorInfo;

GO
--Get Specific Instructor Info by Id or Username
CREATE Or ALTER FUNCTION GetInstructorInfo(@Info VARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT
        inst.id_instructor AS InstructorID,
        us.user_name AS UserName,
        us.email AS Email,
        us.phone AS Phone,
        us.f_name AS FirstName,
        us.l_name AS LastName,
        us.city AS City,
        us.street_name AS StreetName,
        us.birthdate AS Birthdate
    FROM
        [dbo].[Instructor] AS inst
    JOIN
        [dbo].[Useraccount] AS us 
    ON inst.user_id = us.id_user
    WHERE us.user_name = @Info OR inst.id_instructor = TRY_CAST(@Info AS INT)
);
GO 

SELECT * FROM GetInstructorInfo('Msaboor123');

--Get all Instructor who are manager
GO
alter VIEW InstructorInfoManager AS
SELECT
    ins.id_instructor AS InstructorID,
    us.user_name AS UserName,
    us.email AS Email,
    us.phone AS Phone,
    us.f_name AS FirstName,
    us.l_name AS LastName,
    us.city AS City,
    us.street_name AS StreetName,
    us.birthdate AS Birthdate,
    CASE
        WHEN inst.manager_id IS NOT NULL THEN 'Manager'
        ELSE 'Not a Manager'
    END AS ManagerStatus
FROM
    [dbo].[Instructor] AS inst
JOIN
    [dbo].Instructor AS ins ON inst.manager_id = ins.id_instructor
JOIN
    [dbo].[Useraccount] AS us ON ins.user_id = us.id_user


GO
SELECT * FROM InstructorInfoManager;

--Know the instructor user name , if he manager, if he teach course ==> course Name and teach for any track
GO
CREATE OR ALTER FUNCTION GetInstructorInfo(@Value NVARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT
        inst.id_instructor AS InstructorID,
        us.user_name AS UserName,
        CASE
            WHEN inst.manager_id IS NOT NULL THEN 'Manager'
            ELSE 'Not a Manager'
        END AS ManagerStatus,
        (SELECT TOP 1 crs.[Name]
         FROM [dbo].[Course] AS crs
         JOIN [dbo].[instractorCourses] AS icrs ON crs.IDcourse = icrs.course_id
         WHERE icrs.instractor_id = inst.id_instructor) AS 'CourseName',
        (SELECT TOP 1 tra.TrackName
         FROM [dbo].[Track] AS tra
         JOIN [dbo].[Track_Instructor] AS ti ON tra.id_track = ti.track_id
         WHERE ti.instructor_id = inst.id_instructor) AS 'TrackName'
    FROM [dbo].[Instructor] AS inst
    JOIN [dbo].[Useraccount] AS us ON inst.user_id = us.id_user
    WHERE us.user_name = @Value OR inst.id_instructor = TRY_CAST(@Value AS INT)
);
GO
SELECT *
FROM dbo.GetInstructorInfo(2);

SELECT *
FROM dbo.GetInstructorInfo('Msaboor123');


--Get All Instructor who teaching course and manager
GO
CREATE OR ALTER VIEW InstructorsTeachingCourseInTrack AS
SELECT
    inst.id_instructor AS InstructorID,
    us.user_name AS UserName,
    CASE
        WHEN inst.manager_id IS NOT NULL THEN 'Manager'
        ELSE 'Not a Manager'
    END AS ManagerStatus,
    crs.[Name] AS CourseName,
    tra.TrackName AS TrackName
FROM
    [dbo].[Instructor] AS inst
JOIN
    [dbo].[Useraccount] AS us ON inst.user_id = us.id_user
JOIN
    [dbo].[instractorCourses] AS ic ON inst.id_instructor = ic.instractor_id
JOIN
    [dbo].[Course] AS crs ON ic.course_id = crs.IDcourse
JOIN
    [dbo].[Track_Instructor] AS ti ON inst.id_instructor = ti.instructor_id
JOIN
    [dbo].[Track] AS tra ON ti.track_id = tra.id_track;
GO

SELECT *
FROM InstructorsTeachingCourseInTrack


--Get all student Info
GO
CREATE VIEW StudentInfo AS
SELECT
    stud.id_student AS StudentID,
    us.user_name AS UserName,
    us.email AS Email,
    us.phone AS Phone,
    us.f_name AS FirstName,
    us.l_name AS LastName,
    us.city AS City,
    us.street_name AS StreetName,
    us.birthdate AS Birthdate
FROM
    [dbo].[Student] AS stud
JOIN
    [dbo].[Useraccount] AS us 

ON stud.user_id = us.id_user;

GO

SELECT * FROM StudentInfo;

GO
GO
--Get Specific student Info by Id or Username
CREATE OR ALTER FUNCTION GeStudentInfo(@Info VARCHAR(50))
RETURNS TABLE
AS
RETURN (
    SELECT
        stud.id_student AS StudentID,
        us.user_name AS UserName,
        us.email AS Email,
        us.phone AS Phone,
        us.f_name AS FirstName,
        us.l_name AS LastName,
        us.city AS City,
        us.street_name AS StreetName,
        us.birthdate AS Birthdate
    FROM
        [dbo].[Student] AS stud
    JOIN
        [dbo].[Useraccount] AS us 
    ON stud.user_id = us.id_user
   WHERE us.user_name = @Info OR stud.id_student = TRY_CAST(@Info AS INT)
);
GO 

SELECT * FROM GeStudentInfo(2);

SELECT * FROM GeStudentInfo('MaiMo12');

--Get all Student with there course 
GO
CREATE VIEW StudentInfoCourse AS
SELECT
    S.id_student AS StudentID,
    U.user_name AS UserName,
    SC.course_id AS CourseID,
    C.[Name] AS CourseName
FROM
    Student AS S
JOIN
    UserAccount AS U ON S.user_id = U.id_user
JOIN
    Student_Course AS SC ON S.id_student = SC.student_id
JOIN
    Course AS C ON SC.course_id = C.IDcourse;

GO
SELECT * FROM StudentInfoCourse;


GO 

CREATE VIEW all_courses_view AS
SELECT * FROM [dbo].[Course];

GO
SELECT * FROM all_courses_view;
GO

GO
--
CREATE VIEW all_StdAnswers_view AS
SELECT * FROM [dbo].[ExamQuestions];

GO

SELECT * FROM all_StdAnswers_view;
--

GO

alter VIEW all_StdAnswersPass_view AS
SELECT * FROM [dbo].[ExamsResult]
WHERE flag = 1;

GO
SELECT * FROM all_StdAnswersPass_view;

GO 

CREATE VIEW all_StdAnswers_field_view AS
SELECT * FROM [dbo].ExamsResult
WHERE flag = 0;

GO

SELECT * FROM all_StdAnswers_field_view;


GO
CREATE VIEW all_StdAnswers_fullmark_view AS
SELECT * FROM [dbo].ExamsResult
WHERE total_degree_student =total_degree_exam ;

GO

SELECT * FROM all_StdAnswers_fullmark_view;