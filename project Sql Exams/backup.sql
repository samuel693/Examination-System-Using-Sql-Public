


select name,recovery_model_desc  ---  kind of recovery Model for all database
from master.sys.databases

  --full recovery model tell SQL Server to Keep all transaction
  --data in the transaction log  until either a transaction log 
  --back up occures or the transaction log is truncated.

alter database [Examination_System]
set recovery full --simple;--convert from full recovery to simple recovery

BACKUP DATABASE [Examination_System]
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak'
WITH NOINIT,--muti-backup , option to append to the existing backup file.
NAME = 'Examination_System-Full Database Backup';
/*
WITH INIT,--1-The INIT option appends to the existing backup on a file
			--2-option to overwrite the backup 
NAME = 'HR-Full Database Backup';
*/

RESTORE HEADERONLY   
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak';



--drop database Examination_System
--restore database
RESTORE DATABASE [Examination_System]
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak'
WITH FILE = 1, NORECOVERY;;




BACKUP DATABASE [Examination_System] 
to DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak'
WITH DIFFERENTIAL,
NAME = 'Online_Exam_system-Differential Database Backup';



RESTORE HEADERONLY   
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak';

drop database [Examination_System]
--restore differntial

RESTORE DATABASE hr
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak'
WITH FILE = 2-- NORECOVERY;




BACKUP LOG [Examination_System]
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak'
WITH  NAME = 'Examination_System-Transaction Log Backup';

RESTORE LOG [Examination_System]
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQL\Backup\Examination_System.bak'
WITH FILE = 5, RECOVERY;