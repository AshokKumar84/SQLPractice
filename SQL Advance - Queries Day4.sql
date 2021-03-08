select * from [dbo].[Trace2]

--DMV (Dynamic Management View)
--server scoped: VIEW SERVER STATE permission on the server is required.
--database scoped: VIEW DATABASE STATE permission on the database is required.

select * from sys.dm_exec_sessions --Sessions in SQL Server
select * from sys.dm_exec_connections -- Connections to SQL Server
select * from sys.dm_tran_active_transactions -- Transaction state for an instance of SQL Server
select * from sys.dm_os_wait_stats -- Returns information what resources SQL is waiting on

--Currently running queries
SELECT TEXT, er.session_id, er.status, er.command,
er.cpu_time, er.total_elapsed_time, er.blocking_session_id,
er.last_wait_type, er.wait_type, er.reads, er.writes
FROM
sys.dm_exec_requests er
CROSS APPLY sys.dm_exec_sql_text(sql_handle);

--Expensive queries ordered by CPU
SELECT TOP 20
st.text,qp.query_plan,
qs.execution_count,
qs.total_worker_time AS Total_CPU,
total_CPU_inSeconds = --Converted from microseconds
qs.total_worker_time/1000000,
average_CPU_inSeconds = --Converted from microseconds
(qs.total_worker_time/1000000) / qs.execution_count,
qs.total_elapsed_time,
total_elapsed_time_inSeconds = --Converted from microseconds
qs.total_elapsed_time/1000000,
qs.total_logical_reads, qs.last_logical_reads,
qs.total_logical_writes, qs.last_logical_writes
FROM
sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan (qs.plan_handle) AS qp
ORDER BY qs.total_worker_time DESC;

--Long running queries by Elapsed Time
SELECT TOP 20
OBJECT_NAME(t.objectid) name, text, execution_count,
total_physical_reads + total_logical_reads AS reads, total_logical_writes,
total_elapsed_time, total_elapsed_time / execution_count AS time_per_execution
FROM
sys.dm_exec_query_stats as [s]
CROSS APPLY sys.dm_exec_sql_text (s.sql_handle) as t
ORDER BY execution_count desc, total_elapsed_time desc;

--statistics
use TestTraining
exec sp_helpstats 'UserInfo','ALL'


update statistics UserInfo
update statistics UserInfo idx_userid
EXEC sp_updatestats;

CREATE STATISTICS userstats ON userinfo(userid, username) 

drop statistics userinfo.userstats 
 
 --Change Tracking
--enable cdc on database
use TestTraining
exec sys.sp_cdc_enable_db

--verify cdc is enabled
select * from sys.databases
SELECT is_cdc_enabled FROM sys.databases WHERE name = 'TestTraining'


select * from education

--enable cdc on table
EXEC sys.sp_cdc_enable_table  
@source_schema= 'dbo', 
@source_name= 'education', 
@role_name = 'NULL'

select * from education

alter table education add years int

select * from cdc.ddl_history

--track changes made to the table
--enable change tracking on a database

alter database TestTraining set change_tracking=on
(change_retention=4 days,auto_cleanup=on) --default retention is 2 days and minumum is 1 min

--verify the change tracking is enabled
select * from sys.change_tracking_databases

--enable change tracking on table (primary key required on the table)
alter table education enable change_tracking
--alter table education disable change_tracking

--view details of the table on which change tracking is enabled
select * from sys.change_tracking_tables

select * from education

update education set years=3 where edcode=1
update education set years=2 where edcode=4
insert into education values(5,'Btech',4)
insert into education values(7,'MCA',3)
update education set years=6 where edcode=7
delete from education where edcode=7

select * from changetable(changes education,0) as ChangeTable
select * from changetable(changes education,1) as ChangeTable

--setting language
create table Dates
(
id int,
Dt date
)
insert into Dates values(1,'2020-01-01'),(2,'2019-11-26'),(3,'2020-12-01')
select * from Dates

select month(dt) from dates
set language english
select datename(mm,dt) from dates
select Title from Employee


--secruing databases - --encryption
USE TestTraining
CREATE SYMMETRIC KEY SymKey
WITH ALGORITHM = TRIPLE_DES
ENCRYPTION BY PASSWORD = 'password$123'

CREATE ASYMMETRIC KEY AsymKey
WITH ALGORITHM = RSA_2048
ENCRYPTION BY PASSWORD = 'password@123'

CREATE CERTIFICATE TestDBCert
ENCRYPTION BY PASSWORD = 'p@ssw0rd123'
WITH SUBJECT = 'Certificate For TestTraining Database',
START_DATE = '02/25/2021',
EXPIRY_DATE = '03/31/2021'

drop table customer

create table customer
(
custid int,
cardnumber char(10),
cardenc varbinary(128)
)

select * from customer

insert into customer values(1,'1234567890',null)
insert into customer values(2,'1111122222',null)
insert into customer values(3,'3333333333',null)
insert into customer values(4,'4567890009',null)

create symmetric key symkey21
with algorithm=triple_des
encryption by password ='p@ssw0rd'

open symmetric key symkey21
decryption by password='p@ssw0rd'

update customer set cardenc =encryptbykey(key_guid('symkey21'),cardnumber)

close symmetric key symkey21

drop symmetric key symkey21

select * from customer

SELECT cardnumber, cardenc AS 'Encrypted card number',
CONVERT(char(20),DecryptByKey(cardenc))   
AS 'Decrypted card number' from customer

create certificate TestCert
encryption by password='p@ssw0rd'
with subject ='certificate to test',
start_date='11/25/2020',
expiry_date='11/30/2020'

select * from sys.certificates

create procedure prccustomer1 
as
select * from customer

add signature to dbo.prccustomer1 by certificate TestDBCert with password='p@ssw0rd123'

exec prccustomer1

drop certificate TestDBCert

SELECT OBJECT_SCHEMA_NAME(co.major_id) + '.' + OBJECT_NAME(co.major_id), c.name 
FROM sys.certificates c 
INNER JOIN sys.crypt_properties co ON c.thumbprint = co.thumbprint
WHERE co.crypt_type_desc = 'SIGNATURE BY CERTIFICATE'

DROP SIGNATURE FROM OBJECT::dbo.prccustomer1 BY CERTIFICATE TestDBCert

--heirarchy id
use TestTraining
CREATE TABLE EmployeeDemo 
( 
OrgNode HIERARCHYID, 
EmployeeID INT, 
LoginID VARCHAR(100), 
Title VARCHAR(200), 
HireDate DATETIME 
)

select * from EmployeeDemo
select orgnode.ToString() from EmployeeDemo

--insert first row
--Returns the root of the hierarchy tree. GetRoot() is a static method.
--CLR return type:SqlHierarchyId

INSERT EmployeeDemo (OrgNode, EmployeeID, LoginID, Title, HireDate)		 
VALUES (hierarchyid::GetRoot(), 1,'adventure-works\scott', 'CEO', '3/11/05') ; 

--Insert Second Row		 
--DECLARE @Manager hierarchyid		 
--SELECT @Manager = hierarchyid::GetRoot() FROM EmployeeDemo; 
--INSERT EmployeeDemo (OrgNode, EmployeeID, LoginID, Title, HireDate)		 
--VALUES (@Manager.GetDescendant(null,null), 2, 'adventure-works\Mark', 		 
--'CTO', '4/05/07')	

 --Insert Third Row		 
--DECLARE @Manager hierarchyid		 
--DECLARE @FirstChild hierarchyid		 
--SELECT @Manager = hierarchyid::GetRoot() FROM EmployeeDemo; 
--Select @FirstChild = @Manager.GetDescendant(NULL,NULL) 		 
--INSERT EmployeeDemo (OrgNode, EmployeeID, LoginID, Title, HireDate)		 
--VALUES (@Manager.GetDescendant(@FirstChild,NULL), 3, 'adventure-works\ravi', 		 
--'Director Marketing', '4/08/07')

--Insert the First Descendant of a Child Node		 
--DECLARE @Manager hierarchyid 		 
--SELECT @Manager = CAST('/1/' AS hierarchyid)		 
--INSERT EmployeeDemo (OrgNode, EmployeeID, LoginID, Title, HireDate)		 
--VALUES (@Manager.GetDescendant(NULL, NULL),45,		 
--'adventure-works\Ben','Application Developer', '6/11/07') ;	

--Insert the Second Descendant of a Child Node		 
DECLARE @Manager hierarchyid 		 
DECLARE @FirstChild hierarchyid		 
SELECT @Manager = CAST('/1/' AS hierarchyid)		 
SELECT @FirstChild = @Manager.GetDescendant(NULL,NULL) 		 
INSERT EmployeeDemo (OrgNode, EmployeeID, LoginID, Title, HireDate)		 
VALUES (@Manager.GetDescendant(@FirstChild, NULL),55,		 
'adventure-works\Laura','Trainee Developer', '6/11/07') ;

--Insert the first node who is the Descendant of Director Marketing		 
--DECLARE @Manager hierarchyid 		 
--DECLARE @FirstChild hierarchyid		 
--SELECT @Manager = CAST('/2/' AS hierarchyid)		 
--INSERt EmployeeDemo (OrgNode, EmployeeID, LoginID, Title, HireDate)		 
--VALUES (@Manager.GetDescendant(NULL, NULL),551,		 
--'adventure-works\frank','Trainee Sales Exec.', '12/11/07') ;

--Insert the second node who is the Descendant of Director Marketing		 
--DECLARE @Manager hierarchyid 		 
--DECLARE @FirstChild hierarchyid		 
--SELECT @Manager = CAST('/2/' AS hierarchyid)		 
--SELECT @FirstChild = @Manager.GetDescendant(NULL,NULL) 		 
--INSERT EmployeeDemo (OrgNode, EmployeeID, LoginID, Title, HireDate)		 
--VALUES (@Manager.GetDescendant(@FirstChild, NULL),531,		 
--'adventure-works\vijay','Manager Industrial Sales', '12/09/06') ;	

--output
select OrgNode.ToString() as 'Node', EmployeeID,Title 
from EmployeeDemo

select OrgNode, EmployeeID,Title 
from EmployeeDemo

