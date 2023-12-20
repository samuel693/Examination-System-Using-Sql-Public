
create table Course
(
	IDcourse int identity(1,1),
	Name varchar(50) not null ,
	max_degree int not null,
	min_degree int not null,
	discraption varchar(150) null,
	track_id int null, 
	constraint coursePK primary key (IDcourse),
	constraint Coursetrack_idFK foreign key (track_id) 
	REFERENCES [dbo].[Track] ([id_track])
)
create table Exams
(
	IDexam int identity(1,1),
	Name varchar(50) not null ,
	Type char(10) default 'exam',
	intake_branch_track_ID int  null,
	corse_id int  null, 
	start_time time not null,
	end_time time not null,
	Exam_day date not null  ,
	total_time as DATEDIFF(MINUTE, Start_Time, End_Time),
	total_degree int not null,
	instractor_id int  null, 
	allowance_options varchar(50) null,
	constraint ExamsPK primary key (IDexam),
	constraint ExamsTypeCheck Check (Type in ('corrective','exam')),

	constraint Examstotal_timeCheck Check(total_time >30),
	constraint Exam_dayExamsCheck check (Exam_day >= getdate()),
	constraint end_timeDateCheck check (end_time >= start_time),
	constraint ExamsInstractor_idFK foreign key (instractor_id) 
	REFERENCES Instructor (id_instructor),
	constraint ExamsCorse_idFK foreign key (corse_id) 
	REFERENCES Course (IDcourse),

	
	constraint Examsintake_branch_track_IDFK foreign key (intake_branch_track_ID) 
	REFERENCES [dbo].[Intake_Branch_Track] ([IntakeBranchTrackID])
)

create table ExamsResult
(
	exam_id int not null, 
	student_id int not null, 
	Type char(10) default 'exam', 
	intake_branch_track_ID int not null, 
	corse_id int not null, 
	
	start_time time not null,

	end_time time not null,
	Exam_day date not null,

	total_time as DATEDIFF(MINUTE, Start_Time, End_Time),
	total_degree_student int not null,
	total_degree_exam int not null,
	flag bit not null,
	constraint ExamsResultPK primary key (exam_id,student_id),
	constraint ExamsResultTypeCheck Check (Type in ('corrective','exam')),
	
	constraint end_timeExamsResultDateCheck check (end_time > start_time),

	constraint ExamsResultStudent_idFK foreign key (student_id) 
	REFERENCES [dbo].[Student] ([id_student]),

	constraint ExamsResultExam_idFK foreign key (exam_id) 
	REFERENCES [dbo].[Exams] ([IDexam]),

	constraint ExamsResultcorse_idFK foreign key (corse_id) 
	REFERENCES [dbo].[Course] ([IDcourse]),

	constraint ExamsResultintake_branch_track_IDFK foreign key (intake_branch_track_ID) 
	REFERENCES [dbo].[Intake_Branch_Track]([IntakeBranchTrackID])
)

create table ExamAnswer
(
	exam_id int not null, 
	student_id int not null, 
	questions_id int not null, 
	answer_text varchar(20) not null,
	flag bit not null,
	degree int not null,
	constraint ExamAnswerPK primary key (exam_id,student_id,questions_id),

	constraint ExamAnswerStudent_idFK foreign key (student_id) 
	REFERENCES [dbo].[Student] ([id_student]),

	constraint ExamAnswerExam_idFK foreign key (exam_id) 
	REFERENCES [dbo].[Exams]([IDexam])

)

create table ExamQuestions
(
	exam_id int not null, 
	questions_id int not null, 
	contant varchar(20) not null,
	degree int not null,
	constraint ExamQuestionsPK primary key (exam_id,questions_id),

	constraint ExamQuestionsExam_idFK foreign key (exam_id) 
	REFERENCES [dbo].[Exams]([IDexam])
)

create table  spaseficExams
(
	exam_id int not null, 
	student_id int not null, 
	constraint spaseficExamsPK primary key (exam_id,student_id),

	constraint spaseficExamsExam_idFK foreign key (exam_id) 
	REFERENCES [dbo].[Exams]([IDexam]),

	constraint spaseficExamsStudent_idFK foreign key (student_id) 
	REFERENCES [dbo].[Student] ([id_student])
)



create table  instractorCourses
(
	course_id int not null, 
	instractor_id int not null, 
	constraint instractorCoursesPK primary key (course_id,instractor_id),

	constraint instractorCoursesCourse_idFK foreign key (course_id) 
	REFERENCES Course (IDcourse),

	constraint instractorCoursesInstractor_idFK foreign key (instractor_id) 
	REFERENCES [dbo].[Instructor]([id_instructor])
	
)

create table Useraccount(
    id_user int identity(1,1),
	user_name varchar(50) UNIQUE,
    phone VARCHAR(20),
	f_name varchar(50),
	l_name varchar(50),
	city varchar(50),
	street_name varchar(50),
	birthdate Date,
	age int,               ----function
    email varchar(100) UNIQUE,
    pass varchar(50),
	constraint UseraccountPK primary key (id_user)
	
) 

create table Instructor
(

    id_instructor int identity(1,1),
	user_id int unique not null,
    manager_id int  null ,      
	branch_id int  null, 
	constraint InstructorPK primary key (id_instructor),

	constraint InstructorUser_idFK foreign key (user_id) 
	REFERENCES Useraccount (id_user),

	constraint InstructorManager_idFK foreign key (manager_id) 
	REFERENCES Instructor (id_instructor),

	constraint Instructorbranch_idFK foreign key (branch_id) 
	REFERENCES [dbo].[Branch] ([id_branch])
) 

create  table Student(

	id_student int  ,
	user_id int unique not null,
	intake_branch_track_ID int not null, 
	department_id int not null, --fk
	constraint StudentPK primary key (id_student),

	constraint Studentdepartment_idFK foreign key (department_id) 
	REFERENCES [dbo].[Department]([id_departmant]),

	constraint StudentUser_idFK foreign key (user_id) 
	REFERENCES Useraccount (id_user)
)

create table Track_Instructor(
	instructor_id int not null,
	track_id int not null, --fk
	constraint Track_InstructorPK primary key(instructor_id , track_id),

    constraint Track_InstructorInstructor_idFK foreign key (instructor_id) 
	REFERENCES Instructor (id_instructor)  ,
	
	constraint Track_Instructortrack_idFK foreign key (track_id) 
	REFERENCES [dbo].[Track]([id_track])
)	


create table Student_Course(
	course_id int not null,
	student_id int not null,
    constraint Student_CoursePK primary key(course_id , student_id),
    constraint Student_CourseStudent_idFK foreign key (student_id) 
	REFERENCES Student (id_student),

	constraint Student_CourseCourse_idFK foreign key (course_id) 
	REFERENCES Course (IDcourse)
)
CREATE TABLE Questions 
(
    id_questions INT identity(1,1),
    type_id INT not null, 
    Contact VARCHAR(50) not null,
    course_id int not null, 
	constraint QuestionsPK primary key (id_questions),
	
	constraint Questionstype_idFK foreign key (type_id) 
	REFERENCES [dbo].[Questions_Type] (id_type),

	constraint Questionscourse_idFK foreign key (course_id) 
	REFERENCES [dbo].[Course] ([IDcourse])
);

CREATE TABLE Questions_Type 
(
	id_type INT identity(1,1) ,
	Type VARCHAR(50) not null,
	constraint Questions_TypePK primary key (id_type)
);

CREATE TABLE QuestionAnswer(
	questions_id  INT not null, 
    id_anwser INT not null, 
	Flag bit not null,
	Answer VARCHAR(50) not null
	constraint QuestionAnswerPK primary key (questions_id,id_anwser),
	
	constraint QuestionAnswertype_idFK foreign key (questions_id) 
	REFERENCES [dbo].[Questions] (id_questions)
);

CREATE TABLE Department(
	id_departmant INT identity(1,1),
	DepatrmentName VARCHAR(50) not null,
	manager_id  INT null, 
	constraint DepartmentPK primary key (id_departmant),
	
	constraint DepartmentManager_idFK foreign key (manager_id) 
	REFERENCES [dbo].[Instructor] ([id_instructor]),
)

CREATE TABLE Intake_Branch_Track(
	IntakeBranchTrackID INT identity(1,1) UNIQUE,
	branch_id  INT not null,
	track_id  INT not null,
	number_intake  INT not null,
	constraint Intake_Branch_TrackPK 
	primary key (number_intake,track_id,branch_id),

	constraint Intake_Branch_Trackbranch_idFK foreign key (branch_id) 
	REFERENCES [dbo].[Branch] ([id_branch]),

	constraint Intake_Branch_Tracktrack_idFK foreign key (track_id) 
	REFERENCES [dbo].[Track] ([id_track]),

	constraint Intake_Branch_Tracknumber_intakeFK foreign key (number_intake) 
	REFERENCES [dbo].[Intake] (IntakeNumber),
);

CREATE TABLE Track(
	id_track INT identity(1,1),
	TrackName VARCHAR(50) not null,
	supervisior_id INT null,
	constraint TrackPK primary key (id_track),

	constraint Tracksupervisior_idFK foreign key (supervisior_id) 
	REFERENCES [dbo].[Instructor] ([id_instructor])
);

CREATE TABLE Branch(
	id_branch INT identity(1,1),
	BranchName VARCHAR(50) not null,
	manager_id INT null,
	constraint BranchPK primary key (id_branch),

	constraint BranchManager_idFK foreign key (manager_id) 
	REFERENCES [dbo].[Instructor] ([id_instructor])
);

CREATE TABLE Intake(
	IntakeNumber INT not null,
	IntakeNumberYear int default Year(getdate()) not null ,
	constraint IntakePK primary key (IntakeNumber)
);