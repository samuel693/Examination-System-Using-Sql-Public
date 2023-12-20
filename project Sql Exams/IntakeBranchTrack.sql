
----===========insert   into  IntakeBranchTrack  ================-----------
select * from Intake_Branch_Track 
GO
create or alter proc  Insert_IntakeBranchTrack
 @BranchId int,
 @TrackId int,
 @IntakeNumber int

 as
 begin
 begin try
   if exists(select 1 from Branch where id_branch = @BranchId) and 
      exists(select 1 from Track where id_track = @TrackId) and
	  exists(select 1 from Intake where IntakeNumber =@IntakeNumber)
	  begin 
	  
		if ((select i.IntakeNumberYear from dbo.Intake i where IntakeNumber =@IntakeNumber )
		       >= YEAR(GETDATE()))
          begin  
	        insert into Intake_Branch_Track (branch_id , track_id , number_intake)
	        values (@BranchId , @TrackId ,@IntakeNumber )
          end
		  else
		   throw 51000,'Enter valid intake number in the same or greater than get current year',16

	     end
	  else 
		throw 51000, 'please enter correct Intake id , branch id , track id ',16
end try
begin catch
print ERROR_MESSAGE();
end catch
	    
    
 end
 Go


 exec Insert_IntakeBranchTrack  10, 8 , 49
 




select * from Branch
select * from Track
select * from Intake
select * from Intake_Branch_Track




----===========prevention update and delete  IntakeBranchTrack  ================-----------
go
create or alter trigger Prevent_IntakeBranchTrack_Update_Delete
on [dbo].[Intake_Branch_Track]
instead of Update , delete
as
begin
    
       throw 51000,'Cannot update or delete in Intake_Branch_Track',16;
      
end  

begin try
   update  dbo.Intake_Branch_Track
   set branch_id= 21
   where track_id=12
end try
begin catch
   select ERROR_MESSAGE();
end catch


begin try
delete from dbo.Intake_Branch_Track where branch_id=1
end try
begin catch
   select ERROR_MESSAGE();
end catch

