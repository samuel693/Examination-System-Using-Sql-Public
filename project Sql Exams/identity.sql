

-- use to identity colunm to start by Zero 

DBCC CHECKIDENT ([Useraccount],reseed,0)
DBCC CHECKIDENT ([Instructor],reseed,0)
DBCC CHECKIDENT ([Department],reseed,0)
DBCC CHECKIDENT ([Track],reseed,0)
DBCC CHECKIDENT ([Course],reseed,0)
DBCC CHECKIDENT ([Branch],reseed,0)
DBCC CHECKIDENT ([Intake_Branch_Track],reseed,0)
DBCC CHECKIDENT ([Questions],reseed,0)
DBCC CHECKIDENT ([Exams],reseed,0)