
create schema Exams
 
go
create or alter proc Exams.insertintoExams 
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
exec  Exams.insertintoExams 
@Name='c#', @Type ='exam',@intake_branch_track_ID =4,@email ='Msaboor@gmail.com',
@courseName ='oop c#', @start_time ='10:00' ,@end_time ='11:00' ,@Exam_date ='2023-09-20'
*/
go

create or alter  proc Exams.updateExams 
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

create or alter trigger delele_Exam 
on [dbo].[Exams] instead of delete
as begin
	if not exists(select * from Exams where IDexam = (select IDexam from deleted))
		print 'this exam does not exist'
	print 'you cannot delete exam this data is important'
end

go