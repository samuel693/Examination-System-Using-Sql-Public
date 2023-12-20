use [Examination_System]



------=======procedure to insert in course table and instructorCourse table ==========--------
go
CREATE OR ALTER PROCEDURE Add_course
    @crs_name VARCHAR(50),
    @crs_desc VARCHAR(MAX),
    @min_deg NUMERIC(18, 0),
    @max_deg NUMERIC(18, 0),
    @username VARCHAR(50),
    @track_id INT
AS
BEGIN
    DECLARE @instr_id INT;
    DECLARE @courseId INT;

    select @instr_id = dbo.GetInstId(@username);
  begin try
    IF (LEN(@crs_name) = 0)
        THROW 50030, 'Please enter the course name!', 16;
    ELSE
        IF (@instr_id IS  NULL) 
		 		THROW 50031, 'Instructor not found!', 16;
        ELSE
		   IF not exists(select 1 from dbo.Track where id_track = @track_id)
		       THROW 50031, 'Track not found!', 16;
            ELSE
			  Begin;
			    --if(@min_deg < 50 or @max_deg !=100)
				if(@min_deg >@max_deg or @min_deg <=0 or @max_deg<=0 )
				    THROW 50031, 'please enter the minum and maximum degree not <= 0 and min must be < max  ', 16;
                else
                   BEGIN
                       IF EXISTS(SELECT 1 FROM [dbo].[Course] WHERE [Name] = @crs_name)
                         THROW 50032, 'Course already exists!', 16;
                       ELSE
                          BEGIN
                           -- Insert into Course table
                            INSERT INTO [dbo].[Course] ([Name], [discraption], [min_degree], [max_degree], [track_id])
                            VALUES (@crs_name, @crs_desc, @min_deg, @max_deg, @track_id);
							--  the ID of the newly inserted course
                            SET @courseId = SCOPE_IDENTITY(); 

                             -- Insert into InstructorCourseRelation table
                             INSERT INTO [dbo].[instractorCourses] ([instractor_id], [course_id])
                             VALUES (@instr_id, @courseId);

                             PRINT 'Course added successfully.';
                           END;
                   END;
		      End; 
  end try
  
  begin Catch
   declare @error varchar(50)
   set @error = ERROR_MESSAGE();
   print 'error ' +@error
  end catch
END;
go

exec Add_course 'fwegvewvevww','hyper text markup language',10,20, 'Msaboor123',2





select * from dbo.Course
select * from dbo.instractorCourses
select * from dbo.Useraccount
select * from Instructor


-----------========Procedure to update in Course ======-----------

go
Create or alter trigger UpdateCourse
on[dbo].[Course] 
Instead of UPDATE
AS
BEGIN
declare @OldCourseId int ,@NewCourseId int , -- @NewInsId int
@NewName varchar(30),
@NewMaxDegree int,
@NewMinDegree int  ,
@NewDescription varchar(max),
@NewTrackId int,
@newInsId int;


		
		select @OldCourseId =deleted.IDcourse from deleted;

		select @NewCourseId = i.IDcourse , @NewName=i.Name , @NewMaxDegree = i.max_degree ,
		@NewMinDegree = i.min_degree,
		@NewDescription =i.discraption , @NewTrackId =i.track_id 
		from inserted as i;

		--if exists(select 1 from dbo.Instructor as ins where ins.id_instructor = @NewInsId )
		    if(@NewCourseId = @OldCourseId)
			begin
		    if(len(@NewName)>3)
			 begin
			   if((select max_degree from dbo.Course where IDcourse =@NewCourseID ) =@NewMaxDegree)
			    begin 
				   if((select min_degree from dbo.Course where IDcourse =@NewCourseID ) =@NewMinDegree)
				   begin
				     if(len(@NewDescription)>3)
					 begin
					   if exists(select 1 from dbo.Track t where t.id_track =@NewTrackId)
					   begin
					     ------update course table-----
						 update [dbo].[Course]
						 set [Name] = @NewName,
						     [max_degree]=@NewMaxDegree,
				             [min_degree]=@NewMinDegree,
							 [discraption] =@NewDescription,
							 [track_id] = @NewTrackId
							 where [IDcourse] = @OldCourseId

							 -- Update the 'instractorCourses' table
                             SELECT @newInsId = ic.instractor_id
                             FROM instractorCourses ic
                             WHERE ic.course_id = @NewCourseId;

                             UPDATE dbo.instractorCourses
                             SET instractor_id = @newInsId
                             WHERE course_id = @OldCourseId;
       --             
						     
						     
					   end
					    else
			              throw 51000,'invalid track id',16

					 end
					  else
			            throw 51000,'invalid description',16

 				   end
				    else
			          throw 51000,'invalid min degree ',16

				end
				  else
			        throw 51000,'invalid max degree ',16

			 end
			  else
			     throw 51000,'invalid course name ',16
            end

			else
			  throw 51000,'Course id not exist',16
             

		  
        -- else
		  -- throw 51000,'invalid instructor id ',16					
END
go

 begin try
 update [dbo].[Course] 
  set [Name] ='php laravel v2', 
  [max_degree]=100,
  [min_degree]=50,
  [discraption]='php laravel v2 in full stack',
  [track_id]=4 where IDcourse =9 ;

  UPDATE dbo.instractorCourses
   SET instractor_id =20
  WHERE course_id = 9;

 
   
 end try
 begin catch
   select ERROR_MESSAGE()
 end catch
 
 



 select * from instractorCourses
 select * from Course

 -------------===========trigger to preventio Deletetion==========--------- 

 go
create or alter trigger Prevent_Course_Deletion
on [dbo].[Course]
instead of delete
as
begin

      throw 51000,'Cannot delete the Course',16;
	  
End 


DELETE FROM dbo.Course WHERE [Name]='sdvsdv'    ---delete with any thing



--------===============view to show Course and Instructor details
go
create view Course_Instr_Details
WITH ENCRYPTION
as

   select c.Name 'Course name' , c.discraption 'Course Description' ,
   CONCAT(u.f_name , ' ' ,u.l_name ) 'Full name', u.city 'City' , u.age 'Age'
   from dbo.Course c join  instractorCourses ic 
      on c.IDcourse = ic.course_id 
	  join Instructor i 
	  on ic.instractor_id = i.id_instructor
	  join Useraccount u
	  on i.user_id = u.id_user;

select * from dbo.Course_Instr_Details





