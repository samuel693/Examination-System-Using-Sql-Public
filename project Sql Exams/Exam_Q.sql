create schema Exams_Q 
go
create or alter proc Exams_Q.insertintoExams_Q 
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
/*
exec  Exams_Q.insertintoExams_Q 
@exam_id =15, @contant = 'what is SqlServer' ,@email ='Msaboor@gmail.com' ,
@courseName ='SqlServer',@degree = 10
*/
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

create or alter proc Exams_Q.updateExams_Q 
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
exec  Exams_Q.updateExams_Q 
@exam_id =14, @oldcontant = 'what is c#',@newcontant = 'what is C# framwork' ,
@email ='Msaboor@gmail.com' ,@courseName ='c#',@newdegree =15
*/
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
create or alter proc Exams_Q.deleteExams_Q 
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


/*
exec deleteExams_Q 
@exam_id= 13,@contant ='what is C# framwork' ,@email ='Msaboor@gmail.com'
*/
go
create or alter proc Exams_Q.showAllQuestion_for_spaseficExam
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

--Exams_Q.showAllQuestion_for_spaseficExam @exam_id=14
go

create or alter proc Exams_Q.select_Question_Random
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
/*
exec Exams_Q.select_Question_Random 
@number_Quest =5 ,@courseName ='ANGULAR',
@Exam_Id =2,@email ='Msaboor@gmail.com',@Q_Degree =20
*/
go