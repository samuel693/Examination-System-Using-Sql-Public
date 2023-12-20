use [Examination_System]

insert into [dbo].[Intake]values (2023)
insert into [dbo].[Intake]values (2023)


insert into [dbo].[Department] values
('testing' , 5),('software',2)

insert into [dbo].[Instructor] values
( 14,null),(13,14),(4,14),(15 , 4)


insert into [dbo].[Useraccount](user_name , phone, f_name, l_name,city,street_name,birthdate,age , email, [pass]) values
('sarah345', '013579t5435' , 'sarah', 'moha','minia','abd elsalam 3aref', '1994-10-30' , 29 , 'sarah_moh12@gmail.com' , 'sar456'  ),
('marwa243', '01553450879' , 'marwa', 'mohammed','minia','taha husssien street', '1998-10-30' , 24 , 'marwa33@gmail.com' , 'mar679'  ),
('hesham789','01245689069' , 'hesham', 'mohammed','assuit','adnan street', '1999-01-01' , 24 , 'hesham34@gmail.com' , 'hes589'  )


select * from [dbo].[Department]
--==insert to dept table
go
create or alter proc InsToDept
  @deptname varchar(50),
  @managerid int

 as 
 begin
  begin try
  if(LEN(@deptname) > 0)
  begin
   if EXISTS(select 1 from dbo.Department d where d.DepatrmentName = @deptname )
    throw 51000,'this dpartment is exists already, change it !',16
   else
    begin
       if EXISTS(select 1 from dbo.Instructor i where  i.id_instructor= @managerid)
	   begin
         if EXISTS(select 1 from dbo.Department d where  d.manager_id= @managerid)
		 	throw 51000,'instructor is a manager for another department, change it !',16
         else
		 begin 
		   insert into dbo.Department (DepatrmentName , manager_id) values
		   (@deptname , @managerid);
		 end
	     
	   end
	   else
	     throw 51000,'invalid instructor id !',19

    end
 end

 else
  throw 51000,'invalid name !!',16
  end try

  begin catch
    declare @error varchar(max)
	select @error = ERROR_MESSAGE();
	print 'Error  : ' + @error;
  end catch
end
go


 exec InsToDept  'mohamed' , 1

 --==============update to dept table ===========-------------------
GO
CREATE OR ALTER TRIGGER UpdateToDept
ON [dbo].[Department]
INSTEAD OF UPDATE
AS
BEGIN 
  
    DECLARE
       @NewDeptName VARCHAR(30),
       @NewManagerId INT,
       @NewDeptId INT,
       @OldManagerId INT,
       @OldDeptId INT;

    SELECT  @OldManagerId = d.manager_id,
            @OldDeptId = d.id_departmant
    FROM deleted d;
	
    SELECT  @NewDeptName = i.DepatrmentName,
            @NewManagerId = i.manager_id,
            @NewDeptId = i.id_departmant
    FROM inserted i;
	
    IF (@NewDeptId = @OldDeptId)
    BEGIN
      IF (LEN(@NewDeptName) >= 2)
      BEGIN
        IF NOT EXISTS(
            SELECT 1
            FROM dbo.Department d
            WHERE d.DepatrmentName = @NewDeptName
        )
        BEGIN
          IF EXISTS(
              SELECT 1
              FROM dbo.Instructor i
              WHERE i.id_instructor = @NewManagerId
          )
          BEGIN 
            IF NOT EXISTS(
                SELECT 1
                FROM dbo.Department d
                WHERE d.manager_id = @NewManagerId
            )
            BEGIN
              -- Update----
			  select 'here';
              UPDATE dbo.Department 
              SET DepatrmentName = @NewDeptName,
                  manager_id = @NewManagerId
              WHERE id_departmant = @OldDeptId;
            END
            ELSE
              THROW 51000, 'Instructor is a manager for another Dept, change it!', 16;
          END
          ELSE
            THROW 51000, 'Invalid manager id, not an instructor', 16;
        END
        ELSE
          THROW 51000, 'Repeated Dept name, please enter another name!', 16;
      END
      ELSE
        THROW 51000, 'Invalid name!!!', 16;
    END
    ELSE
      THROW 51000, 'Invalid Dept id!!!', 16;
    
END;
GO

select * from Department 

begin try
  update dbo.Department 
  set DepatrmentName = 'Sdefe',
      manager_id =21
	  where id_departmant =234;

end try
begin catch
  select ERROR_MESSAGE();
end catch

  ----===function get department using id
  go
  create function GetDept(@DeptId int)
  returns table
  as
  return
   select d.manager_id as 'Dept Manager' , d.DepatrmentName 'Dept Name'  
   from dbo.Department d where d.id_departmant = @DeptId   
   go
    select *  from GetDept(1) 



 ---==view get dept manager information
 go
 alter view DeptManagerInfo
 as
 select DepatrmentName , CONCAT( u.f_name , ' ' , u.l_name) 'Full Name' 
 from  Department 
 join dbo.Instructor as i on i.id_instructor =Department.manager_id
 join dbo.Useraccount as u  on u.id_user =i.user_id
 go

 select * from DeptManagerInfo


 --===transction of inserting to dept
 --begin tran
 --save  transaction s1

 -- exec InsToDept  'SD' , 22
 -- exec UpdateToDept 30 , 'GIS' , 21
 -- if @@ERROR <> 0
 -- begin
 --  rollback tran s1
 --  print 'An error occured'
 --  select ERROR_MESSAGE()
 -- end
  
 -- else
 -- begin 
 --   commit tran
	--print 'successful'
 -- end

  --==clustered index


  create  index IX_DeptName on [dbo].[Department] ([DepatrmentName])

------========= 
go
 create view SelFromDeptUsingIndes
 as
  select * from dbo.Department d where d.DepatrmentName='SD'
go


select * from SelFromDeptUsingIndes 


  ----===using stored procedure to delete from dept

 -- create or alter proc DeleteFromDeptTable 
 -- @DeptId int
 -- as
 --  begin
 --  Begin try
 --  if (@DeptId <=0)
	-- throw 5001 , 'invalid id !' , 16
 --  else
 --  begin
 --   if EXISTS(select 1 from dbo.Department where id_departmant = @DeptId)
	-- begin
	--  delete from dbo.Department where id_departmant = @DeptId
	--  print'Deleted Successfully'
 --    end
   
 --   else
	--   throw 5001,'This id not found', 16
 --   end
 --  END TRY

 --  BEGIN CATCH
 --    declare @error varchar(50);
	-- select @error = ERROR_MESSAGE();
	-- print 'Error : '+ @error;
 --  END CATCH

 --end
--exec DeleteFromDeptTable 5
--select * from Department      ----edit in table make fk = null


----===========prevet delete Department  ================-----------
go
create or alter trigger Prevent_Delete_Dept
on [dbo].[Department]
instead of delete
as 
begin
       throw 51000,'Cannot delete the Department',16
end  
-----------------------------------------------
begin try
delete from  dbo.Department where id_departmant =10
end try
begin catch
  select ERROR_MESSAGE();
end catch







