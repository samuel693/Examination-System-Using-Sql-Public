use [Examination_System]


--Calc the age by birthdate
GO
CREATE OR ALTER FUNCTION dbo.CalculateAge(@BirthDate DATE)
RETURNS INT
AS BEGIN
    IF (@BirthDate IS NULL)
        RETURN 0
    DECLARE @age INT
    SET @age = DATEDIFF(YEAR, @BirthDate, GETDATE())
    RETURN @age
END

GO

--Create Age column

alter table dbo.[Useraccount]
add Age as dbo.CalculateAge([birthdate])

--Make Constraint Validations for Password
ALTER TABLE dbo.Useraccount
ADD pass NVARCHAR(100);

ALTER TABLE dbo.Useraccount
ADD CONSTRAINT CheckPasswordLength
CHECK ( 
	pass LIKE '%[A-Z]%' AND
    pass LIKE '%[a-z]%' AND
    pass LIKE '%[0-9]%' AND
	pass LIKE '%[^a-zA-Z0-9]%' AND
    LEN(pass) >= 8
);


--Make Constraint check length phone == 11
ALTER TABLE [dbo].[Useraccount]
DROP COLUMN [phone]

ALTER TABLE dbo.Useraccount
ADD phone CHAR(11);

ALTER TABLE dbo.Useraccount
ADD CONSTRAINT CheckPhoneNumberLength
CHECK (LEN(phone) = 11);


--Make Constraint Validations for FIRSTNAME, LASTNAME that dosen't contain number, special char & length > 2
ALTER TABLE [dbo].[Useraccount]
Add [f_name] VARCHAR(50);

ALTER TABLE [dbo].[Useraccount]
Add [l_name] VARCHAR(50);

ALTER TABLE dbo.Useraccount
Add CONSTRAINT CheckFirstNameFormat
CHECK ([f_name] NOT LIKE '%[0-9]%' AND [f_name] NOT LIKE '%[^a-zA-Z]%' AND LEN([f_name]) > 2);

ALTER TABLE dbo.Useraccount
ADD CONSTRAINT CheckLastNameFormat
CHECK ([l_name] NOT LIKE '%[0-9]%' AND [l_name] NOT LIKE '%[^a-zA-Z]%' AND LEN([l_name]) > 2);


--Make check Constraint max_degree less than or equal 100
ALTER TABLE [dbo].[Course]
ADD CONSTRAINT CHK_MaxDegree CHECK (max_degree <= 100);


--Make check constraint min_degree greater than or equal 0
ALTER TABLE [dbo].[Course]
ADD CONSTRAINT CHK_MinDegree CHECK ([min_degree] >= 0);

--Delete userAccount Instructor when Instructor deleted from Insructor table
ALTER TABLE [dbo].[Instructor]
DROP CONSTRAINT InstructorUser_idFK;

ALTER TABLE [dbo].[Instructor]
ADD CONSTRAINT InstructorUser_idFK
FOREIGN KEY ([user_id])
REFERENCES [dbo].[Useraccount]([id_user])
ON DELETE CASCADE;

--Delete Instructor from Track_Instructor when Instructor deleted from Insructor table
ALTER TABLE [dbo].[Track_Instructor]
DROP CONSTRAINT Track_InstructorInstructor_idFK;

ALTER TABLE [dbo].[Track_Instructor]
ADD CONSTRAINT Track_InstructorInstructor_idFK
FOREIGN KEY ([instructor_id])
REFERENCES [dbo].[Instructor]([id_instructor])
ON DELETE CASCADE;
--Delete Instructor from course_instractor when Instructor deleted from Insructor table
ALTER TABLE [dbo].[instractorCourses]
DROP CONSTRAINT[instractorCoursesInstractor_idFK];

ALTER TABLE [dbo].[instractorCourses]
ADD CONSTRAINT [instractorCoursesInstractor_idFK]
FOREIGN KEY ([instractor_id])
REFERENCES [dbo].[Instructor]([id_instructor])
ON DELETE CASCADE;

--Delete student from [dbo].[ExamsResult] when student deleted from table student
ALTER TABLE [dbo].[ExamsResult]
ADD CONSTRAINT FK_DeleteExamsByStudent
FOREIGN KEY (student_id)
REFERENCES [dbo].[Student]([id_student])
ON DELETE CASCADE;

--Delete student from [dbo].[spaseficExams] when student deleted from table student
ALTER TABLE [dbo].[spaseficExams]
ADD CONSTRAINT FK_DeleteSpecificExamsByStudent
FOREIGN KEY (student_id)
REFERENCES [dbo].[Student]([id_student])
ON DELETE CASCADE;

--Delete student from [dbo].[Student_Course] when student deleted from table student
ALTER TABLE [dbo].[Student_Course]
ADD CONSTRAINT FK_DeleteCourseByStudent
FOREIGN KEY (student_id)
REFERENCES [dbo].[Student]([id_student])
ON DELETE CASCADE;
