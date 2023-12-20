

create database Examination_System
on
(
	Name ='Examination_SystemDataFile1',
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Examination_SystemDataFile1.mdf',
	Size = 8MB,
	Maxsize = unlimited,
	filegrowth = 8MB
),
(
	Name ='Examination_SystemDataFile2',
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Examination_SystemDataFile2.ndf',
	Size = 8MB,
	Maxsize = unlimited,
	filegrowth = 8MB
)
LOG on
(
	Name ='Examination_SystemLogFile',
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Examination_SystemLogFile.ldf',
	Size = 8MB,
	Maxsize = 50MB,
	filegrowth = 8MB
)
alter database Examination_System
add filegroup Secondary

alter database Examination_System
add file
(
	Name ='Examination_SystemDataFile3',
	FileName = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\Examination_SystemDataFile3.ndf',
	Size = 8MB,
	Maxsize = unlimited,
	filegrowth = 8MB
) to filegroup Secondary 

