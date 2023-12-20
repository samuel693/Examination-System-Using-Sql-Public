use Examination_System


--==func to return instructor id using user name account
go
create function GetInstId(@user varchar(50))
returns int
as
  begin
    declare @id int
   	  if exists(select 1 from Useraccount u where u.user_name =@user) 
		   begin
		     select @id = i.id_instructor from Useraccount u join Instructor i
			  on(u.user_name =@user and u.id_user = i.user_id)
			     return @id
		    end
	  else 
       return ERROR_MESSAGE()
	
  return @id
  end
go

select dbo.GetInstId ('')
 


--========================insert to branch================---------------
go
create or alter proc InsToBranch
   @BranchName varchar(50),
   @username varchar(50)
	
 as
 begin
  begin try
    declare @ManagerId int
   set @ManagerId = dbo.GetInstId (@username)
 if(LEN(@BranchName) > 2)
  begin 
    if exists(select 1 from Branch b where b.BranchName = @BranchName )
	   throw 51000,'the branch is exist', 16
    else
	 if @ManagerId is not null
	   begin
	     if exists(select 1 from dbo.Branch where manager_id = @ManagerId)
		   throw 51000,'Instructor is a manager for another branch !!!',16
         else
		     -----------insert into branch ------------
		if exists(select 1 from Instructor where manager_id=@ManagerId)
		begin
		   	 insert into Branch (BranchName , manager_id)
			 values(@BranchName , @ManagerId)
		end
		else
	   	   throw 51000,'manager must be supervisor', 16
	   end

	 else
	   	   throw 51000,'this user not exist in instructors', 16
  end

   else
	   throw 51000,'please enter beanch name', 16
 end try

 begin catch
   declare @error varchar(50);
   select @error = ERROR_MESSAGE();
   print 'Error : '+ @error;
 end catch

end

go

exec InsToBranch 'miniawsdvd' , ''

select * from Branch
select *from Useraccount
select * from Instructor

--- =================procedure to update branch ==================------------
GO
CREATE  OR ALTER PROCEDURE UpdatInBranch
  @BranchName varchar(50),
  @username varchar(50)
AS
BEGIN
  BEGIN TRY
    DECLARE @ManagerId int
    SET @ManagerId = dbo.GetInstId (@username)
    IF @ManagerId IS NOT NULL
    BEGIN
      IF EXISTS (SELECT 1 FROM Branch b WHERE b.manager_id = @ManagerId)
        THROW 51000, 'This instructor is the manager of another branch.', 16;
      ELSE
      BEGIN
        -- Update branch
		if exists(select 1 from Instructor where manager_id=@ManagerId)
		begin
			UPDATE Branch 
			SET manager_id = @ManagerId 
			WHERE BranchName = @BranchName;
		end
		else
	   	   throw 51000,'manager must be supervisor', 16
      END
    END
    ELSE
    BEGIN
      THROW 51000, 'This user does not exist in instructors.', 16;
    END
  END TRY
  BEGIN CATCH
    DECLARE @error varchar(50);
    SELECT @error = ERROR_MESSAGE();
    PRINT 'Error: ' + @error;
  END CATCH
END
GO

exec UpdatInBranch 'minia' , 'sarah34576'


----===============Trigger prevent Delete Branch======--------------
GO
create or alter trigger Prevent_Branch_Deletion
on [dbo].[Branch]
instead of delete
as
begin
  
 
      throw 51000,'Cannot delete the Branch',16;
	  
End 


DELETE FROM dbo.Branch WHERE BranchName='minia'


----=======create view to show branch name and manager name
go
 create or alter view ShowBranchAndManager
 as
 select b.BranchName 'Branch name', CONCAT(ua.f_name , ' ', ua.l_name) 'Manager name',
  ua.age 'Age' , ua.city 'City'
  from Branch b join Instructor i on b.manager_id = i.id_instructor
  join Useraccount ua on i.user_id = ua.id_user
go

select * from ShowBranchAndManager






