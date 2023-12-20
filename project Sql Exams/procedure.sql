/*
exec delet_Q_add_QAnswer @Contact ='what is c#',@email ='Msaboor@gmail.com',
@course_name ='c#'


exec Update_two_table_Q_and_Qanswer
@newtype_name ='choose',@oldContact ='what is C##' ,@newContact ='what is c#',
@oldcourse_name ='ISQN',@newcourse_name ='c#',@newcorrectAnswer ='pl' ,
@email ='Msaboor@gmail.com',@newAnswer1 ='pl',@newAnswer2 ='ml',
@newAnswer3 ='sl',@newAnswer4 ='kl'



exec insert_two_table @type_name ='choose' , @Contact ='what is Node JS',@correctAnswer ='kl',
@Answer1 ='ml',@Answer2 ='pl' ,@Answer3 ='sl',@Answer4 ='kl',
@course_name ='Node JS',@email='Msaboor@gmail.com'

exec insert_two_table @type_name ='text', @Contact ='string is mojkkfhj',@correctAnswer ='no '
,@course_name ='c#',@email='Msaboor@gmail.com'


exec insert_two_table @type_name ='T/F',  @Contact ='is it not importane',
@correctAnswer ='true',@course_name ='MySql',@email='samaoul@gmail.com', 
@Answer1 ='false',@Answer2 ='true'
*/
------------------------------------------------
go
alter FUNCTION get_id_instructor(@email varchar(100))  
RETURNS @resl TABLE (id_instructor int) AS  
BEGIN  
    INSERT INTO @resl 
	select  id_instructor from Instructor where user_id =
	(select id_user  from Useraccount where email=@email) 
    RETURN  
END
go
alter function Total_Degree_question(@Exam_Id int,@degree int)
returns int
as
begin
declare @total_degree int ;
	select @total_degree = sum(degree)
	from ExamQuestions 
	where exam_id= @Exam_Id 
	if(@total_degree is NUll)
	begin
		set @total_degree=@degree;
	end
	else
		set @total_degree = @total_degree+@degree

	return @total_degree;
end
go
create function Total_Degree_student
(@student_id int,@Exam_Id int)
returns int
as
begin
declare @total_degree int ;
	select @total_degree = sum(degree)
	from ExamAnswer
	where exam_id= @Exam_Id and student_id = @student_id
	if(@total_degree is NUll)
	begin
		set @total_degree=0;
	end
	return @total_degree;
end
-------------------------------------------
go
alter FUNCTION get_flag(@questions_id int, @answer_text varchar(50),@degree int)  
RETURNS @resl TABLE (flag bit,degree int) AS  
BEGIN  
	declare @correctAnswer varchar(50)
	select @correctAnswer= Answer from QuestionAnswer 
	where questions_id = @questions_id and Flag =1;
	if(@correctAnswer = @answer_text)
	begin
		INSERT INTO @resl (flag,degree) values (1,@degree);
	end
	else
	begin
		INSERT INTO @resl (flag,degree) values (0,0);
	end
    RETURN  
END

go
create FUNCTION get_id_student(@email varchar(100))  
RETURNS @resl TABLE (id_student int) AS  
BEGIN  
    INSERT INTO @resl 
	select  id_student from Student where user_id =
	(select id_user  from Useraccount where email=@email) 
    RETURN  
END
go
----------------------------------------
-- get all courses that instractor trach
go
alter FUNCTION getcourses(@email varchar(100))  
RETURNS @resl TABLE (course_id int) AS  
BEGIN  
    INSERT INTO @resl  
	select course_id from instractorCourses where instractor_id = 
	(select id_instructor from Instructor where user_id =
	(select id_user  from Useraccount where email=@email))  
    RETURN  
END 

--------------------------------------
-- get contact of all [Questions] in [Course]
go
alter FUNCTION getQforcours(@course_id int)  
RETURNS @resl TABLE (Contact varchar(50)) AS  
BEGIN 
    INSERT INTO @resl  
	select Contact  from Questions where course_id= @course_id   
    RETURN  
END

--------------------------------------------
--isert into [QuestionAnswer]and[Questions]
go
alter proc insert_two_table
(@type_name varchar (50),@Contact varchar(50),@course_name varchar(50),
@correctAnswer varchar(50),@email varchar(100),@Answer1 varchar(50)=null,
@Answer2 varchar(50)=null,@Answer3 varchar(50)=null,@Answer4 varchar(50)=null)
AS
begin
	declare  @type_id int , @course_id int ;
	if exists (select id_type from Questions_Type where Type = @type_name)
	and exists( select IDcourse from Course where Name = @course_name)
	begin
		select @type_id = id_type from Questions_Type where Type = @type_name
		select @course_id = IDcourse from Course where Name = @course_name
		if ( @course_id in (select * from getcourses(@email)))
		begin
			if ( @Contact in (select * from getQforcours(@course_id)))
				print 'Questions is exist in this corse'
			else
			begin
				declare @questions_id int, @id_anwser int = 1 ,@count int =1 ,
				@flag int =1, @Answer varchar(50), @correctNum int =0;
				declare @Answers TABLE (Answer varchar(50))
				insert into @Answers
				values(@Answer1),(@Answer2),(@Answer3),(@Answer4);
				declare PrintAnswer CURSOR  for  select Answer from @Answers  
				begin transaction
				if (@type_id>3 or @type_id<1)
				begin
					rollback;
				end
				else if (@type_id=3)
				begin
							insert into Questions(type_id,Contact,course_id) 
							values(@type_id,@Contact,@course_id);
		
							select @questions_id= MAX(id_questions) from Questions
		
							insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
							values(@questions_id ,5 , @flag ,@correctAnswer);
							commit;
						end
				else if (@type_id=2)
				begin
							insert into Questions(type_id,Contact,course_id) 
							values(@type_id,@Contact,@course_id);
							select @questions_id= MAX(id_questions) from Questions
							open PrintAnswer  
							while @count <= 4
							begin
								fetch next from PrintAnswer into  @Answer
								set @flag  = 1
								if (@correctAnswer!=@Answer)
								begin
									set @flag  = 0
									set @correctNum  =@correctNum+1
								end
								insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
								values(@questions_id ,@id_anwser ,@flag ,@Answer);
								set @count =@count+1;
								set @id_anwser =@id_anwser+1
							end
								/*	
								insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
								values(@questions_id ,@id_anwser ,1 ,@correctAnswer);
								insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
								values(@questions_id ,@id_anwser ,0 ,@correctAnswer);   */
							if(@correctNum<4)
								commit;
							else
							begin
								print 'enter correct Answer'
								rollback;
							end
						end
				else if (@type_id=1)
				begin
							insert into Questions(type_id,Contact,course_id) 
							values(@type_id,@Contact,@course_id);
		
							select @questions_id= MAX(id_questions) from Questions
							if (@correctAnswer=@Answer1)
								begin
									insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
									values(@questions_id ,1 , 1 ,@Answer1);
									insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
									values(@questions_id ,2 , 0 ,@Answer2);
									commit;
								end
							else if (@correctAnswer=@Answer2)
								begin
									insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
									values(@questions_id ,1 , 0 ,@Answer1);
									insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
									values(@questions_id ,2 , 1 ,@Answer2);
									commit;
								end
							else 
							begin
								print 'enter correct Answer'
								rollback;
							end
						end
			print 'thanks mohamed'
			end
		end
		else
			print 'incorect corse or incorect instractor or this instractor 
			not teach this corse '
	end
	else
		print 'type error enter T/F OR choose OR text ///
			   corses name is invalid'
end

---------------------------------------------

go
alter proc Update_two_table_Q_and_Qanswer
(@newtype_name varchar (50),@oldContact varchar(50),@newContact varchar(50),@oldcourse_name varchar(50),
@newcourse_name varchar(50),@newcorrectAnswer varchar(50),@email varchar(100),@newAnswer1 varchar(50)=null,
@newAnswer2 varchar(50)=null,@newAnswer3 varchar(50)=null,@newAnswer4 varchar(50)=null)
AS
begin
	declare  @type_id int , @newcourse_id int ,@oldcourse_id int,@questions_id int
	if exists (select id_type from Questions_Type where Type = @newtype_name)
	and exists( select IDcourse from Course where Name = @newcourse_name)
	and exists( select IDcourse from Course where Name = @oldcourse_name)
	and exists( select id_questions from [dbo].[Questions] where Contact = @oldContact)
	begin
		select @type_id = id_type from Questions_Type where Type = @newtype_name
		select @newcourse_id = IDcourse from Course where Name = @newcourse_name
		select @oldcourse_id = IDcourse from Course where Name = @oldcourse_name
		select @questions_id =id_questions from [dbo].[Questions] where Contact = @oldContact 
		if (@newcourse_id in (select * from getcourses(@email))and @oldcourse_id in (select * from getcourses(@email)))
		begin
			if ( @newContact in (select * from getQforcours(@newcourse_id)))
				print 'this Questions is exists'
			else
			begin
				declare  @id_anwser int = 1 ,@count int =1 ,
				@flag int =1, @Answer varchar(50), @correctNum int =0 ;
				declare @Answers TABLE (Answer varchar(50))
				insert into @Answers
				values(@newAnswer1),(@newAnswer2),(@newAnswer3),(@newAnswer4);
				declare PrintAnswer CURSOR  for  select Answer from @Answers 
				begin transaction
				if (@type_id>3 or @type_id<1)
				begin
					print 'type error enter T/F OR choose OR text'
					rollback;
				end
				else if (@type_id=3)
				begin
					update Questions
					set type_id =@type_id ,Contact =@newContact,course_id =@newcourse_id
					where id_questions =@questions_id;
					
					delete  from QuestionAnswer
					where questions_id =@questions_id
					insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
					values(@questions_id ,5 , @flag ,@newcorrectAnswer);
					commit;
				end
				else if (@type_id=2)
				begin
					update Questions
					set type_id =@type_id ,Contact =@newContact,course_id =@newcourse_id
					where id_questions =@questions_id;

					delete  from QuestionAnswer
					where questions_id =@questions_id
					open PrintAnswer  
					while @count <= 4
					begin
						fetch next from PrintAnswer into  @Answer
						set @flag  = 1
						if (@newcorrectAnswer!=@Answer)
						begin
							set @flag  = 0
							set @correctNum  =@correctNum+1
						end
						insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
						values(@questions_id ,@id_anwser ,@flag ,@Answer);
						set @count =@count+1;
						set @id_anwser =@id_anwser+1
					end
					if(@correctNum<4)
						commit;
					else 
					begin
						print 'enter correct Answer'
						rollback;
					end
				end
				else if (@type_id=1)
				begin
					update Questions
					set type_id =@type_id ,Contact =@newContact,course_id =@newcourse_id
					where id_questions =@questions_id;

					delete  from QuestionAnswer
					where questions_id =@questions_id
					if (@newcorrectAnswer=@newAnswer1)
					begin
						insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
						values(@questions_id ,1 , 1 ,@newAnswer1);
						insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
						values(@questions_id ,2 , 0 ,@newAnswer2);
						commit;
					end
					else if (@newcorrectAnswer=@newAnswer2)
					begin
						insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
						values(@questions_id ,1 , 0 ,@newAnswer1);
						insert into QuestionAnswer(questions_id,id_anwser,Flag,Answer) 
						values(@questions_id ,2 , 1 ,@newAnswer2);
						commit;
						end
					else
					begin
						print 'enter correct Answer'
						rollback;
					end
				end
				print 'thanks mohamed '
			end
		end
		else
			print 'incorect course or incorect instractor or this instractor 
			not teach this corse '
	end
	else
		print 'type error enter T/F OR choose OR text ///
			   corses name is invalid OR Questions is not exists'
end
--------------------------------------- 
go
alter trigger delete_Q_add_QAnswer 
on [dbo].[Questions] instead of delete
as begin
	select * from deleted
	declare @id_questions int
	select @id_questions= id_questions from deleted
	delete from [dbo].[QuestionAnswer]
	where questions_id=@id_questions
	delete from [dbo].[Questions]
	where id_questions=@id_questions
end
---------------------------------------------
go
alter proc delet_Q_add_QAnswer (@Contact varchar(50),@email varchar(100),@course_name varchar(50))
AS
BEGIN
	declare   @course_id int ;
	if exists( select IDcourse from Course where Name = @course_name)
	begin
		select @course_id = IDcourse from Course where Name = @course_name
		if ( @course_id in (select * from getcourses(@email)))
		begin
			if ( @Contact in (select * from getQforcours(@course_id)))
			begin
				delete from [dbo].[Questions] where Contact = @Contact and course_id =@course_id
				print 'thanks mohamed'
			end
			else
				print 'this Question is not exists'
		end
		else
			print 'incorrect instractor or this instractor not teach this corse '
	end
	else
		print 'corse name is invalid'
END

exec display_Q_QAnswer @courseName ='C#' ,@email ='Msaboor@gmail.com'
go
alter view Q_QAnswer AS 
select  questions_id,Type , Contact ,flag ,Answer ,Name as coursName
from Questions_Type, Questions , QuestionAnswer  ,Course 
where [questions_id] =[id_questions] and type_id=id_type and IDcourse = course_id


-----------------------
go
alter proc display_Q_QAnswer (@courseName varchar(50), @email varchar(50)) as
begin
	declare @course_id int 
	if exists( select IDcourse from Course where Name = @courseName)
	begin
		select @course_id = IDcourse from Course where Name = @courseName
		begin try
			if(@course_id in (select * from getcourses(@email)))
			begin
				select * from Q_QAnswer where coursName = @courseName;
			end
			else
				throw 51000,'incorrect instractor or this instractor not teach this corse ',16;
		end try
		begin catch 
			print ERROR_MESSAGE();
		end catch
	end
	else
		print 'corse name is invalid'
end

select * from [dbo].[Exams]
go

alter  proc insertintoExams 
(@Name varchar(50), @Type char(10),@intake_branch_track_ID int,@email varchar(100),
@courseName varchar(50), @start_time time ,@end_time time ,@Exam_date date)
as
begin
	declare @course_id int , @id_instructor int , @total_degree int
	if exists( select IDcourse from Course where Name = @courseName)
	begin
		if exists( select IntakeBranchTrackID from Intake_Branch_Track where IntakeBranchTrackID = @intake_branch_track_ID)
		begin
			if exists(select id_instructor from get_id_instructor(@email))
			begin
				select @id_instructor = id_instructor from get_id_instructor(@email)
				select @course_id = IDcourse from Course where Name = @courseName
				if exists(select * from Course where IDcourse = @course_id  and track_id =
				(select track_id from Intake_Branch_Track where IntakeBranchTrackID = @intake_branch_track_ID))
				begin
					if((DATEDIFF(MINUTE, @Start_Time, @End_Time))>30)
					begin
						if(@course_id in (select * from getcourses(@email)))
						begin
							select @total_degree= max_degree from Course where IDcourse =@course_id
							begin try
						
								insert into Exams([Name],[Type],[total_degree],[intake_branch_track_ID],[corse_id],[instractor_id],
								[start_time],[end_time],[Exam_day])
								values (@Name,@Type,@total_degree,@intake_branch_track_ID,@course_id,@id_instructor
								,@start_time,@end_time,@Exam_date)
												
							end try	
							begin catch
								print 'enter valid type exam or corrective and make start_time less than end_time and Exam_date greater than cruent day '
							end catch
						end
						else
							print 'this instractor not teach this course'
					end
					else
						print 'make tim exam greater than 30 m'
				end
				else
					print 'this coure not below the track'
			end 
			else
				print 'incorrect email'
		end
		else
			print 'incorrect Intake'
		end
	else
		print 'incorrect course'
end

/*
exec  insertintoExams 
@Name='c#', @Type ='exam',@intake_branch_track_ID =4,@email ='Msaboor@gmail.com',
@courseName ='c#', @start_time ='10:00' ,@end_time ='11:00' ,@Exam_date ='2023-09-20'
*/
go
alter proc updateintoExams 
(@id_Exam int ,@newName varchar(50), @newType char(10),@new_intake_branch_track_ID int,@email varchar(100),
@courseName varchar(50), @newstart_time time ,@newend_time time ,@newExam_date date)
as
begin
	if exists (select IDexam from Exams where IDexam = @id_Exam)
	begin
		declare @course_id int , @id_instructor int , @total_degree int
		if exists(select corse_id from Exams where corse_id =
		(select IDcourse from Course where Name = @courseName))
		begin
			select @course_id = corse_id from Exams where IDexam = @id_Exam
			if exists( select IntakeBranchTrackID from Intake_Branch_Track where IntakeBranchTrackID = @new_intake_branch_track_ID)
			begin
				select @id_instructor = id_instructor from get_id_instructor(@email)
				if exists(select instractor_id from Exams where instractor_id = @id_instructor and IDexam =@id_Exam)
				begin
					if exists(select * from Course where IDcourse = @course_id  and track_id =
					(select track_id from Intake_Branch_Track where IntakeBranchTrackID = @new_intake_branch_track_ID))
					begin
						if((DATEDIFF(MINUTE, @newStart_Time, @newEnd_Time))>30)
						begin
							if(@course_id in (select * from getcourses(@email)))
							begin
								select @total_degree= max_degree from Course where IDcourse =@course_id
								begin try
									update Exams
									set [Name]=@newName,[Type]=@newType,[intake_branch_track_ID]=@new_intake_branch_track_ID,
									[corse_id]=@course_id,[instractor_id]=@id_instructor,[start_time]=@newstart_time,
									[end_time]=@newend_time,[Exam_day]=@newExam_date ,total_degree = @total_degree
									where IDexam=@id_Exam
								end try	
								begin catch
									print 'enter valid type exam or corrective and make start_time less than end_time and Exam_date greater than cruent day '
								end catch
							end
							else
								print 'this instactor does not teach this course'
						end
						else
							print 'make time exam greater than 30m'
					end
					else
						print 'this coure not below the track'
				end 
				else
					print 'incorrect instractor'
			end
			else
				print 'incorrect Intake'
		end
		else
			print 'incorrect course'
	end
	else
		print 'incorrect id_Exam'
end
/*
exec  updateintoExams @id_Exam = 12,
@newName ='C#', @newType ='corrective', @new_intake_branch_track_ID = 4, @newemail ='Msaboor@gmail.com',
@newcourseName ='C#', @newstart_time ='10:29' ,@newend_time ='11:00' ,@newExam_date ='2023-09-20'
*/
go
alter trigger delele_Exam 
on [dbo].[Exams] instead of delete
as begin
	if not exists(select * from Exams where IDexam = (select IDexam from deleted))
		print 'this exam does not exist'
	print 'you cannot delete exam this data is important'
end
 
go
alter proc insertintoExams_Q 
(@exam_id int, @contant varchar(50) ,@email varchar(100) ,@courseName varchar(50),@degree int)
as
begin
	if exists (select IDexam from Exams where IDexam = @exam_id)
	begin
		declare @course_id int , @id_instructor int ,@questions_id int 
		if exists( select IDcourse from Course where Name = @courseName)
		begin
			if exists(select id_instructor from get_id_instructor(@email))
			begin
				select @id_instructor = id_instructor from get_id_instructor(@email)
				select @course_id = IDcourse from Course where Name = @courseName
				if (@contant in (select * from getQforcours(@course_id)))
				begin
					if exists( select corse_id from Exams where corse_id = @course_id)
					begin 
						if exists (select instractor_id from Exams 
						where instractor_id =@id_instructor and IDexam =@exam_id )
						begin
							begin try
							select @questions_id = id_questions from Questions 
							where Contact =@contant and course_id = @course_id
							insert into ExamQuestions (exam_id,questions_id,contant,degree)
							values (@exam_id,@questions_id,@contant,@degree)
							end try
							begin catch
								print ERROR_MESSAGE();
							end catch
						end
						else
							print 'this instactor does not put this exam'
					end
					else
						print 'contant of corese not below this exam '
				end
				else
					print 'this contant not in course'
			end
			else
				print 'incorrect email'
		end
		else
			print 'incorrect course'
	end
	else
		print'incorrect exam'
end
select * from Q_QAnswer 
exec  insertintoExams_Q 
@exam_id =15, @contant = 'what is SqlServer' ,@email ='Msaboor@gmail.com' ,
@courseName ='SqlServer',@degree = 10


go
alter trigger insert_Exam_Q 
on [dbo].[ExamQuestions] instead of insert
as 
begin
	declare @degree int ,@exam_id int , @questions_id int , @contant varchar(50), @total_degree int 
	select @degree = degree , @exam_id= exam_id ,
	@questions_id =questions_id , @contant =contant from inserted
	select @total_degree = total_degree from Exams where IDexam =@exam_id
	if (@total_degree >=dbo.Total_Degree_question(@exam_id,@degree))
	begin
		insert into ExamQuestions(exam_id,questions_id,contant,degree)
		values (@exam_id,@questions_id,@contant,@degree)
	end
	else
		print 'the ExamQuestions degree is greater than total_degree of this exam '
end
go
alter trigger update_Exam_Q 
on [dbo].[ExamQuestions] instead of update
as 
begin
	declare @degree int , @olddegree int , @exam_id int , @questions_id int ,
	@contant varchar(50),@oldcontant varchar(50), @total_degree int 
	select @degree = degree , @exam_id= exam_id ,
	@questions_id =questions_id , @contant =contant from inserted
	select @olddegree = degree ,@oldcontant = contant  from deleted
	select @total_degree = total_degree from Exams where IDexam =@exam_id
	if ((@total_degree+@olddegree)>=dbo.Total_Degree_question(@exam_id,@degree))
	begin
		update ExamQuestions 
		set questions_id = @questions_id,
		contant = @contant ,degree = @degree
		where exam_id =@exam_id and contant= @oldcontant
	end
	else
		print 'the ExamQuestions degree is greater than total_degree of this exam '
end
go
go
/*
exec  updateExams_Q 
@exam_id =14, @oldcontant = 'what is c#',@newcontant = 'what is C# framwork' ,
@email ='Msaboor@gmail.com' ,@courseName ='c#',@newdegree =15*/
go
alter proc updateExams_Q 
(@exam_id int, @newcontant varchar(50),@oldcontant varchar(50) ,
@email varchar(100) ,@courseName varchar(50),@newdegree int)
as
begin
	if exists (select exam_id from ExamQuestions where exam_id = @exam_id)
	begin
		declare @course_id int , @id_instructor int ,@questions_id int 
		if exists( select IDcourse from Course where Name = @courseName)
		begin
			select @course_id = IDcourse from Course where Name = @courseName
			if exists(select id_instructor from get_id_instructor(@email))
			begin
				select @id_instructor = id_instructor from get_id_instructor(@email)
				if (@newcontant  in (select * from getQforcours(@course_id))
				and @oldcontant  in (select * from getQforcours(@course_id)))
				begin
					if exists( select corse_id from Exams where corse_id = @course_id)
					begin 
						if exists (select instractor_id from Exams 
						where instractor_id =@id_instructor and IDexam =@exam_id )
						begin
							if exists (select questions_id from ExamQuestions where contant =@oldcontant)
							begin
								begin try
									select @questions_id = id_questions  from Questions
									where Contact =@newcontant
									update ExamQuestions 
									set questions_id = @questions_id,
									contant = @newcontant ,degree = @newdegree
									where contant = @oldcontant and exam_id =@exam_id
								end try
								begin catch							
									print ERROR_MESSAGE();
								end catch
							end
							else
								print 'the old questions is not exist in exam'
						end
						else
							print 'this instactor does not put this exam'
					end
					else
						print 'contant of corese not below this exam '
				end
				else
					print 'this newcontant not in course or this oldcontant not in course'
			end
			else
				print 'incorrect email'
		end
		else
			print 'incorrect course'
	end
	else
		print'incorrect exam'
end





/*
exec deleteExams_Q 
@exam_id= 13,@contant ='what is C# framwork' ,@email ='Msaboor@gmail.com'*/
go
alter proc deleteExams_Q 
(@exam_id int,@contant varchar(50) ,@email varchar(100))
as
begin
	if exists (select exam_id from ExamQuestions where exam_id = @exam_id)
	begin
		if exists(select id_instructor from get_id_instructor(@email))
		begin
			declare @id_instructor int 
			select @id_instructor = id_instructor from get_id_instructor(@email)
			if exists (select instractor_id from Exams where instractor_id =@id_instructor and IDexam =@exam_id )
			begin
				if exists (select questions_id from ExamQuestions 
				where contant =@contant and exam_id = @exam_id)
				begin
					delete ExamQuestions 
					where contant =@contant and exam_id = @exam_id
				end
				else
					print 'the questions is not exist in exam'
			end
			else
				print 'this instactor does not put this exam'
		end
		else
			print 'incorrect email'
	end
	else
		print'incorrect exam'	
end
go
exec showAllQuestion 14
go
create or alter proc showAllQuestion
(@exam_id int)
as
begin try
	select *from
	(select id_questions,Contact,Answer,id_anwser,type
	from Questions , QuestionAnswer , ExamQuestions ,Questions_Type
	WHERE Questions.id_questions = QuestionAnswer.questions_id and type_id= id_type
	and ExamQuestions.exam_id =@exam_id and  Questions.id_questions= ExamQuestions.questions_id) as e 
	PIVOT(max(Answer) for id_anwser in ([1],[2],[3],[4])) as PVT
end try
begin catch
	select ERROR_NUMBER(),ERROR_MESSAGE()
end catch

go
exec select_Question_Random 
@number_Quest =2 ,@courseName ='SqlServer',@Exam_Id =15,@email ='yahiazak@gmail.com',@Q_Degree =15
go
create or alter procedure select_Question_Random
(@number_Quest int ,@courseName varchar(50),@Exam_Id int,@email varchar(100),@Q_Degree int)
as 
begin
	if exists (select IDexam from Exams where IDexam = @Exam_Id)
	begin
		declare @course_id int , @id_instructor int ,@questions_id int,
		 @last_Q int,@i int =1,@rundom_Quest int ,@Count_Course_Q int ,@contant varchar(20);
		 declare @total_Q table (questions_id int);
		SELECT @last_Q= max(id_questions) FROM Questions;
		if exists( select IDcourse from Course where Name = @courseName)
		and exists (select * from Exams where IDexam =@Exam_Id and [corse_id] =
		(select IDcourse from Course where Name = @courseName))
		begin
			if exists(select id_instructor from get_id_instructor(@email))
			begin
				select @id_instructor = id_instructor from get_id_instructor(@email)
				select @course_id = IDcourse from Course where Name = @courseName
				SELECT  @Count_Course_Q=count(course_id) FROM Questions where course_id=@course_id;
				if exists (select instractor_id from Exams 
				where instractor_id =@id_instructor and IDexam =@exam_id)
				begin
					if (@number_Quest <=@Count_Course_Q )
					begin
					while (@i<=@number_Quest) 
						begin 
							set @rundom_Quest=CEILING(RAND() * @last_Q)
							if exists(select * from Questions  where course_id=@course_id and id_questions=@rundom_Quest)
							begin
								if not exists(select * from @total_Q  where questions_id=@rundom_Quest)
								begin
									insert into @total_Q values(@rundom_Quest)
									 if Exists(select * from ExamQuestions where exam_id =@Exam_Id and [questions_id]=@rundom_Quest)
									begin
										 select @contant=Contact from Questions where id_questions = @rundom_Quest
										 update ExamQuestions
										 set degree=@Q_Degree
										 where exam_id =@Exam_Id and [questions_id]=@rundom_Quest
										 
									end
									else
									begin
										 select @contant=Contact from Questions where id_questions = @rundom_Quest
										 insert into ExamQuestions(Exam_Id,questions_id,contant,degree)
										 values(@Exam_Id,@rundom_Quest,@contant,@Q_Degree);
									end
									set @i=@i+1;
								end
							end
						end
						select *from @total_Q
						print dbo.Total_Degree_question(@Exam_Id,0)
						if(dbo.Total_Degree_question(@Exam_Id,0)<
						(select total_degree from Exams where IDexam =@Exam_Id ))
						begin
							print 'you must insert valid_degree for Q' 
							--print concat(''+((select total_degree from Exams where IDexam =15 )/@number_Quest))
						end
					end
					else
					begin
						 print 'The number of questions you requested is greater than the available number of questions.
						Please ask for a smaller number or Exam Is Not Exam';
					end
				end
				else
					print 'this instactor does not put this exam'
			end
			else
				print 'incorrect email'
		end
		else
			print 'incorrect course or coures is not valid to exam'
	end
	else
		print'incorrect exam'
end
go

alter proc insertintoExam_for_student(@email varchar(100),@Exam_id int)
as
begin
	declare @id_student int
	if exists(select IDexam from Exams where IDexam = @Exam_Id)
	begin
		if exists(select id_student from get_id_student(@email))
		begin
			select @id_student= id_student from get_id_student(@email)
			if exists(select * from Student_Course where  
			course_id =(select corse_id from Exams where IDexam = @Exam_id)
			and student_id = @id_student)
			begin
				if ('corrective'=(select Type from Exams where IDexam = @Exam_id))
				begin
					if exists(select * from [dbo].[ExamsResult] where student_id = @id_student
					and corse_id=(select corse_id from Exams where IDexam = @Exam_id)
					and flag=0)
					begin
						insert into [dbo].[spaseficExams](exam_id,student_id)
						values (@Exam_id,@id_student)
					end
				end
				else if not exists(select * from [dbo].[ExamsResult] where student_id= @id_student and  corse_id =
				(select corse_id from Exams where IDexam = @Exam_id))
				and  exists (select * from Student where id_student= @id_student and [intake_branch_track_ID] =
				(select [intake_branch_track_ID] from Exams where IDexam = @Exam_id))
				begin
					insert into [dbo].[spaseficExams](exam_id,student_id)
					values (@Exam_id,@id_student)
				end
				else
					print 'this student exam this exam in this intake of course'
			end
			else
				print 'this student not below this exam course'
		end
		else
			print'incorrect student email'
	end
	else
		print'incorrect exam'
end
go
exec insertintoExam_for_student @email='saboormohamed@gmail.com' ,@Exam_id=13
go
alter proc updateExam_for_student(@newemail varchar(100),@oldemail varchar(100),
 @newExam_id int,@oldExam_id int)
as
begin
	declare @newid_student int , @oldid_student int
	if exists(select IDexam from Exams where IDexam = @newExam_id)
	and exists(select IDexam from Exams where IDexam = @oldExam_id)
	begin
		if exists(select id_student from get_id_student(@newemail))
		and exists(select id_student from get_id_student(@oldemail))
		begin
			select @newid_student = id_student from get_id_student(@newemail)
			select @oldid_student = id_student from get_id_student(@oldemail)
			if exists(select * from Student_Course where  
			course_id =(select corse_id from Exams where IDexam = @newExam_id)
			and student_id = @newid_student)
			begin
				if ('corrective'=(select Type from Exams where IDexam = @newExam_id))
				begin
					if exists(select * from [dbo].[ExamsResult] where student_id = @newid_student
					and corse_id=(select corse_id from Exams where IDexam = @newExam_id)
					and flag=0)
					begin
						update spaseficExams
						set exam_id=@newExam_id,student_id = @newid_student
						where exam_id =@oldExam_id and student_id = @oldid_student
					end
				end
				else if not exists(select * from [dbo].[ExamsResult] where corse_id =
				(select corse_id from Exams where IDexam = @newExam_id))
				and exists (select * from Student where id_student=@newid_student and [intake_branch_track_ID] =
				(select [intake_branch_track_ID] from Exams where IDexam = @newExam_id))
				begin
					update spaseficExams
					set exam_id=@newExam_id,student_id = @newid_student
					where exam_id =@oldExam_id and student_id = @oldid_student
				end
				else 	
					print 'this student exam this exam in this intake of course'
			end
			else
				print 'this student not below this exam course'
		end
		else
			print'incorrect student email'
	end
	else
		print'incorrect exam'
end
go
exec updateExam_for_student @oldemail='ahmedhos@gmail.com',@newemail='saboormohamed@gmail.com',
@oldExam_id=14, @newExam_id=15
go
alter proc deleteExam_for_student(@email varchar(100),@Exam_id int)
as
begin
	declare @id_student int
	if exists(select IDexam from Exams where IDexam = @Exam_Id)
	begin
		if exists(select id_student from get_id_student(@email))
		begin
			select @id_student= id_student from get_id_student(@email)
			
			delete  [dbo].[spaseficExams]
			where exam_id =@Exam_id and student_id =@id_student
		end
		else
			print 'incorrect student email'
	end
	else
		print 'incorrect exam'
end
go
exec deleteExam_for_student 'saboormohamed@gmail.com',15

go
create or alter proc Display_QExam_To_Student(@email varchar(100) ,@Exam_Id int)
as 
begin
	declare @id_student int
	if exists(select IDexam from Exams where IDexam = @Exam_Id)
	begin
		if exists(select id_student from get_id_student(@email))
		begin
			select @id_student= id_student from get_id_student(@email)
			if exists (select * from spaseficExams 
			where exam_id =@Exam_Id and student_id =@id_student)
			begin
				declare @start_Time time,@End_Time Time,@current_Time time,@Current_Date date,@Exam_Date date;
				select @current_Time=CURRENT_TIMESTAMP AT TIME ZONE 'Egypt Standard Time';
				select @Current_Date=GETDATE();
				select @start_Time=start_time,@End_Time=end_time,@Exam_Date=Exam_day
				from Exams where IDexam = @Exam_Id
				if(@current_Time not between @start_Time and @End_Time) or (@Current_Date!=@Exam_Date)
				begin
					print 'Exam Closed' -- /////////////////////////////////////
				end
				else
				begin
				   exec showAllQuestion @Exam_Id
				end
			end
			else
				print 'student does not have exam'
		end
		else
			print 'incorrect student email'
	end
	else
		print 'incorrect exam'	
end

go
exec Display_Exam_To_Student @email = 'saboormohamed@gmail.com',@Exam_Id= 15 
go
alter proc Display_All_Exams_to_student(@email varchar(50))
as 
begin
select IDexam as exam_id, name,type,total_degree,start_time,end_time,Exam_day from Exams where IDexam  in (select exam_id from spaseficExams 
where student_id = (select id_student from get_id_student(@email))) 
end
go
--exec Display_All_Exams_to_student @email='saboormohamed@gmail.com'
go
create or alter proc Insert_Answer_OF_Student
(@id_question int ,@Answer nvarchar(50)='',@email varchar(50),@Exam_Id int)
as
begin
	--join to find or determined Question Find At any Exam
	declare @start_Time time,@End_Time Time,@current_Time time,@Current_Date date,@Exam_Date date;
	select @current_Time=CURRENT_TIMESTAMP AT TIME ZONE 'Egypt Standard Time';
	select @Current_Date=GETDATE();
	declare @degree int ,@id_student int ,@flag bit ;
	if exists(select id_student from get_id_student(@email))
	begin
		select @id_student=id_student from get_id_student(@email)
		if exists(select * from spaseficExams where student_id =@id_student and exam_id =@Exam_Id)
		begin 
			if exists(select * from ExamQuestions where questions_id =@id_question
			and exam_id =@Exam_Id)
			begin 
				select @degree= degree from ExamQuestions 
				where exam_id=@Exam_Id and questions_id=@id_question;
				
				select @start_Time=start_time,@End_Time=end_time,@Exam_Date=Exam_day
				from Exams where IDexam=@Exam_Id;
				if(@current_Time between @start_Time and @End_Time) and (@Current_Date = @Exam_Date)
				begin
					if not Exists (select * from [dbo].[ExamAnswer]
					where student_id= @id_student and exam_id=@Exam_Id 
					and questions_id=@id_question)
					begin
						select @degree=degree,@flag =flag 
						from get_flag(@id_question,@Answer,@degree)
						insert into [dbo].[ExamAnswer](exam_id,student_id,questions_id,answer_text,flag,degree)
						values(@Exam_Id,@id_student,@id_question,@Answer,@flag,@degree);
					end
					else
					begin
						select @degree=degree,@flag =flag 
						from get_flag(@id_question,@Answer,@degree)
						update ExamAnswer
						set answer_text=@Answer ,degree=@degree , flag =@flag
						where  student_id=@id_student and exam_id=@Exam_Id and questions_id=@id_question;
						
					end
				end 
				else
					print 'Exam Closed' --/////////////////////////
			end
			else
				print 'this questions do not in this exam' 
			end
		else
			print 'this student no exam or incrorrect exam' 
	end
	else
		print 'incorrect student email'

end

go
exec Insert_Answer_OF_Student
@id_question = 40 ,@Answer ='sql',@email = 'saboormohamed@gmail.com',@Exam_Id = 13
go
alter proc display_result_exam_of_student
(@email varchar(50),@Exam_Id int)
as 
begin
	declare @Type varchar(50),@corse_id int,@intake_branch_track_ID int,@flag bit =0,
	@total_degree_exam int,@total_degree_student int,@id_student int 
	declare @start_Time time,@End_Time Time,@current_Time time,@Current_Date date,@Exam_Date date;
	select @current_Time=CURRENT_TIMESTAMP AT TIME ZONE 'Egypt Standard Time';
	select @Current_Date=GETDATE();
	if exists(select id_student from get_id_student(@email))
	begin
		select @id_student=id_student from get_id_student(@email)
		if exists(select * from ExamsResult where student_id =@id_student and exam_id =@Exam_Id)
		begin
			select * from ExamsResult where student_id =@id_student and exam_id =@Exam_Id
		end
		else if exists(select * from spaseficExams where student_id =@id_student and exam_id =@Exam_Id)
		begin 
			select @start_Time=start_time,@End_Time=end_time,@Exam_Date=Exam_day
			from Exams where IDexam=@Exam_Id;
			if(@current_Time > @End_Time or @Current_Date = @Exam_Date) or (@Current_Date > @Exam_Date)
			begin
				select @Type=Type,@corse_id =corse_id,@intake_branch_track_ID =intake_branch_track_ID
				,@total_degree_exam =total_degree from Exams where IDexam = @Exam_Id
				set @total_degree_student = dbo.Total_Degree_student(@id_student,@Exam_Id)
				if((@total_degree_student*2)>=@total_degree_exam)
				begin
					set @flag=1		
				end
				insert into ExamsResult (exam_id,Type,student_id,corse_id,intake_branch_track_ID,
				start_time,end_time,Exam_day,flag,total_degree_student,total_degree_exam)
				values (@Exam_Id,@Type,@id_student,@corse_id,@intake_branch_track_ID,@start_Time,
				@End_Time,@Exam_Date,@flag,@total_degree_student,@total_degree_exam)
				select * from ExamsResult where student_id =@id_student and exam_id =@Exam_Id
			end
			else
				print 'you can not show result the exam does not end'
		end
		else
			print 'this student no exam or incrorrect exam' 
		
	end
	else
		print 'incorrect student email'
end

exec display_result_exam_of_student @email='saboormohamed@gmail.com',@Exam_Id = 13