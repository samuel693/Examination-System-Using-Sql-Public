use [Examination_System]

select * from Track

select * from Track_Instructor

BACKUP DATABASE YourDatabaseName TO DISK = 'C:\Backup\Examination_System.bak'



---------==========Procedure To Add track ======-------
GO
CREATE OR ALTER PROCEDURE Add_Track
    @Track_Name VARCHAR(50),
    @Supervisor_id INT
AS
BEGIN
    IF (LEN(@Track_Name) > 3)
    BEGIN
        IF EXISTS (SELECT 1 FROM dbo.Track WHERE TrackName = @Track_Name)
            THROW 51000, 'Track name is repeated. Please change it!', 16;
        ELSE
        BEGIN
            IF EXISTS (SELECT 1 FROM Instructor WHERE id_instructor = @Supervisor_id)
            BEGIN
                IF EXISTS (SELECT 1 FROM Track WHERE supervisior_id = @Supervisor_id)
                    THROW 51000, 'Instructor is a supervisor for another track. Change it!', 16;
                ELSE
                BEGIN
                    -- Insert into Track table
                    INSERT INTO Track (TrackName, supervisior_id) 
                    VALUES (@Track_Name, @Supervisor_id);
                END
            END
            ELSE
                THROW 51000, 'Instructor is not found. Change it!', 16;
        END
    END
    ELSE
        THROW 51000, 'Invalid Track name!', 16;
END
GO

exec Add_Track '.net track', 1

-----------=======trigger to update in track ============-----------------
Go
CREATE OR ALTER TRIGGER Update_Track
ON [dbo].[Track]
INSTEAD OF UPDATE
AS
BEGIN
  declare
     @NewTrackName varchar(30),
     @SupervisorId int,
	 @NewTrackId int,
	 @OldTrackId int;
   
    select  @OldTrackId = d.id_track from deleted d;
	select  @NewTrackId = i.id_track, @NewTrackName  = i.TrackName ,@SupervisorId = i.supervisior_id  from inserted i;

	IF(@NewTrackId = @OldTrackId)
	BEGIN
	  IF(LEN(@NewTrackName) >=2)
	  BEGIN
	    IF NOT EXISTS(SELECT 1 FROM dbo.Track WHERE TrackName = @NewTrackName )
		BEGIN
		   IF Not EXISTS(SELECT 1 from Track where supervisior_id =@SupervisorId)
		    ---------Update----------
			   UPDATE dbo.Track 
			   SET TrackName =@NewTrackName , supervisior_id =@SupervisorId
			   where id_track = @OldTrackId

           ELSE
		     THROW 51000, 'Instructor is supervosor for another track, change it!',16;

		END

		ELSE
           THROW 51000, 'Repeated name, please enter another name !',16;
		 
	  END
	  ELSE
	    THROW 51000, 'Invalid name !!!',16
 
	END

	ELSE
	  THROW 51000, 'Invalid Track id !!!',16;
END
  
select * from Track 

begin try
  update dbo.Track 
  set TrackName = 'SD',
      supervisior_id =15
	  where id_track =4;

end try
begin catch
  select ERROR_MESSAGE();
end catch

select * from Track


----===========prevention delete track  ================-----------
go
create or alter trigger Prevent_Track_Deletion
on [dbo].[Track]
instead of delete
as
begin
       throw 51000,'Cannot delete the track',16
end  

delete from dbo.Track where TrackName='.net track'

-------========view to show track and supervisor details======---------
go
create view Track_Super_Details
WITH ENCRYPTION
as
(
   select t.TrackName 'Track name' ,  
   CONCAT(u.f_name , ' ' ,u.l_name ) 'Full name', u.age 'Age' , u.city 'City'
   from dbo.Track t join  Instructor i 
      on  t.supervisior_id= i.id_instructor 
	  join  Useraccount u
	  on  i.user_id = u.id_user
);
go
select * from dbo.Track_Super_Details



-------========view to show track and  its courses======---------
go
CREATE OR ALTER VIEW Track_Course_Det
WITH ENCRYPTION
AS
(
   SELECT t.TrackName AS 'Track name',
          c.Name AS 'Course name',
          MAX(c.discraption) AS 'Course description'
   FROM dbo.Track t
   JOIN Course c ON t.id_track = c.track_id
   GROUP BY t.TrackName, c.Name
);
go
select * from dbo.Track_Course_Det










