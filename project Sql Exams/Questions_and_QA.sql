




create or alter proc insertInto_Q_and_QA
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

/*
exec Q_and_QA.insertInto_Q_and_QA @type_name ='choose' , @Contact ='what is Node l JS',@correctAnswer ='kl',
@Answer1 ='ml',@Answer2 ='pl' ,@Answer3 ='sl',@Answer4 ='kl',
@course_name ='Node JS',@email='Msaboor@gmail.com'

exec Q_and_QA.insertInto_Q_and_QA @type_name ='text', @Contact ='string is mojkkfhj',@correctAnswer ='no '
,@course_name ='c#',@email='Msaboor@gmail.com'

exec Q_and_QA.insertInto_Q_and_QA @type_name ='T/F',  @Contact ='is it not importane',
@correctAnswer ='true',@course_name ='MySql',@email='samaoul@gmail.com', 
@Answer1 ='false',@Answer2 ='true'
*/
go
create or alter proc Update_Q_and_QA
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

/*
exec Update_Q_and_QA
@newtype_name ='choose',@oldContact ='what is C##' ,@newContact ='what is c#',
@oldcourse_name ='ISQN',@newcourse_name ='c#',@newcorrectAnswer ='pl' ,
@email ='Msaboor@gmail.com',@newAnswer1 ='pl',@newAnswer2 ='ml',
@newAnswer3 ='sl',@newAnswer4 ='kl'

*/
go


create or alter proc delet_Q_and_QA
(@Contact varchar(50),@email varchar(100),@course_name varchar(50))
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

/*
exec delet_Q_and_QA @Contact ='what is c#',@email ='Msaboor@gmail.com',
@course_name ='c#'
*/

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
create or alter view Q_QAnswer 
AS 
select  questions_id,Type , Contact ,flag ,Answer ,Name as coursName
from Questions_Type, Questions , QuestionAnswer  ,Course 
where [questions_id] =[id_questions] and type_id=id_type and IDcourse = course_id

--select * from  Q_QAnswer
go

create or alter trigger no_add_up_del 
on Q_QAnswer instead of insert,update,delete
as begin
	print 'display onle'
end
/*
insert into Q_QAnswer (questions_id,Type , Contact ,flag ,Answer ,coursName)
values (15,'tk','jhdjkds',0,'jhjkadsfhj','c#')
*/
go
create or alter proc display_spasefic_Course_Q_QA 
(@courseName varchar(50), @email varchar(50)) as
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

--exec display_spasefic_Course_Q_QA @courseName='C#', @email ='Msaboor@gmail.com'
go

