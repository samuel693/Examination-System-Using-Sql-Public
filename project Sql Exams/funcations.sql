
-- get ID of instructor

alter FUNCTION get_id_instructor(@email varchar(100))  
RETURNS @resl TABLE (id_instructor int) AS  
BEGIN  
    INSERT INTO @resl 
	select  id_instructor from Instructor where user_id =
	(select id_user  from Useraccount where email=@email) 
    RETURN  
END
go

-- get Total_Degree of Question in the exam 

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

-- get Total_Degree of student in the exam 

alter function Total_Degree_student
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

-- get if the answer  is correct  OR not 

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

-- get ID of student

alter FUNCTION get_id_student(@email varchar(100))  
RETURNS @resl TABLE (id_student int) AS  
BEGIN  
    INSERT INTO @resl 
	select  id_student from Student where user_id =
	(select id_user  from Useraccount where email=@email) 
    RETURN  
END
go

-- get all courses that instractor trach

alter FUNCTION getcourses(@email varchar(100))  
RETURNS @resl TABLE (course_id int) AS  
BEGIN  
    INSERT INTO @resl  
	select course_id from instractorCourses where instractor_id = 
	(select id_instructor from Instructor where user_id =
	(select id_user  from Useraccount where email=@email))  
    RETURN  
END 

go

-- get contant of all [Questions] in [Course]

alter FUNCTION getQforcours(@course_id int)  
RETURNS @resl TABLE (Contact varchar(50)) AS  
BEGIN 
    INSERT INTO @resl  
	select Contact  from Questions where course_id= @course_id   
    RETURN  
END

