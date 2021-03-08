
select getdate() --returns current date and time

select convert(char,getdate(),1)
select convert(char,getdate(),2)
select convert(char,getdate(),3)
select convert(char,getdate(),4)
select convert(char,getdate(),5)
select convert(char,getdate(),6)
select convert(char,getdate(),7)
select convert(char,getdate(),8)
select convert(char,getdate(),9)
select convert(char,getdate(),10)

select convert(char,getdate(),101)
select convert(char,getdate(),102)
select convert(char,getdate(),103)
select convert(char,getdate(),104)
select convert(char,getdate(),105)
select convert(char,getdate(),106
select convert(char,getdate(),107)
select convert(char,getdate(),108)
select convert(char,getdate(),109)
select convert(char,getdate(),110)

select DATENAME(dd,getdate())
select DATENAME(dw,getdate())
select DATENAME(yy,getdate())
select datename(mm,getdate())

select datepart(mm,getdate())
select datepart(dd,getdate())
select datepart(yy,getdate())

select month('2019-10-01')
select EOMONTH(getdate(),-2)
select EOMONTH('2020-12-31',1)

select dateadd(dd,1,EOMONTH(getdate(),-1)) /*** First day of the month ***/
select EOMONTH(getdate()) /*** Last day of month ***/

select dateadd(dd,1,EOMONTH(getdate(),-2)) /*** First day of previous month ***/
select EOMONTH(getdate(),-1) /*** Last day of preevious month ***/

select dateadd(qq,0,EOMONTH(getdate(),-2)) 

select dateadd(dd,10,getdate()) as 'Date'
select cast(DATEADD(dd,10,getdate()) as char) as 'Date'
select convert(char,DATEADD(dd,10,getdate()),101) as 'Date'
select DATEADD(mm,10,getdate())
select DATEADD(yy,10,getdate())

-- SQL PARSE FUNCTION Example - Convert String to any datatype
DECLARE @str AS VARCHAR(50)
SET @str = '11122'

SELECT PARSE(@str AS INT) AS Result; 

-- Direct Inputs
SELECT PARSE('1234' AS DECIMAL(10, 2)) AS Result; 
SELECT PARSE('06/03/2017' AS DATETIME) AS Result;  
SELECT PARSE('06/03/2017' AS DATETIME2) AS Result;
select parse(1234 as decimal(10,2)) as result; -- ERROR

SELECT TRY_PARSE('14 April 2019' AS date) result;
select try_parse('ABC' as int) as result;

select convert(char,datediff(dd,'2020-10-11',getdate()),1)
select convert(char,datediff(mm,'2020-10-11',getdate()),1)

SELECT TRY_CONVERT( XML, 20) as result;
SELECT TRY_CONVERT(DECIMAL(4,2), '12.345')  Result;
SELECT 
    CASE
        WHEN TRY_CONVERT( INT, 'test') IS NULL
        THEN 'Cast failed'
        ELSE 'Cast succeeded'
    END AS Result;
SELECT TRY_CONVERT( INT, '100.5') Result;


select datediff(dd,'2020-12-31','2021-02-28')

declare @date date
set @date=getdate()
print @date
select @date

declare @time time
set @time=getdate()
print @time

print convert(char,@time,8)
print cast(@time as char(12))

declare @dt datetime2(7)
set @dt=getdate()
print @dt

declare @year as int=2013
declare @month as int=02
declare @day as int=20

select DATEFROMPARTS(@year,@month,@day)

--TIMEFROMPARTS(hour,minute,second,fractions,precision)
select TIMEFROMPARTS(23,35,20,1200,4)

--DATETIMEFROMPARTS(year,month,day,hour,minute,second,ms)
select DATETIMEFROMPARTS(2021,05,10,23,30,30,500)

--DATETIME2FROMPARTS(year,month,day,hour,minute,second,ms,precision)
select DATETIME2FROMPARTS(2021,05,10,23,30,30,500,5)

select cast(getdate() as datetime2)
select getdate()
select SYSDATETIME() 
select GETUTCDATE() /*** Get database server time ***/

declare @dt1 datetimeoffset(5) 
set @dt1='2007-10-29 22:50:55 -1:00'
select @dt1

declare @dt2 datetimeoffset(0) 
set @dt2='2007-10-29 22:50:55 +5:00'
select @dt2

SELECT ISNULL(NULL, 'W3Schools.com')
SELECT NULLIF(25, 25)

SELECT IIF(500<1000, 'YES', 'NO')
SELECT CHOOSE(3, 'Apple', 'Orange', 'Kiwi', 'Cherry') AS Result3

DECLARE @d DATETIME = '12/01/2018';
SELECT FORMAT (@d, 'd', 'en-US') AS 'US English Result',
               FORMAT (@d, 'd', 'no') AS 'Norwegian Result',
               FORMAT (@d, 'd', 'zu') AS 'Zulu Result'
			   --format(@d, 'd', 'en-gb') as 'UK Result

--unique identifier
--globally unique across tables, database and servers
select newid() as uniqueidentifier

--untyped xml
--typed xml

use AdventureWorks2012
select * from Production.ProductModel

create database TestTraining

use TestTraining
create table customer
(
id int,
custdetails xml
)
insert into customer values(1,'<Customer><Name>Mark</Name><City>NY</City></Customer>')
insert into customer values(2,'<Customer><Name>Mark</Name><City>NY</City><Email>Mark@gmail.com</Email></Customer>')
select * from customer

create xml schema collection CustomerCollection
as
'<schema xmlns="http://www.w3.org/2001/XMLSchema">
	<element name="CustomerName" type="string"/>
	<element name="Email" type="string"/>
	<element name="City" type="string"/>
</schema>'

select * from sys.xml_schema_collections

create table customers
(
id int,
custdetails xml(CustomerCollection)
)
insert into customers values(1,'<CustomerName>Mark</CustomerName><City>NY</City>')
insert into customers values(2,'<CustomerName>Mark</CustomerName><City>NY</City><Email>Mark@gmail.com</Email>')

select * from Customers
--table data type
create table table1(id int,name char(10))

declare @newtable table (id int,name char(10))
insert into @newtable values(1,'user1')
select * from @newtable

create type customertype as table(custid int,name char(10))

create proc prccustomer(@c customertype readonly)
as
begin
insert into table1 select * from @c
--select * into table2 from @c
end

declare @customer customertype
insert into @customer values(10,'user10')
insert into @customer values(20,'user20')
exec prccustomer @customer

select * from table1
select * from table2


--Joining two tables
CREATE TABLE Author
(
    id INT PRIMARY KEY,
    author_name VARCHAR(50) NOT NULL,
    
 )
 
CREATE TABLE Book
(
    id INT PRIMARY KEY,
    book_name VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    author_id INT NOT NULL
   
 )
 
 INSERT INTO Author 
 
VALUES
(1, 'Author1'),
(2, 'Author2'),
(3, 'Author3'),
(4, 'Author4'),
(5, 'Author5'),
(6, 'Author6'),
(7, 'Author7')
 
 
INSERT INTO Book 
 
VALUES
(1, 'Book1',500, 1),
(2, 'Book2', 300 ,2),
(3, 'Book3',700, 1),
(4, 'Book4',400, 3),
(5, 'Book5',650, 5),
(6, 'Book6',400, 3)

SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
INNER JOIN Book B
ON A.id = B.author_id

SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
LEFT JOIN Book B
ON A.id = B.author_id


-- Creating Table Valued function
CREATE FUNCTION fnGetBooksByAuthorId(@AuthorId int)
RETURNS TABLE
AS
RETURN
( 
SELECT * FROM Book
WHERE author_id = @AuthorId
)

SELECT * FROM fnGetBooksByAuthorId(3)

-- Joining Table with Table Valued function - This will fail.
SELECT A.author_name, B.id, B.author_id, B.book_name, B.price
FROM Author A
INNER JOIN fnGetBooksByAuthorId() B
ON A.id = B.author_id

--Joining Table Valued Functions
--APPLY Operators are used to join Table Valued functions
select * from author;
select * from book;

SELECT A.author_name, B.id, b.author_id, B.book_name, B.price
FROM Author A
CROSS APPLY fnGetBooksByAuthorId(A.Id) B

SELECT A.author_name, B.id, b.author_id, B.book_name, B.price
FROM Author A
OUTER APPLY fnGetBooksByAuthorId(A.Id) B

--TEMPORARY TABLES
--The temporary data can be either materialized data and actually stored in tables or just a temporary set of data 
--that is created by sub-queries, common table expressions, table valued functions or other means.
/*
TABLE VARIABLE
TEMP TABLE
SUBQUERIES
DERIVED TABLE
COMMON TABLE EXPRESSION (CTE)
***/

--CTE

WITH CTE_GetBooksByAuthor AS 
(
SELECT A.author_name, B.id, B.book_name, B.price
FROM Author A
INNER JOIN Book B
ON A.id = B.author_id
)

select * from CTE_GetBooksByAuthor;


-- Clustered Index are Primary Key
-- you can see this using query execution plan - "CTRL + L"
alter TABLE s_Customer
 ADD CONSTRAINT [PK_Customer_CustomerID] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
) 

SELECT *
FROM [dbo].[s_customer]
WHERE storeid = 1280

-- Non-Clustered Index - After Index creation, query will be forced to use Non-Clustered Index
-- you can see this using query execution plan - "CTRL + L"
create index idx_storeid
on s_customer(storeid)


SELECT *
FROM [dbo].[s_customer]
WHERE storeid = 1280


-- QUERY EXECUTION PLAN
USE AdventureWorks2012

SELECT * 
FROM [Sales].[SalesPerson] sp
INNER JOIN [Sales].[SalesPersonQuotaHistory] spq
  ON sp.BusinessEntityID = spq.BusinessEntityID
ORDER BY sp.SalesQuota
GO
 
SELECT * 
FROM [Sales].[SalesPerson] sp
INNER HASH JOIN [Sales].[SalesPersonQuotaHistory] spq
  ON sp.BusinessEntityID = spq.BusinessEntityID
ORDER BY sp.SalesQuota
GO


SET STATISTICS IO ON
GO
SELECT * 
FROM [Sales].[SalesPerson] sp
INNER JOIN [Sales].[SalesPersonQuotaHistory] spq
  ON sp.BusinessEntityID = spq.BusinessEntityID
ORDER BY sp.SalesQuota
GO
SET STATISTICS IO OFF
GO

SET STATISTICS TIME ON
GO
SELECT * 
FROM [Sales].[SalesPerson] sp
INNER JOIN [Sales].[SalesPersonQuotaHistory] spq
  ON sp.BusinessEntityID = spq.BusinessEntityID
ORDER BY sp.SalesQuota
GO
SET STATISTICS TIME OFF
GO

SET SHOWPLAN_TEXT ON
GO
SELECT * 
FROM [Sales].[SalesPerson] sp
INNER JOIN [Sales].[SalesPersonQuotaHistory] spq
  ON sp.BusinessEntityID = spq.BusinessEntityID
ORDER BY sp.SalesQuota
GO
SET SHOWPLAN_TEXT OFF
GO

SET SHOWPLAN_ALL ON
GO
SELECT * 
FROM [Sales].[SalesPerson] sp
INNER JOIN [Sales].[SalesPersonQuotaHistory] spq
  ON sp.BusinessEntityID = spq.BusinessEntityID
ORDER BY sp.SalesQuota
GO
SET SHOWPLAN_ALL OFF
GO

SET SHOWPLAN_XML ON
GO
SELECT * 
FROM [Sales].[SalesPerson] sp
INNER JOIN [Sales].[SalesPersonQuotaHistory] spq
  ON sp.BusinessEntityID = spq.BusinessEntityID
ORDER BY sp.SalesQuota
GO
SET SHOWPLAN_XML OFF
GO

--FULL TEXT SEARCH INDEX

--CHECKING FULL TEXT SEARCH IS INSTALLED
SELECT 
	CASE FULLTEXTSERVICEPROPERTY('IsFullTextInstalled')
		WHEN 1 THEN 'Full-Text installed.' 
		ELSE 'Full-Text is NOT installed.' 
	END
;

--CHECKING FULL TEXT SEARCH IS ENABLED
SELECT is_fulltext_enabled
FROM sys.databases
WHERE database_id = DB_ID()


--CHECK FULL TEXT CATALOG EXIST
select *
FROM sys.fulltext_catalogs


EXEC sp_configure 'show advanced options'

--FILESTREAM: Enable filestream on the instance level
--0 = disabled (this is the default)
--1 = enabled only for T-SQL access
--2 = enabled for T-SQL access and local file system access
--3 = enabled for T-SQL access, local file system access, and remote file system access
EXEC sp_configure filestream_access_level, 2
RECONFIGURE WITH OVERRIDE

SELECT 
 SERVERPROPERTY ('FilestreamShareName') ShareName
,SERVERPROPERTY ('FilestreamConfiguredLevel') ConfiguredLevel
,SERVERPROPERTY ('FilestreamEffectiveLevel') EffectiveLevel

--CREATING FILE GROUP
ALTER DATABASE TestTraining
ADD FILEGROUP tt_fg_filestream CONTAINS FILESTREAM
GO

--ADDING NTFS FILE TO FILEGROUP
ALTER DATABASE TestTraining
ADD FILE
(
    NAME= 'tt_filestream',
    FILENAME = 'F:\SQL Server 2012 Works\SQL Codes\FileStream\fs'
)
TO FILEGROUP tt_fg_filestream
GO

--CREATING A TABLE TO HOLD BLOB'S
CREATE TABLE dbo.BLOB (
 ID UNIQUEIDENTIFIER ROWGUIDCOL NOT NULL UNIQUE,
 BLOB VARBINARY(MAX) FILESTREAM NULL
)


--Add a BLOB from T-SQL
DECLARE @ID UNIQUEIDENTIFIER
SET @ID = NEWID()
--INSERT INTO dbo.BLOB
-- (ID, BLOB)
--VALUES 
-- (@ID, CAST('BLOB Placeholder' AS VARBINARY(MAX)))

INSERT INTO dbo.BLOB
 (ID, BLOB)
VALUES 
 (@ID, CAST('G:\Ashok\Ashok.jpg' AS VARBINARY(MAX)))

SELECT ID, BLOB 
FROM dbo.BLOB
WHERE ID = @ID
SELECT BLOB.PathName() 
FROM dbo.BLOB
WHERE ID = @ID


--FileStream
create database TestDatabase
on
primary (name=TestDatabase,
filename='c:\data\TestDatabase.mdf'),
filegroup FileStreamGroup contains FILESTREAM(name=TestDatabase_data,
filename='c:\data\TestDatabase_data')
log on(name=log1,filename='c:\data\TestDatabase.ldf')

use TestDatabase
create table empdetails
(
empid uniqueidentifier rowguidcol not null unique,
empname varchar(30),
address varchar(100),
empdept varchar(20),
empphoto varbinary(max) filestream
)

insert into empdetails values(NEWID(),'Mark','California','Testing',CAST('f:\person.jpg' as varbinary(max)))
select * from empdetails

--Each cell in the FILESTREAM column is a file path on the file system associated with it.
--To read the path, it is necessary to use the PathName property of the varbinary (max) column in the T-SQL statement. 

declare @filepath varchar(max)
select @filepath=empphoto.PathName() from empdetails
where empid='4F2A8A6F-0774-47EC-92BC-A1DAC26D26BD'
print @filepath

use TestTraining
--geometry
create table geom
(
id int identity(1,1),
name char(10),
geom1 geometry,
geom2 as geom1.STAsText()
)

--Returns a geometry instance from an Open Geospatial Consortium (OGC) Well-Known Text (WKT)
--representation augmented with any Z (elevation) and M (measure) values carried by the instance.

insert into geom values('Line',geometry::STGeomFromText('linestring(100 100,20 180,180 180)',0))
select * from geom
select geom1.ToString() as GEOM1 from geom

DECLARE @circle geometry  
=geometry::Parse('CIRCULARSTRING(3 2, 2 3, 1 2, 2 1, 3 2)');  
select @circle

DECLARE @Tri geometry 
= geometry::STGeomFromText('POLYGON((100 100,200 300,300 100, 100 100))', 0);
select @Tri

--geography
create table country
(
countryid int identity(1,1),
name char(10),
location geography
)
insert into country values('india',Geography::Parse('point(-83.0086 39.95954)'))
select * from country
select name,location.ToString() as Location from country


-- VIEWS

select * into s_employee 
from [AdventureWorks2012].[HumanResources].[Employee]

create view vw_s_employee as 
select * from TestTraining.[dbo].s_employee

drop view vw_s_employee;

sp_helptext vw_s_employee;

select * from s_employee;
SELECT * from vw_s_employee;

Exec sp_refreshview vw_s_employee;

Alter Table TestTraining.[dbo].s_employee Add City nvarchar(50);

-- SCHEMABINDING locks the table and view stops making any chances to underlying table structure
create view vw_s_customer
with schemabinding
as
select [CustomerID]
      ,[PersonID]
      ,[StoreID]
      ,[TerritoryID]
      ,[AccountNumber]
      ,[rowguid]
      ,[ModifiedDate]
from [dbo].[s_customer]

Alter Table TestTraining.[dbo].s_customer Add City nvarchar(50);
Alter Table TestTraining.[dbo].s_customer drop column City;
Alter Table TestTraining.[dbo].s_customer ALTER COLUMN StoreID BIGINT;

-- ENCRYPTION stops people seeing the view definition
create view vw_author
with encryption
as
select * from [dbo].Author

exec sp_helptext vw_author;

create view vw_book as
select * from dbo.Book
where author_id = 1

--Inserting into table using View
INSERT INTO [dbo].[vw_book]([id],[book_name],[price],[author_id]) VALUES(7,'book7', 700, 6)


--OUTPUT CLAUSE
--OUTPUT gives access to two virtual tables (Magic Tables). These are:

--1.INSERTED” contains the new rows (INSERT or UPDATE‘s SET)
--2.DELETED” contains the old copy of the rows(empty for INSERT)
IF OBJECT_ID ('Department_SRC', 'U') IS NOT NULL
DROP TABLE dbo.Department_SRC;
CREATE TABLE [dbo].[Department_SRC](
       [DepartmentID] [smallint] IDENTITY(1,1) NOT NULL,
       [Name] varchar(50)  NOT NULL,
       [GroupName] varchar(50) NOT NULL,
       [ModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
Insert into [dbo].[Department_SRC]([Name],[GroupName],[ModifiedDate])
 Values('Engineering','Research and Development',getdate());

 declare @inserted as table(departmentId smallint, name varchar(50), groupname varchar(50), modifieddate datetime);

 insert into [dbo].[Department_SRC]([Name],[GroupName],[ModifiedDate])
 output inserted.DepartmentID, inserted.name, inserted.GroupName, inserted.ModifiedDate into @inserted
 values ('Service Desk','Technical Admin', getdate());

 select * from @inserted;

  declare @Deleted as table(departmentId smallint, name varchar(50), groupname varchar(50), modifieddate datetime);

  delete from [dbo].[Department_SRC]
  output deleted.DepartmentID, deleted.Name, deleted.GroupName, deleted.ModifiedDate into @Deleted
  where DepartmentID = 6

  select * from @Deleted




--NULL functions
create table EmpSal
(
empid int,
empname char(4),
salary money
)
insert into EmpSal values(1,'Emp1',30000),(2,'Emp2',null),(3,'Emp3',46000),
(4,'Emp4',null),(5,'Emp5',null),(6,'Emp6',40000)

select * from EmpSal

select *, isnull(salary,25000) as Salary from Empsal
select sum(salary) from Empsal
select sum(salary), sum(isnull(salary,25000)) as Salary from Empsal

create table EmpContact
(
empid int,
empname char(4),
Phone1 char(10),
Phone2 char(10)
)
insert into EmpContact values(1,'Emp1','3632677876',null)
insert into EmpContact values(2,'Emp2','9832677876','9097483847')
insert into EmpContact values(3,'Emp3','9932677876',null)
insert into EmpContact values(4,'Emp4',null,'848934839')
insert into EmpContact values(5,'Emp5',null,null)

select * from EmpContact
select EmpName,coalesce(phone1,phone2) from EmpContact

create table Sales
(
Region char(10),
Actual int,
Target int
)
insert into Sales values('East',80,100)
insert into Sales values('West',100,100)
insert into Sales values('North',50,80)
insert into Sales values('South',50,50)
select * from sales
select Region,nullif(Actual,Target) as SalesValue from Sales

--Logical Functions
--IIF ( boolean_expression, true_value, false_value )
DECLARE @X INT;
SET @X=70;
DECLARE @Y INT;
SET @Y=60;
Select iif(@X>@Y, 50, 60) As IIFResult

--CHOOSE ( index, value1, value2.... [, valueN ] )
DECLARE @Index INT;
SET @Index =2
Select Choose(@Index, 'L','M','N','O','W','X','Y','Z') As ChooseResult 

--When passed a set of types to the function it returns the data type with the highest precedence
--fractional numbers have higher precedence than integers
DECLARE @Index1 INT;
--SET @Index1 =10;
set @index1=floor(3.2)
Select Choose(@Index1, 12.5,null,10,23,15.5,18,20) As ChooseResult 

--string functions
--formats (d,D,m,M,y,f,F,g,G)
DECLARE @d DATETIME = '2020-11-01'
SELECT FORMAT ( @d, 'D', 'en-US' ) AS Result;
SELECT FORMAT ( @d, 'd', 'en-US' ) AS Result;
SELECT FORMAT ( @d, 'm', 'en-US' ) AS Result;
SELECT FORMAT ( @d, 'F', 'en-US' ) AS Result;


declare @fn varchar(5)= 'SQL'
declare @ln varchar(7) ='Server'
print concat(@fn,space(1),@ln)

--conversion functions
CREATE TABLE Students
(
  Id INT PRIMARY KEY IDENTITY,
  Name VARCHAR (50),
  Age VARCHAR (50)
)
 
INSERT INTO Students VALUES ('Sally', '25' )
INSERT INTO Students VALUES ('Edward', 'Thirty' )
INSERT INTO Students VALUES ('Jon', '30' )
INSERT INTO Students VALUES ('Scot', 'Thirty Five' )
INSERT INTO Students VALUES ('Ben', '36' )

select * from Students

SELECT Name, PARSE(Age as INT) as AGE FROM Students
SELECT Name, TRY_PARSE(Age as INT) as AGE FROM Students

--The TRY_PARSE function can only convert strings to numeric or date data types. 
--The TRY_CONVERT function can perform conversions between all the data types except
--those where conversion is explicitly not permitted.

select try_convert(int,'150') as RESULT
select convert(xml,'150') as RESULT
select try_convert(xml,150) as RESULT

SELECT 
CASE WHEN TRY_CONVERT(xml, '150') IS NULL
  THEN 'Data conversion unsuccessful'
  ELSE 'Data converted successfully'
END AS OUTPUT

SELECT Name, convert(int,age) as AGE FROM Students
SELECT Name, TRY_convert(int,age) as AGE FROM Students

