
create schema student 
go
create or alter  proc student.Display_QExam_To_Student
(@email varchar(100) ,@Exam_Id int)
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
				if(@current_Time NOT between @start_Time and @End_Time) or (@Current_Date!=@Exam_Date)
				begin
					print 'Exam Closed' -- /////////////////////////////////////
				end
				else
				begin
				   exec Exams_Q.showAllQuestion_for_spaseficExam 2
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
/*
exec Student.Display_QExam_To_Student 
@email = 'jenni.ferdavis@example.com',@Exam_Id = 2
*/
go

create or alter proc Student.Display_All_Exams_to_student
(@email varchar(50))
as 
begin
select IDexam as exam_id, name,type,total_degree,start_time,end_time,Exam_day from Exams where IDexam  in (select exam_id from spaseficExams 
where student_id = (select id_student from get_id_student(@email))) 
end
--exec Student.Display_All_Exams_to_student @email='saboormohamed@gmail.com'
go

create or alter proc Student.Insert_Answer_OF_Student
(@id_question int ,@Answer nvarchar(100)='',@email varchar(50),@Exam_Id int)
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
/*
exec Student.Insert_Answer_OF_Student 
@id_question = 24 ,@Answer ='Create a new instance of a class',
@email = 'jenni.ferdavis@example.com',@Exam_Id = 2

*/
go

create or alter proc student.display_result_exam_of_student
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
			if(@current_Time > @End_Time and @Current_Date = @Exam_Date) or (@Current_Date > @Exam_Date)
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

--exec student.display_result_exam_of_student @email='jenni.ferdavis@example.com',@Exam_Id = 2

go

