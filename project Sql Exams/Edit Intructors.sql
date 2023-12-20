USE [Examination_System]

--Create procedure ADD intstructor
GO
CREATE OR ALTER PROCEDURE Addinstructor
    @User_name VARCHAR(50),
    @Email VARCHAR(50),
    @Phone CHAR(11),
    @F_name VARCHAR(50),
    @L_name VARCHAR(50),
    @City VARCHAR(50),
    @Street_name VARCHAR(100),
    @Birthdate DATE,
    @Pass VARCHAR(100),
	@manager_id INT
AS
BEGIN
    BEGIN TRY
	-- Check for duplicate instructor
        IF EXISTS (
            SELECT 1
            FROM [dbo].[Useraccount]
            WHERE user_name = @User_name
        )
            THROW 50008, 'Instructor already exists.', 16;

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

        INSERT INTO [dbo].[Instructor]([user_id], [manager_id])
        VALUES (@user_id, @manager_id);
        PRINT 'Instructor added successfully.';
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

--Duplicate DATA
EXEC Addinstructor
    @User_name = 'johndoe',
    @Email = 'john@example.com',
    @Phone = '12345678901',
    @F_name = 'Joo',
    @L_name = 'Doe',
    @City = 'City',
    @Street_name = '123 Main St',
    @Birthdate = '1990-01-15',
    @Pass = 'weakpass@123',
    @manager_id = 8;

--Valid DATA	
EXEC Addinstructor
    @User_name = 'MaiMo12',
    @Email = 'Mai@gmail.com',
    @Phone = '12345678901',
    @F_name = 'Mai',
    @L_name = 'Fathi',
    @City = 'City',
    @Street_name = '123 Main St',
    @Birthdate = '1990-01-15',
    @Pass = 'strongpass@123',
    @manager_id = 5;



--Create Procedure UPDATE Instructor
GO
CREATE OR ALTER PROCEDURE UpdateInstructor
   @Instructor_id INT,
   @NewUser_name VARCHAR(50),
    @NewEmail VARCHAR(50),
    @NewPhone CHAR(11),
    @NewF_name VARCHAR(50),
    @NewL_name VARCHAR(50),
    @NewCity VARCHAR(50),
    @NewStreet_name VARCHAR(100),
    @NewBirthdate DATE,
    @NewPass VARCHAR(100),
	@manager_id INT
AS
BEGIN
    BEGIN TRY
		--Check the user_id for student
		IF NOT EXISTS (SELECT 1 FROM [dbo].[Instructor] WHERE id_instructor = @Instructor_id)
            THROW 50008, 'Instructor with the provided user_id does not exist in the Instructor table.', 16;
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
        WHERE [id_user] = 
		(select user_id from Instructor where id_instructor=@Instructor_id);

		UPDATE [dbo].[Instructor]
        SET [manager_id] = @manager_id
        WHERE id_instructor = @Instructor_id;
        
        PRINT 'Instructor updated successfully.';
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

EXEC UpdateInstructor
    @Instructor_id = 2, 
    @NewUser_name = 'new_username',
    @NewEmail = 'newemail@example.com',
    @NewPhone = '12345678901',
    @NewF_name = 'FirstName',
    @NewL_name = 'LastName',
    @NewCity = 'New City',
    @NewStreet_name = 'New Street',
    @NewBirthdate = '1999-07-01',
    @NewPass = 'NewP@ssw0rd',
    @manager_id = 2;

--Create Procedure DELETE Instructor
GO
CREATE OR ALTER PROCEDURE DeleteInstructor
    @Instructor_id INT
AS
BEGIN
    BEGIN TRY
        -- Check if the instructor exists
        IF NOT EXISTS (SELECT 1 FROM [dbo].[Instructor] WHERE [id_instructor] = @Instructor_id)
            THROW 50009, 'Instructor not found!', 16;

		IF EXISTS (
            SELECT 1 FROM [dbo].[Instructor] WHERE manager_id = @instructor_id
            UNION
            SELECT 1 FROM [dbo].[Branch] WHERE manager_id = @instructor_id
            UNION
            SELECT 1 FROM [dbo].[Track] WHERE [supervisior_id] = @instructor_id
        )
            THROW 50010, 'Cannot delete instructor. There are dependent instructors.', 16;
		-- Delete Instructor from Instructor table
        DELETE FROM [dbo].[Instructor] WHERE [id_instructor] = @Instructor_id;

        -- Delete related records from TrackInstructor table
        DELETE FROM [dbo].[Track_Instructor] WHERE [instructor_id] = @Instructor_id;

        -- Delete related records from InstructorCourse table
        DELETE FROM [dbo].[instractorCourses] WHERE [instractor_id] = @Instructor_id;

        -- Delete the instructor from Instructor table
        DELETE FROM [dbo].[Instructor] WHERE [id_instructor] = @Instructor_id;


        PRINT 'Instructor deleted successfully.';
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
CREATE OR ALTER TRIGGER DeleteInstructorTrigger
ON [dbo].[Instructor] AFTER DELETE
AS
BEGIN
    DELETE us
    FROM [dbo].[Useraccount] AS us
    JOIN deleted AS inst ON us.id_user = inst.user_id;
END;
GO

--InValid Cannot DELETE
EXEC DeleteInstructor @Instructor_id = 7; 

--InValid Cannot DELETE
EXEC DeleteInstructor  @Instructor_id = 10;

--Valid Can DELETE
EXEC DeleteInstructor  @Instructor_id = 1019;
GO
	