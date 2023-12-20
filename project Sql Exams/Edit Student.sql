USE [Examination_System]

--Create procedure ADD Student
GO
CREATE OR ALTER PROCEDURE Addstudent
    @User_name VARCHAR(50),
    @Email VARCHAR(50),
    @Phone CHAR(11),
    @F_name VARCHAR(50),
    @L_name VARCHAR(50),
    @City VARCHAR(50),
    @Street_name VARCHAR(100),
    @Birthdate DATE,
    @Pass VARCHAR(100),
	@student_id INT,
	@intakeBranchTrack_id INT,
	@department_id INT
AS
BEGIN
    BEGIN TRY
	-- Check for duplicate student
        IF EXISTS (
            SELECT 1
            FROM [dbo].[Useraccount]
            WHERE user_name = @User_name
        )
            THROW 50008, 'Student already exists.', 16;

	--User name != NULL
        IF (ISNULL(@User_name, '') = '')
            THROW 50005, 'Please be sure to enter your user name!', 16;
		
		--Email in correct format ==> user@gmail.com
		IF(NOT(
		@Email LIKE '%@%.%' AND
        @Email NOT LIKE '%@%@%@%' AND
        @Email NOT LIKE '%@%.%.%' AND
		LEN(@Email) >= 5
		))
			THROW 50006, 'The email must be in correct format like user@gmail.com..',16;

        --Phone.length == 11 or != NULL
        IF (ISNULL(@Phone, '') = '' OR LEN(@Phone) != 11)
            THROW 50006, 'The phone number must be 11 digits long!', 16;

		--First Name dosen't contain number, special char & greater than 2
        IF (NOT (
		 @F_name NOT LIKE '%[0-9]%'AND
		 @F_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@F_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--First Name dosen't contain number, special char & greater than 2
		IF (NOT (
		 @L_name NOT LIKE '%[0-9]%'AND
		 @L_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@L_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--Check validation password 
         IF (NOT (
            @Pass LIKE '%[A-Z]%' AND
            @Pass LIKE '%[a-z]%' AND
            @Pass LIKE '%[0-9]%' AND
            @Pass LIKE '%[^a-zA-Z0-9]%' AND
            LEN(@Pass) >= 8
        ))
            THROW 50007, 'Password must meet complexity requirements.', 16;

        INSERT INTO [dbo].[Useraccount] (user_name, f_name, l_name, city, street_name, birthdate, email, pass, phone)
        VALUES (@User_name, @F_name, @L_name, @City, @Street_name, @Birthdate, @Email, @Pass, @Phone);

        DECLARE @user_id INT = SCOPE_IDENTITY();

        INSERT INTO  [dbo].[Student]([user_id],[id_student],  [intake_branch_track_ID], [department_id])
        VALUES (@user_id, @student_id, @intakeBranchTrack_id,@department_id);
        PRINT 'Student added successfully.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        PRINT 'Error ' + @ErrorMessage;
    END CATCH;
END;
GO
EXEC Addstudent
    @User_name = 'MaiMoo12344',
    @Email = 'Maimo1@example1.com',
    @Phone = '12345678901',
    @F_name = 'Joo',
    @L_name = 'Doo',
    @City = 'City',
    @Street_name = '123 Main St',
    @Birthdate = '1998-01-15',
    @Pass = 'strongpass@12312',
	@student_id = 4,
    @intakeBranchTrack_id = 4,
	@department_id= 2;
GO


--Create Procedure UPDATE student
GO
CREATE OR ALTER PROCEDURE UpdateStudent
   @student_id INT,
   @NewUser_name VARCHAR(50),
    @NewEmail VARCHAR(50),
    @NewPhone CHAR(11),
    @NewF_name VARCHAR(50),
    @NewL_name VARCHAR(50),
    @NewCity VARCHAR(50),
    @NewStreet_name VARCHAR(100),
    @NewBirthdate DATE,
    @NewPass VARCHAR(100)
	/*@intakeBranchTrack_id INT,
	@department_id INT*/
AS
BEGIN
    
		--Check the user_id for student
		IF NOT EXISTS (SELECT 1 FROM [dbo].[Student] WHERE id_student = @student_id)
            THROW 50008, 'Student with the provided user_id does not exist in the Student table.', 16;
        
		--User name != NULL
        IF (ISNULL(@NewUser_name, '') = '')
            THROW 50005, 'Please be sure to enter your user name!', 16;
		
		--Email in correct format ==> user@gmail.com
		IF(NOT(
		@NewEmail LIKE '%@%.%' AND
        @NewEmail NOT LIKE '%@%@%@%' AND
        @NewEmail NOT LIKE '%@%.%.%' AND
		LEN(@NewEmail) >= 5
		))
			THROW 50006, 'The email must be in correct format like user@gmail.com..',16;

        --Phone.length == 11 or != NULL
        IF (ISNULL(@NewPhone, '') = '' OR LEN(@NewPhone) != 11)
            THROW 50006, 'The phone number must be 11 digits long!', 16;

		--First Name dosen't contain number, special char & greater than 2
        IF (NOT (
		 @NewF_name NOT LIKE '%[0-9]%'AND
		 @NewF_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@NewF_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--First Name dosen't contain number, special char & greater than 2
		IF (NOT (
		 @NewL_name NOT LIKE '%[0-9]%'AND
		 @NewL_name NOT LIKE '%[^a-zA-Z]%' AND 
		 LEN(@NewL_name) > 2 
		 ))
            THROW 50006, 'The Name must be in correct formate !', 16;

		--Check validation password 
         IF (NOT (
            @NewPass LIKE '%[A-Z]%' AND
            @NewPass LIKE '%[a-z]%' AND
            @NewPass LIKE '%[0-9]%' AND
            @NewPass LIKE '%[^a-zA-Z0-9]%' AND
            LEN(@NewPass) >= 8
        ))
            THROW 50007, 'Password must meet complexity requirements.', 16;
        BEGIN TRY
		   UPDATE [dbo].[Useraccount]
			SET user_name = @NewUser_name,
				f_name = @NewF_name,
				l_name = @NewL_name,
				city = @NewCity,
				street_name = @NewStreet_name,
				birthdate = @NewBirthdate,
				email = @NewEmail,
				pass = @NewPass,
				phone = @NewPhone
			WHERE id_user =
			(select user_id from Student where id_student=4);
			PRINT 'Student updated successfully.';
		END TRY
		/*UPDATE [dbo].[Student]
        SET [intake_branch_track_ID] = @intakeBranchTrack_id, [department_id] = @department_id
        WHERE [id_student] = @student_id;*/
        
        
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        PRINT 'Error ' + @ErrorMessage;
    END CATCH;
END;

--InValid Data the student_id incorrect 
EXEC UpdateStudent
    @student_id = 4, 
    @NewUser_name = 'new_username12',
    @NewEmail = 'newemail1@example12.com',
    @NewPhone = '12345678901',
    @NewF_name = 'FirstName',
    @NewL_name = 'LastName',
    @NewCity = 'New City',
    @NewStreet_name = 'New Street',
    @NewBirthdate = '1999-07-01',
    @NewPass = 'NewP@ssw0rd';
    /*@intakeBranchTrack_id = 4,
	@department_id= 2;*/

--Valid Data
EXEC UpdateStudent
    @student_id = 1019, 
    @NewUser_name = 'new_username1',
    @NewEmail = 'newemail1@example.com',
    @NewPhone = '12345678901',
    @NewF_name = 'FirstName',
    @NewL_name = 'LastName',
    @NewCity = 'New City',
    @NewStreet_name = 'New Street',
    @NewBirthdate = '1999-07-01',
    @NewPass = 'NewP@ssw0rd'
    /*@intakeBranchTrack_id = 5,
	@department_id= 1;*/
	------------------------------------------------------------
 --Create Procedure DELETE Student
GO
CREATE OR ALTER PROCEDURE DeleteStudent
    @student_id INT
AS
BEGIN
    BEGIN TRY
        -- Check if the Student exists
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Student] WHERE [id_student] = @student_id)
            THROW 50009, 'Student not found!', 16;
		
		-- Delete the student from student table
        DELETE FROM [dbo].[Student] WHERE [id_student] = @student_id;


        PRINT 'Student deleted successfully.';
    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        PRINT 'Error ' + @ErrorMessage;
    END CATCH;
END;
GO

CREATE OR ALTER TRIGGER DeleteStudentTrigger
ON [dbo].[Student] AFTER DELETE
AS
BEGIN
    DELETE usstud
    FROM [dbo].[Useraccount] AS usstud
    JOIN deleted AS stud ON usstud.[id_user] = stud.[user_id];
END;

GO
--InValid Cannot DELETE
EXEC DeleteStudent @student_id = 4; 

--Valid Can DELETE
EXEC DeleteStudent @student_id = 1004;

--Valid Can DELETE
EXEC DeleteStudent @student_id = 5;





