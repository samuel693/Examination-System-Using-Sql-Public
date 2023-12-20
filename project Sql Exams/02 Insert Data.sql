


--------------=================insert into user account =============----------------------
INSERT INTO [dbo].[Useraccount] ([user_name], [f_name], [l_name], [city], [street_name], [birthdate], [email], [pass], [phone])
VALUES
    ('janedoe', 'Jane', 'Doe', 'Los Angeles', 'Oak Avenue', '1985-08-20',  'jane.doe@example.com', 'passwor$%', '98765432100'),
    ('mikesmith', 'Mike', 'Smith', 'Chicago', 'Maple Drive', '1992-03-10',  'mike.smith@example.com', 'pas3%^', '55512345067'),
    ('sarahjones', 'Sarah', 'Jones', 'Houston', 'Cedar Lane', '1998-12-01',  'sarah.jones@example.com', 'pass&*', '77788890999'),
    ('davidwilson', 'David', 'Wilson', 'Miami', 'Palm Street', '1987-07-25',  'david.wilson@example.com', 'pass()', '11122203333'),
    ('emilybrown', 'Emily', 'Brown', 'San Francisco', 'Elm Avenue', '1995-01-12',  'emily.brown@example.com', 'pas6#$$%', '44405556666'),
    ('robertmartin', 'Robert', 'Martin', 'Dallas', 'Cypress Road', '1993-09-05',  'robert.martin@example.com', 'password7', '99900001111'),
    ('laurasmith', 'Laura', 'Smith', 'Seattle', 'Chestnut Lane', '1991-06-18',  'laura.smith@example.com', 'pas12$%', '22233344044'),
    ('johnsmith', 'John', 'Smith', 'Boston', 'Birch Street', '1989-04-02',  'john.smith@example.com', 'pas#$', '66677788808'),
    ('amandajohnson', 'Amanda', 'Johnson', 'Atlanta', 'Willow Avenue', '1997-11-30',  'amanda.johnson@example.com', 'pas10$%', '33304445555'),
    ('michaelbrown', 'Michael', 'Brown', 'Phoenix', 'Pine Drive', '1994-02-17',  'michael.brown@example.com', 'pas45^&', '88899900000'),
    ('jenniferdavis', 'Jennifer', 'Davis', 'Denver', 'Spruce Lane', '1996-07-08',  'jenni.ferdavis@example.com', 'pas%^', '00011120222'),
    ('matthewwilson', 'Matthew', 'Wilson', 'San Diego', 'Sycamore Street', '1988-12-25',  'matthew.wilson@example.com', 'pas13^&', '70778889999'),
    ('sophiathompson', 'Sophia', 'Thompson', 'Philadelphia', 'Hickory Avenue', '1999-03-16',  'sophia.thompson@example.com', 'pas56%^', '55056667777'),
    ('samweilgamil23', 'samweil', 'gamil', 'minya', 'bani mazar str', '1999-03-16',  'samweil.gamil@example.com', 'pas56%^', '55056667777'),
     ('maimohamed12', 'mai', 'mohammed', 'minya', 'rayah street', '1999-03-16',  'mai.mohammed@example.com', 'pas56%^', '55056667777'),
    ('mohanedsaboor34', 'mohammed', 'saboor', 'assuit', 'mo.salah street', '1999-03-16',  'mohammed.saboor@example.com', 'pas56%^', '55056667777'),
   ('danieljohnson', 'Daniel', 'Johnson', 'Detroit', 'Cedar Lane', '1993-10-20',  'daniel.johnson@example.com', 'pas15#$', '12345678900'),
   ('aymanayad', 'ayman', 'ayad', 'Houston', 'Elm Street', '1995-09-12',  'ayman.ayad@example.com', 'pas34@#', '01234568709'),
    ('ahmedosman', 'ahmed', 'osman', 'Seattle', 'Cedar Avenue', '1991-06-30',  'ahmed.osman@example.com', 'pasd53$%', '01534670945'),
    ('hebasaleh', 'heba', 'saleh', 'Boston', 'Maple Lane', '1998-02-18',  'heba.saleh@example.com', 'pas345&*', '01123450987');
----------=============insert into instructor ----------=====================
select * from Instructor

insert into Instructor([user_id] , [manager_id]) values
                        (1,null),
                        (3,1),
                        (4,null),
						(5,null),
                        (6,4),
                        (10,5),
                        (11,null),
                        (13,11),
                        (14,6),
                        (15, 14),
						(18, 3),
						(19, null),
						(20, null);

----------------================insert into student =========================------------------	
select * from student
  
  insert into [dbo].[Student] (id_student,[user_id] , [intake_branch_track_ID],[department_id]) values 
       (1,8,1,1),
	   (2,12,2,3),
	   (3,14,2,2),
	   (4,15,5,1),
	   (5,16,8,3);
----------------============student courses  =============--------------------
select * from dbo.Student_Course 
///////////////////////
insert into dbo.Student_Course ([course_id] , [student_id]) values
                   (1,2),
                   (2,2),
                   (3,2),
                   (4,2),

				   (5,1),
				   (6,1),
				   (7,1),

				   (5,3),
				   (6,3),
				   (7,3),

				   (5,4),
				   (6,4),
				   (7,4),

				   (8,5),
				   (9,5),
				   (10,5);


-----------======================insert into Department ====================------------
    select * from Department
  insert into Department ([DepatrmentName] , [manager_id]) values
             ('Dept1' , 13  ),  
             ('Dept2' ,5 ),  
             ('Dept3' , 11); 
             
--------=================inserted into tracks =============--------------
 select * from Track
  insert into Track ([TrackName] , [supervisior_id]) values
             ('Asp.net' , 1  ),  
             ('Php laravel' ,4 ),  
             ('Crosss platform' , 3); 

			 
----------===========track instructor =============--------------
   select * from dbo.Track_Instructor

   insert into dbo.Track_Instructor (instructor_id , track_id) values
          (1,1),
          (2,1),

		  (4,2),
		  (6,2),

		  (9,3),
		  (10,3);




         
----------===========inserted course =========-----------
select * from dbo.Course
insert into [dbo].[Course] ([Name], [max_degree], [min_degree], [discraption], [track_id])
VALUES
    ('asp mvc', 100, 50, 'Advanced mvc course', 1),
    ('web api', 100, 50, 'converted database to api', 1),
    ('oop c#', 100, 50, 'Introduction to oop c#', 1),
    ('advanced c#',100, 50, 'Study of advanced  c#', 1),
    ('php', 100, 50, 'backend course', 2),
    ('laravel', 100, 50, 'World history overview', 2),
    ('angular', 100, 50, 'Introduction to programming',2),
    ('dart', 100, 50, 'Analyzing and interpreting data', 3),
    ('flutter', 100, 50, 'Expressing creativity through various mediums', 3),
    ('json', 100, 50, 'Appreciating and creating music', 3);

----------=============inserted into  instractor Courses ================---------------
select * from [dbo].[instractorCourses]

     insert into   [dbo].[instractorCourses] (course_id , instractor_id)
	    values   (1,3),
		         (2,1),
		         (3,3),
		         (4,2),
		         (5,6), 
		         (6,5),
		         (7,6),
		         (8,9),
		         (9,6),
				 (10,1),
				 (10,2);
----------===================branch============-----------

  insert into [dbo].[Branch] (BranchName , manager_id) values
      ('Minia' ,4),
	  ('Assuit', 1),
	  ('Smart', 6);

-----======intake =============-----------
select * from [dbo].[Intake]
     insert into [dbo].[Intake] ([IntakeNumber],[IntakeNumberYear]) values
	       (42,2023),
	       (43,2023),
	       (44,2023),
	       (45,2023);

----------------==============intake branch track =============---------------
select * from dbo.Intake_Branch_Track
   insert into dbo.Intake_Branch_Track ([branch_id] ,[track_id] , [number_intake]) values
         (1 , 1 ,43),
         (1 , 2 ,43),
         (2 , 1 ,43),
         (2 , 3 ,43),
         (3 , 2,43),
         (3 , 3 ,43),

		 (1 , 2 ,44),
         (3 , 3 ,44),
         (2 , 1 ,44),
         (2 , 3 ,44),
         (3 , 1 ,44),
         (3 , 2 ,44);


----------------================inserted into exam =========---------------

select * from dbo.Exams


INSERT INTO [dbo].[Exams] ([Name], [Type], [total_degree],  
[intake_branch_track_ID],[corse_id], [instractor_id], [start_time], [end_time], [Exam_day])
VALUES
    ('C#', 'exam', 100,  1, 3, 3, '09:00:00', '11:00:00', '2023-10-15'),
    ('php', 'exam', 100,  2, 5, 6, '14:00:00', '17:00:00', '2023-12-10'),
    ('Quiz 1', 'exam', 100,  1, 2, 2, '16:00:00', '16:30:00', '2023-09-20'),
    ('Lab Exam', 'exam', 100,  3, 2, 2, '13:30:00', '15:00:00', '2023-11-05'),
    ('Midterm Exam', 'exam', 100,  2, 3, 3, '10:00:00', '12:00:00', '2023-10-20'),
    ('Final Exam', 'exam', 100,  1, 3, 3, '15:00:00', '18:00:00', '2023-12-15'),
    ('Quiz 1', 'corrective', 100,  2, 4, 4, '14:00:00', '14:30:00', '2023-09-25'),
    ('Lab Exam', 'corrective', 100,  3, 4, 4, '09:30:00', '11:00:00', '2023-11-10'),
    ('Midterm Exam', 'corrective', 100, 1, 5, 5, '11:00:00', '13:00:00', '2023-10-25'),
    ('Final Exam', 'corrective', 100,  2, 5, 5, '16:00:00', '19:00:00', '2023-12-20');

   
-------========type==========-------------
select * from [dbo].[Questions_Type]

insert into [dbo].[Questions_Type] (Type) values
       ('choose'),
	   ('t&f'),
	   ('text');





--------------=================insert into exam question -----------===========

select * from[dbo].[ExamQuestions]

insert into [dbo].[ExamQuestions] (exam_id , questions_id , contant , degree) values
         (1,1,'  ' , 10),
		 (1,2,'  ' , 10),
         (1,3,'  ' , 10),
         (1,4,'  ' , 10),
         (1,5,'  ' , 10),
         (1,6,'  ' , 10),
         (1,7,'  ' , 10),
         (1,8,'  ' , 10),
         (1,9,'  ' , 10),
         (1,10,'  ' , 10),
          ----====php exam questions ====----
		 (2,16,'  ' , 10),
         (2,17,'  ' , 10),
         (2,18,'  ' , 10),
         (2,19,'  ' , 10),
         (2,20,'  ' , 10),
         (2,21,'  ' , 10),
         (2,22,'  ' , 10),
         (2,23,'  ' , 10),
         (2,24,'  ' , 10),
         (2,25,'  ' , 10);
         
----------===========Exam answers ===========-------
  select * from[dbo].[QuestionAnswer]
  -- True/False answers
INSERT INTO [dbo].[QuestionAnswer] ([questions_id], [id_anwser], [Flag], [Answer])
VALUES
    (16, 1, 1, 'True'),
    (16, 2, 0, 'False'),
    (17, 1, 1, 'True'),
    (17, 2, 0, 'False'),
    (18, 1, 1, 'True'),
    (18, 2, 0, 'False'),
	(19, 1, 1, 'True'),
    (19, 2, 0, 'False'),
    (20, 1, 1, 'True'),
    (20, 2, 0, 'False');

-- Multiple-choice answers
INSERT INTO [dbo].[QuestionAnswer] ([questions_id], [id_anwser], [Flag], [Answer])
VALUES
    (26, 1, 0, 'int32'),
    (26, 2, 0, 'string'),
    (26, 3, 1, 'bool'),
    (26, 4, 0, 'float'),
    (27, 1, 0, 'if (condition)'),
    (27, 2, 1, 'if (condition) { code block }'),
    (27, 3, 0, 'if { condition }'),
    (27, 4, 0, 'if { condition } then'),
    (28, 1, 0, 'class'),
    (28, 2, 0, 'struct'),
    (28, 3, 1, 'interface'),
    (28, 4, 0, 'enum'),
    (29, 1, 0, 'Create a new instance of a class'),
    (29, 2, 0, 'Declare a variable'),
    (29, 3, 1, 'Allocate memory for an object'),
    (29, 4, 0, 'Define a method'),
    (30, 1, 0, 'private'),
    (30, 2, 0, 'public'),
    (30, 3, 0, 'protected'),
    (30, 4, 1, 'global');

-- Text-based answers
INSERT INTO [dbo].[QuestionAnswer] ([questions_id], [id_anwser], [Flag], [Answer])
VALUES
    (36, 5, 1, 'class structure.'),
    (37, 5, 1, 'in memory.'),
    (33, 5, 1, 'each time.'),
    (34, 5, 1, 'errors.'),
    (35, 5, 1, 'programming in C#.');



              ---- =========php questions =======
			  -- True/False answers
INSERT INTO [dbo].[QuestionAnswer] ([questions_id], [id_anwser], [Flag], [Answer])
VALUES
    (16, 1, 1, 'True'),
    (17, 1, 0, 'False'),
    (18, 1, 1, 'True'),
    (19, 1, 0, 'False'),
    (20, 1, 1, 'True');

-- Multiple-choice answers
INSERT INTO [dbo].[QuestionAnswer] ([questions_id], [id_anwser], [Flag], [Answer])
VALUES
    (21, 1, 0, '$var'),
    (21, 2, 1, '$_var'),
    (21, 3, 0, '$_VAR'),
    (21, 4, 0, '$_VAR_'),
    (22, 1, 0, '<?php'),
    (22, 2, 1, '<?'),
    (22, 3, 0, '<php'),
    (22, 4, 0, '<script>'),
    (23, 1, 0, 'print()'),
    (23, 2, 1, 'echo()'),
    (23, 3, 0, 'output()'),
    (23, 4, 0, 'display()'),
   (24, 1, 0, 'print()'),
    (24, 2, 0, 'echo()'),
    (24, 3, 1, 'output()'),
    (24, 4, 0, 'display()'),


   
	INSERT INTO [dbo].[Questions] (type_id, [Contact], course_id) 
	VALUES
    -- C# Multiple-Choice Questions
    (3, 'What is the oop ', 3),
    (3, ' inherit a class ?', 3),
    (3, 'What is the  a class ?', 3),
    (3, 'What is the  c#?', 3),
    (3, 'Which collection inhert?', 3),
    (3, 'What is the  "==" or "===" ', 3),
    (3, 'Which keyword c#?', 3);
    
    -- Java Multiple-Choice Questions
    (1, 'What is the  variable in Java?', 7),
    (1, 'Which keywor in Java?', 7),
    (1, 'What is the  class in Java?', 7),
    (1, 'What is the  in Java?', 7),
    (1, 'Which collec ements?', 7),
    (1, 'What is the equals()" in Java?', 7),
    (1, 'Which keyword value in Java?', 7),
    (1, 'What is the System.out.println(x++);', 7),
    (1, 'Which type of is accessed in Java?', 7),
    (1, 'Which keyword  in Java?', 7),

    -- C# True/False Questions
    (2, 'C# is an oop language.', 3),
    (2, 'C# is case-sensitive.', 3),
    (2, 'C# supports multiple inheritance.', 3),
    (2, 'C# is platform-independent.', 3),
    (2, 'C# is primarily web development.', 3),
    -- Java True/False Questions
    (2, 'Java is an oop language.', 7),
    (2, 'Java is case-sensitive.', 7),
    (2, 'Java supports multiple inheritance.', 7),
    (2, 'Java is platform-independent.', 7),
    (2, 'Java is primarily  app development.', 7);







