----=======================Create a role for the admin account===================-------------------------
CREATE ROLE Admin_Role;

---Assign Permissions to Roles:
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo  TO Admin_Role;

-- Create SQL logins for each account
CREATE LOGIN AdminLog WITH PASSWORD = 'adm123';

-- Map logins to database users and assign roles
CREATE USER AdminUser FOR LOGIN AdminLogin WITH DEFAULT_SCHEMA = dbo;
ALTER ROLE Admin_Role ADD MEMBER AdminUser;





----------================ Create a role for the Student account================-------------------
CREATE ROLE Student_Role;
---Assign Permissions to Roles:
GRANT SELECT ON [dbo].[Course]  TO Student_Role;
DENY INSERT,UPDATE ON [dbo].[Course]  TO Student_Role;
GRANT SELECT ON dbo.Exams TO Student_Role;
DENY  INSERT,UPDATE,DELETE ON [dbo].[Exams]  TO Student_Role;
GRANT INSERT ON [dbo].[QuestionAnswer] to Student_Role;
DENY SELECT,UPDATE,DELETE ON [dbo].[QuestionAnswer] to Student_Role;
GRANT INSERT ON [dbo].[ExamsResult] to Student_Role;
DENY SELECT,UPDATE,DELETE ON [dbo].[ExamsResult] to Student_Role;

-- Create SQL logins for each account
CREATE LOGIN stud WITH PASSWORD = 'stud123';

-- Map logins to database users and assign roles
CREATE USER student FOR LOGIN stud WITH DEFAULT_SCHEMA = dbo;
ALTER ROLE StudentRole ADD MEMBER student;





------Query to display the schema, table name, and owner of the "Course" table:---------
--SELECT SCHEMA_NAME(schema_id) AS [Schema], name AS [Table], USER_NAME() AS [Owner]
--FROM sys.tables
--WHERE name = 'Course';
-------- schema == dbo  ---  Table == Course --- Owner == dbo --------- 

-------====Query to transfer ownership of the "Course" table to a new owner (let's say NewOwner):
--ALTER SCHEMA dbo TRANSFER NewOwner.Course;

------Query to deny INSERT permission on the "Course" table to a specific role (let's say StudentRole):
--DENY INSERT ON dbo.Course TO StudentRole;

--GRANT ALTER ON SCHEMA::dbo TO StudentRole;
--GRANT CONTROL ON OBJECT::dbo.Course TO StudentRole;




select * from dbo.Course
select * from [ExamQuestions]

insert into dbo.Course values('evwevcsdvcsdve',100 , 50 , 'sdveseveervd',4)
insert into dbo.ExamQuestions values(1,1 , 'vsebverebreber',10)
select * from [dbo].[ExamQuestions]




----------========================instructor role===============================-------

--Create a role for the Student account
CREATE ROLE InstructorRole;

---Assign Permissions to Roles:
-- Grant necessary permissions to the admin role
GRANT SELECT ON [dbo].[Course]  TO InstructorRole;        
DENY INSERT,UPDATE,delete ON [dbo].[Course]  TO InstructorRole;

GRANT SELECT,INSERT,UPDATE ON [dbo].[Exams]  TO InstructorRole;
DENY DELETE ON [dbo].[Exams]  TO InstructorRole;

GRANT SELECT,INSERT,UPDATE,DELETE ON [dbo].[ExamQuestions] TO InstructorRole;

GRANT SELECT ON[dbo].[Questions_Type]  TO InstructorRole;
GRANT DELETE,INSERT,UPDATE ON[dbo].[Questions_Type]  TO InstructorRole;

GRANT SELECT ON[dbo].[Student]  TO InstructorRole;
GRANT DELETE,INSERT,UPDATE ON[dbo].[Student]  TO InstructorRole;

GRANT SELECT ON [dbo].[Branch] TO InstructorRole;
DENY DELETE,INSERT,UPDATE ON [dbo].[Branch]  TO InstructorRole;

GRANT SELECT ON [dbo].[ExamsResult] TO InstructorRole;
DENY DELETE,INSERT,UPDATE ON [dbo].[ExamsResult]  TO InstructorRole;


-- Create SQL logins for each account
CREATE LOGIN Instr WITH PASSWORD = 'inst123';

-- Map logins to database users and assign roles
CREATE USER InstructorUser  FOR LOGIN  InstructorRole WITH DEFAULT_SCHEMA = dbo;
ALTER ROLE InstructorRole ADD MEMBER InstructorUser;


----------------==============manager role============-----------
-- Create a role for the training manager account
CREATE ROLE ManagerRole;

-- Grant necessary permissions to the training manager role
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Instructor] TO ManagerRole;
GRANT SELECT, INSERT, UPDATE, DELETE ON [dbo].[Courses] TO ManagerRole;
GRANT SELECT, INSERT, UPDATE ON [dbo].[Department] TO ManagerRole;
GRANT SELECT, INSERT, UPDATE ON  [dbo].[Branch] TO ManagerRole;
GRANT SELECT, INSERT, UPDATE ON [dbo].[Intake]  TO ManagerRole;
GRANT SELECT, INSERT, UPDATE ON [dbo].[track]  TO ManagerRole;
GRANT SELECT, INSERT, UPDATE ON  [dbo].[Student] TO ManagerRole;



CREATE LOGIN Mang WITH PASSWORD = 'mang123';

CREATE USER ManagerUser FOR LOGIN Mang WITH DEFAULT_SCHEMA = dbo;
ALTER ROLE ManagerRole ADD MEMBER Mang;












