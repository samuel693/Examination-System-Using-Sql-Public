
create schema Exam_Student 
go
create or alter proc Exam_Student.insertintoExam_for_student
(@email varchar(100),@Exam_id int)
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

--exec Exam_Student.insertintoExam_for_student @email='jenni.ferdavis@example.com' ,@Exam_id=1
go


create or alter proc Exam_Student.updateExam_for_student
(@newemail varchar(100),@oldemail varchar(100),
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

/*
exec Exam_Student.updateExam_for_student @oldemail='ahmedhos@gmail.com',@newemail='saboormohamed@gmail.com',
@oldExam_id=14, @newExam_id=15
*/
go


create or alter proc Exam_Student.deleteExam_for_student
(@email varchar(100),@Exam_id int)
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

--exec deleteExam_for_student 'saboormohamed@gmail.com',15

go
