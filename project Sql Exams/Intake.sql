use [Examination_System]


-----------========procedure to insert in intake =========--------------
GO
create or alter proc  Insert_Intake
 @IntakeNumber int,
 @IntakeNumberYear int

 as
 begin
   begin try
   if( @IntakeNumberYear < YEAR(GETDATE()) )
     throw 51000,'invalid intake year, year must be => currect year !!!',16
   else
     begin
	   if(@IntakeNumber >= (select MAX(IntakeNumber) from Intake) )
	          --------insert------------
		  begin	
           insert into Intake (IntakeNumber , IntakeNumberYear)
			  values(@IntakeNumber , @IntakeNumberYear);
           print 'inserted successfully';
		  end

       else
        THROW 51000, 'Invalid intake number! Intake number already exists.', 16;


	 end
   end try

   begin catch
     declare @error varchar(max);
	 select @error = ERROR_MESSAGE();
	 print 'Error : '+ @error;
   end catch
    
 end
 Go

  exec Insert_Intake  45 ,2020


----===========prevention delete intake  ================-----------
----===========prevention update and delete  intake  ================-----------
go
create or alter trigger Prevent_Intake_Update
on [dbo].[Intake]
instead of Update , delete
as
begin
    
       throw 51000,'Cannot update and delete in Intake',16;
      
end  



begin try
   update  dbo.Intake
   set IntakeNumberYear= 2023
   where IntakeNumber=42
end try
begin catch
   select ERROR_MESSAGE();
end catch



  

begin try
delete from dbo.Intake where IntakeNumber=42
end try
begin catch
   select ERROR_MESSAGE();
end catch




