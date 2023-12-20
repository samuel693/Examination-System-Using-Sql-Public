USE [Examination_System]

------------------------Use procedure Addstudent to Add new student-------------------
--Valid Data
EXEC Addstudent
    @User_name = 'MaiMoo12',
    @Email = 'Maimo1@example.com',
    @Phone = '12345678901',
    @F_name = 'Joo',
    @L_name = 'Doo',
    @City = 'City',
    @Street_name = '123 Main St',
    @Birthdate = '1998-01-15',
    @Pass = 'strongpass@123',
	@student_id = 1008,
    @intakeBranchTrack_id = 2,   
	@department_id= 1;

--Invalid Data
EXEC Addstudent
    @User_name = 'MaiMoo12', --Duplicate username
    @Email = 'Maimo1@example.com',
    @Phone = '12345', --must be 11 number
    @F_name = 'Joo',
    @L_name = 'Doo',
    @City = 'City',
    @Street_name = '123 Main St',
    @Birthdate = '1998-01-15',
    @Pass = '123', --Weak Password
	@student_id = 2,
    @intakeBranchTrack_id = 2,
	@department_id= 1;

---------------------------	Update Student------------------------
GO
CREATE OR ALTER PROCEDURE UpdateStudent
   @student_id INT,
   @NewUser_name VARCHAR(50),
    @NewEmail VARCHAR(50),
    @NewPhone CHAR(11),
    @NewF_name VARCHAR(50),
    @NewL_name VARCHAR(50),
    @NewCity VARCHAR(50),
    @NewStreet_name VARCHAR(100),
    @NewBirthdate DATE,
    @NewPass VARCHAR(100),
	@intakeBranchTrack_id INT,
	@department_id INT
AS
BEGIN
    BEGIN TRY
		--Check the user_id for student
		IF NOT EXISTS (SELECT 1 FROM [dbo].[Student] WHERE [user_id] = @student_id)
            THROW 50008, 'Student account not found.', 16;
        
		--User name != NULL
        IF (ISNULL(@NewUser_name, '') = '')
            THROW 50005, 'Please be sure to enter your user name!', 16;
		
		--Email in correct format ==> user@gmail.com
		IF(NOT(
		@NewEmail LIKE '%@%.%' AND
        @NewEmail NOT LIKE '%@%@%@%' AND
        @NewEmail NOT LIKE '%@%.%.%' AND
		LEN(@NewEmail) >= 5
		))
			THROW 50006, 'The email must be in correct format like user@gmail.com..',16;

        --Phone.length == 11 or != NULL
        IF (ISNULL(@NewPhone, '') = '' OR LEN(@NewPhone) != 11)
            THROW 50006, 'The phone number must be 11 digits long!', 16;

		--First Name dosen't contain number, special char & greater than 2
        IF (NOT (
		 @NewF_name NOT LIKE '%[0-9]%'AND
		 @NewF_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@NewF_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--First Name dosen't contain number, special char & greater than 2
		IF (NOT (
		 @NewL_name NOT LIKE '%[0-9]%'AND
		 @NewL_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@NewL_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--Check validation password 
         IF (NOT (
            @NewPass LIKE '%[A-Z]%' AND
            @NewPass LIKE '%[a-z]%' AND
            @NewPass LIKE '%[0-9]%' AND
            @NewPass LIKE '%[^a-zA-Z0-9]%' AND
            LEN(@NewPass) >= 8
        ))
            THROW 50007, 'Password must meet complexity requirements.', 16;
        
       UPDATE [dbo].[Useraccount]
        SET user_name = @NewUser_name,
            f_name = @NewF_name,
            l_name = @NewL_name,
            city = @NewCity,
            street_name = @NewStreet_name,
            birthdate = @NewBirthdate,
            email = @NewEmail,
            pass = @NewPass,
            phone = @NewPhone
        WHERE [id_user] = @student_id;

		UPDATE [dbo].[Student]
        SET [intake_branch_track_ID] = @intakeBranchTrack_id, [department_id] = @department_id
        WHERE [user_id] = @student_id;
        
        PRINT 'Student updated successfully.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        PRINT 'Error ' + @ErrorMessage;
    END CATCH;
END;
GO
--InValid Data the student_id incorrect 
EXEC UpdateStudent
    @student_id = 1003, 
    @NewUser_name = 'new_username1',
    @NewEmail = 'newemail1@example.com',
    @NewPhone = '12345678901',
    @NewF_name = 'FirstName',
    @NewL_name = 'LastName',
    @NewCity = 'New City',
    @NewStreet_name = 'New Street',
    @NewBirthdate = '1999-07-01',
    @NewPass = 'NewP@ssw0rd',
    @intakeBranchTrack_id = 5,
	@department_id= 1;

--Valid Data
EXEC UpdateStudent
    @student_id = 1037, 
    @NewUser_name = 'MaiMo71',
    @NewEmail = 'Mo70@example.com',
    @NewPhone = '12345678901',
    @NewF_name = 'FirstName',
    @NewL_name = 'LastName',
    @NewCity = 'New City',
    @NewStreet_name = 'New Street',
    @NewBirthdate = '1999-07-01',
    @NewPass = 'NewP@ssw0rd',
    @intakeBranchTrack_id = 5,
	@department_id= 1;

------------------------Delete student by DeleteStudent procedure----------------------------
--InValid Cannot DELETE
EXEC DeleteStudent @student_id = 20;  --Invalid ID

--Valid Can DELETE
EXEC DeleteStudent @student_id = 1003;

----------------------------Adding new Instructor by using Addinstructor procedure-------------------------------
--Valid DATA
EXEC Addinstructor
    @User_name = 'johndoe',
    @Email = 'john@example.com',
    @Phone = '12345678901',
    @F_name = 'Joo',
    @L_name = 'Doe',
    @City = 'City',
    @Street_name = '123 Main St',
    @Birthdate = '1990-01-15',
    @Pass = 'strongpass@123',
    @manager_id = 8;

--InValid DATA	
EXEC Addinstructor
    @User_name = 'johndoe',  --Instructor already present
    @Email = 'Mai@gmail.com',
    @Phone = '12345678901',
    @F_name = 'Mai',
    @L_name = 'Fathi',
    @City = 'City',
    @Street_name = '123 Main St',
    @Birthdate = '1990-01-15',
    @Pass = 'strongpass@123',
    @manager_id = 5;

-------------------------------------------Update data of instructor----------------------------------
GO
CREATE OR ALTER PROCEDURE UpdateInstructor
   @Instructor_id INT,
   @NewUser_name VARCHAR(50),
    @NewEmail VARCHAR(50),
    @NewPhone CHAR(11),
    @NewF_name VARCHAR(50),
    @NewL_name VARCHAR(50),
    @NewCity VARCHAR(50),
    @NewStreet_name VARCHAR(100),
    @NewBirthdate DATE,
    @NewPass VARCHAR(100),
	@manager_id INT
AS
BEGIN
    BEGIN TRY
		--Check the user_id for student
		IF NOT EXISTS (SELECT 1 FROM [dbo].[Instructor] WHERE [user_id] = @Instructor_id)
            THROW 50008, 'The user account of Instructor not found!', 16;
        --User name != NULL
        IF (ISNULL(@NewUser_name, '') = '')
            THROW 50005, 'Please be sure to enter your user name!', 16;
		
		--Email in correct format ==> user@gmail.com
		IF(NOT(
		@NewEmail LIKE '%@%.%' AND
        @NewEmail NOT LIKE '%@%@%@%' AND
        @NewEmail NOT LIKE '%@%.%.%' AND
		LEN(@NewEmail) >= 5
		))
			THROW 50006, 'The email must be in correct format like user@gmail.com..',16;

        --Phone.length == 11 or != NULL
        IF (ISNULL(@NewPhone, '') = '' OR LEN(@NewPhone) != 11)
            THROW 50006, 'The phone number must be 11 digits long!', 16;

		--First Name dosen't contain number, special char & greater than 2
        IF (NOT (
		 @NewF_name NOT LIKE '%[0-9]%'AND
		 @NewF_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@NewF_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--First Name dosen't contain number, special char & greater than 2
		IF (NOT (
		 @NewL_name NOT LIKE '%[0-9]%'AND
		 @NewL_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@NewL_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--Check validation password 
         IF (NOT (
            @NewPass LIKE '%[A-Z]%' AND
            @NewPass LIKE '%[a-z]%' AND
            @NewPass LIKE '%[0-9]%' AND
            @NewPass LIKE '%[^a-zA-Z0-9]%' AND
            LEN(@NewPass) >= 8
        ))
            THROW 50007, 'Password must meet complexity requirements.', 16;
        
       UPDATE [dbo].[Useraccount]
        SET user_name = @NewUser_name,
            f_name = @NewF_name,
            l_name = @NewL_name,
            city = @NewCity,
            street_name = @NewStreet_name,
            birthdate = @NewBirthdate,
            email = @NewEmail,
            pass = @NewPass,
            phone = @NewPhone
        WHERE [id_user] = @Instructor_id;

		UPDATE [dbo].[Instructor]
        SET [manager_id] = @manager_id
        WHERE [user_id] = @Instructor_id;
        
        PRINT 'Instructor updated successfully.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        PRINT 'Error ' + @ErrorMessage;
    END CATCH;
END;
GO
--Valid Data
EXEC UpdateInstructor
    @Instructor_id = 3, 
    @NewUser_name = 'new_12username',
    @NewEmail = 'newemail23@example.com',
    @NewPhone = '12345678901',
    @NewF_name = 'FirstName',
    @NewL_name = 'LastName',
    @NewCity = 'New City',
    @NewStreet_name = 'New Street',
    @NewBirthdate = '1999-07-01',
    @NewPass = 'NewP@ssw0rd',
    @manager_id = 4;

--InValid Data
EXEC UpdateInstructor
    @Instructor_id = 2000, 
    @NewUser_name = 'new_12username',
    @NewEmail = 'newemail23@example.com',
    @NewPhone = '12345678901',
    @NewF_name = 'FirstName',
    @NewL_name = 'LastName',
    @NewCity = 'New City',
    @NewStreet_name = 'New Street',
    @NewBirthdate = '1999-07-01',
    @NewPass = 'NewP@ssw0rd',
    @manager_id = 4;

-----------------------------Delete Instructor----------------------------------------
--InValid Cannot DELETE ---> He is manager
EXEC DeleteInstructor @Instructor_id = 4; 

--Valid can DELETE
EXEC DeleteInstructor  @Instructor_id = 1020;


-------------------------Get Specific Instructor Info by Id or Username---------------------------
 
--Valid ID 
SELECT * FROM GetInstructorInfo(4);
--Valid UsreName
SELECT * FROM GetInstructorInfo('maimohammed');


----------Get Instructor Info who is manager and the name of course and trach if he teach a course------------
--Valid ID
SELECT * FROM dbo.GetInstructorInfo(2);
--Valid UserName
SELECT * FROM dbo.GetInstructorInfo('AhmedMohammed');

--------------Get Student Info by ID or UserName------------------
--Valid ID
SELECT * FROM GeStudentInfo(1003);

--Valid UserName
SELECT * FROM GeStudentInfo('MaiMo12');



-------------------	VIEWS---------------

----------Get all Instructors Info-----------
SELECT * FROM InstructorInfo;

--------------Get all Instructors Info who are manager and if he teach course belong to Track------------

SELECT * FROM InstructorsTeachingCourseInTrack

--------------Get all students Info------------
SELECT * FROM StudentInfo;


----------Get all students with there course ID & NAME-------------

SELECT * FROM StudentInfoCourse


--------------Get all courses data----------

SELECT * FROM all_courses_view;


--------------------------Get all students exam results------------------

SELECT * FROM all_StdAnswers_view;


------------------Get all students who are pass from exam--------------

SELECT * FROM all_StdAnswers_field_view;

----========================================================================================================
------Begin intake  , branch , track , department , course =====---------(Samweil)--------
-----==================================================================================================

------======(((((((((((((((  branch  ))))))))))))))))))))=====----
--==func to return instructor id using user name account
   --(valid)
select dbo.GetInstId ('janedoe')
  --(not valid)
select dbo.GetInstId ('mikesmith')

----===proc insert to branchh
--(valid)
exec InsToBranch 'miniawsdvd' , 'janedoe'
--(not valid)
exec InsToBranch 'miniawsdvd' , 'mikesmith'

----===procedure to update branch 
--(valid)
exec UpdatInBranch 'minia' , 'janedoe'
--(not valid)
exec UpdatInBranch 'minia' , 'mikesmith'

----===trigger prevent delete branch
DELETE FROM dbo.Branch WHERE BranchName='minia'

---====view to show branch name and manager name
select * from ShowBranchAndManager

------=========(((((((((((   Department   )))))))))))))=====-----
  --==procedure to insert to dept table
  --(valid)
   exec InsToDept  'Software' , 1
   --(not valid)
    exec InsToDept  'testing' , 2

  ---===trigger update in dept table
    --(valid)
  begin try
  update dbo.Department 
  set DepatrmentName = 'Sdefe',
      manager_id =3
	  where id_departmant =1;

end try
begin catch
  select ERROR_MESSAGE();
end catch

  --(not valid)
  begin try
  update dbo.Department 
  set DepatrmentName = 'Sdefe',
      manager_id =3
	  where id_departmant =23;

end try
begin catch
  select ERROR_MESSAGE();
end catch
   --=====trigger to prevet delete Department  
   begin try
delete from  dbo.Department where id_departmant =10
end try
begin catch
  select ERROR_MESSAGE();
end catch



   ----===function get department using id
       ---(valid)
	  select *  from GetDept(1)
	  ---(not valid)  
	  select *  from GetDept(10)
	   
   ---==view get dept manager information
       select * from DeptManagerInfo

  
-----------=========(((((((((((((( Track  ))))))))))))=======================----------------
---=====Procedure To Add track 
  --(valid)
  exec Add_Track '.net track', 5
  --(not valid)
  exec Add_Track '.net track', 15

----=======trigger to update in track 
  --(valid)
  begin try
  update dbo.Track 
  set TrackName = 'SD',
      supervisior_id =15
	  where id_track =3;

end try
begin catch
  select ERROR_MESSAGE();
end catch


  --(not valid)
  begin try
  update dbo.Track 
  set TrackName = 'SD',
      supervisior_id =15
	  where id_track =10;

end try
begin catch
  select ERROR_MESSAGE();
end catch

---======trigger prevention delete track
delete from dbo.Track where TrackName='.net'

--========view to show track and supervisor details==
select * from dbo.Track_Super_Details

----========view to show track and  its courses
  select * from dbo.Track_Course_Det


-----------=========(((((((((((((( Course  ))))))))))))=======================----------------

--=======procedure to insert in course table and instructorCourse table
 --(valid)
 exec Add_course 'fwegvewvevww','hyper text markup language',10,20, 'janedoe',2


--(not valid)
 exec Add_course 'fwegvewvevww','hyper text markup language',10,20, 'Msaboor123',2

 ----========Procedure to update in Course
 --(valid)
 
 begin try
 update [dbo].[Course] 
  set [Name] ='php laravel v2', 
  [max_degree]=100,
  [min_degree]=50,
  [discraption]='php laravel v2 in full stack',
  [track_id]=4 where IDcourse =3 ;
      --update in instructor course
  UPDATE dbo.instractorCourses
   SET instractor_id =20
  WHERE course_id = 3;

 end try
 begin catch
   select ERROR_MESSAGE()
 end catch
 
 

--(not valid)
 begin try
 update [dbo].[Course] 
  set [Name] ='php laravel v2', 
  [max_degree]=100,
  [min_degree]=50,
  [discraption]='php laravel v2 in full stack',
  [track_id]=4 where IDcourse =200 ;
      --update in instructor course
  UPDATE dbo.instractorCourses
   SET instractor_id =20
  WHERE course_id = 200;

 end try
 begin catch
   select ERROR_MESSAGE()
 end catch

 ---===trigger prevent delete
 begin try
 DELETE FROM dbo.Course WHERE [Name]='sdvsdv'   
 end try
 begin catch
   select ERROR_MESSAGE();
end catch

 --==========view to show course and its instructor details
  select * from dbo.Course_Instr_Details




-----------=========(((((((((((((( intake  ))))))))))))=======================----------------

----========procedure to insert in intake
   
    --(valid)
    exec Insert_Intake  50 ,2023   
	--(not valid)
	exec Insert_Intake  50 ,2020


----======prevent delete and update in  intake  
begin try
   update  dbo.Intake
   set IntakeNumberYear= 2023
   where IntakeNumber=42
end try
begin catch
   select ERROR_MESSAGE();
end catch

begin try
delete from dbo.Intake where IntakeNumber=42
end try
begin catch
   select ERROR_MESSAGE();
end catch


-----------=========(((((((((((((( intake , branch , track  ))))))))))))=======================----------------
--===========insert   into  IntakeBranchTrack 
  --(valid)
 exec Insert_IntakeBranchTrack  10, 8 , 47

 --(not valid)
 exec Insert_IntakeBranchTrack  10, 8 , 90

 ---====prevention update and delete  IntakeBranchTrack 
 begin try
   update  dbo.Intake_Branch_Track
   set branch_id= 21
   where track_id=12
end try
begin catch
   select ERROR_MESSAGE();
end catch



 begin try
delete from dbo.Intake_Branch_Track where branch_id=1
end try
begin catch
   select ERROR_MESSAGE();
end catch


----========================================================================================================
------End  intake  , branch , track , department , course =====---------(Samweil)--------
-----==================================================================================================

----========================================================================================================
------strat  quostion_and_Answer   , Exam , exam_student , coorect_Exam =====---------(mohamed_Saboor)--------
-----==================================================================================================
/*
exec Q_and_QA.insertInto_Q_and_QA 
@type_name ='choose' , @Contact ='what is oop C#',@correctAnswer ='kl',
@Answer1 ='ml',@Answer2 ='pl' ,@Answer3 ='sl',@Answer4 ='kl',
@course_name ='oop c#',@email='Msaboor@gmail.com'

exec Q_and_QA.insertInto_Q_and_QA 
@type_name ='text', @Contact ='string is  ',@correctAnswer ='no '
,@course_name ='oop c#',@email='Msaboor@gmail.com'

exec Q_and_QA.insertInto_Q_and_QA
@type_name ='T/F',  @Contact ='is it not importane',
@correctAnswer ='true',@course_name ='oop c#',@email='samaoul@gmail.com', 
@Answer1 ='false',@Answer2 ='true'
*/
/*
exec Update_Q_and_QA
@newtype_name ='choose',@oldContact ='what is C##' ,@newContact ='what is c#',
@oldcourse_name ='ISQN',@newcourse_name ='oop c#',@newcorrectAnswer ='pl' ,
@email ='Msaboor@gmail.com',@newAnswer1 ='pl',@newAnswer2 ='ml',
@newAnswer3 ='sl',@newAnswer4 ='kl'

*/
/*
exec delet_Q_and_QA 
@Contact ='what is c#',@email ='Msaboor@gmail.com',
@course_name ='oop c#'
*/
/*
  
select * from Q_and_QA.Q_QAnswer

insert into Q_QAnswer (questions_id,Type , Contact ,flag ,Answer ,coursName)
values (15,'tk','jhdjkds',0,'jhjkadsfhj','c#') -- you can not insert 
*/
--exec display_spasefic_Course_Q_QA @courseName='oop c#', @email ='Msaboor@gmail.com'

/*
exec  Exams.insertintoExams 
@Name='c#', @Type ='exam',@intake_branch_track_ID =4,@email ='Msaboor@gmail.com',
@courseName ='oop c#', @start_time ='10:00' ,@end_time ='11:00' ,@Exam_date ='2023-09-20'
*/
/*
exec  updateintoExams @id_Exam = 12,
@newName ='oop c#', @newType ='corrective', @new_intake_branch_track_ID = 4, @newemail ='Msaboor@gmail.com',
@newcourseName ='oop c#', @newstart_time ='10:29' ,@newend_time ='11:00' ,@newExam_date ='2023-09-20'
*/

/*
exec  Exams_Q.insertintoExams_Q 
@exam_id =11?@contant = 'what is mean oop' ,@email ='Msaboor@gmail.com' ,
@courseName ='oop c#',@degree = 10
*/

/*
exec  Exams_Q.updateExams_Q 
@exam_id =5, @oldcontant = 'what is c#',@newcontant = 'what is C# framwork' ,
@email ='Msaboor@gmail.com' ,@courseName ='oop c#',@newdegree =15
*/

	

/*
exec deleteExams_Q 
@exam_id= 5,@contant ='what is C# framwork' ,@email ='Msaboor@gmail.com'
*/

/*
exec select_Question_Random 
@number_Quest =10 ,@courseName ='oop c#',
@Exam_Id =15,@email ='yahiazak@gmail.com',@Q_Degree =10
*/

--exec Exam_Student.insertintoExam_for_student @email='saboormohamed@gmail.com' ,@Exam_id=13



/*
exec Exam_Student.updateExam_for_student @oldemail='ahmedhos@gmail.com',@newemail='saboormohamed@gmail.com',
@oldExam_id=14, @newExam_id=15
*/


--exec deleteExam_for_student 'saboormohamed@gmail.com',15

/*
exec Student.Display_QExam_To_Student 
@email = 'saboormohamed@gmail.com',@Exam_Id= 15 
*/

--exec Student.Display_All_Exams_to_student @email='saboormohamed@gmail.com'


/*
exec Student.Insert_Answer_OF_Student
@id_question = 40 ,@Answer ='sql',@email = 'saboormohamed@gmail.com',@Exam_Id = 13
*/

--exec student.display_result_exam_of_student @email='saboormohamed@gmail.com',@Exam_Id = 13

----========================================================================================================
------end  quostion_and_Answer   , Exam , exam_student , coorect_Exam =====---------(mohamed_Saboor)--------
-----==================================================================================================
 


