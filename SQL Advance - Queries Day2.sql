--APPLY OPERATOR
use TestTraining
create table depositor
(
customername char(20) primary key,
acc_num int
)
insert into depositor values('Nora',101)
insert into depositor values('Robin',103)
insert into depositor values('James',107)
insert into depositor values('Jennifer',109)

create table borrower
(
customername char(20) primary key,
loan_num int
)

insert into borrower values('Nora',301)
insert into borrower values('Robin',303)
insert into borrower values('James',307)
insert into borrower values('Jennie',309)

select * from depositor
select * from borrower

select d.acc_num,d.customername,br.loan_num from depositor d inner join borrower
br on d.customername =br.customername

select d.acc_num,d.customername,br.loan_num from depositor d left outer join borrower
br on d.customername =br.customername

create function fn_borrower(@name varchar(20))
returns table
as
return (Select * from borrower where customername=@name)

select d.acc_num,d.customername,br.loan_num from depositor d inner join 
fn_borrower(d.customername) br on d.customername =br.customername

select d.acc_num,d.customername,br.loan_num from depositor d cross apply
fn_borrower(d.customername) br 
--on d.customername =br.customername

--cross apply (rows from outer result set which matches with
--the inner result set)
select d.customername,d.acc_num,br.loan_num from depositor d
cross apply
(select * from borrower b where d.customername=b.customername) br

--outer apply (all rows from outer result set)
select d.customername,d.acc_num,br.loan_num from depositor d
outer apply
(select * from borrower b where d.customername=b.customername) br

select d.acc_num,d.customername,br.loan_num from depositor d outer apply
fn_borrower(d.customername) br 

--ResultSets

--except (compares the result set and returns the names from first 
-- result set that is not found in the second)
select customername from depositor
except
select customername from borrower

--intersect (returns common rows)
select customername from depositor
intersect
select customername from borrower

--union (returns all rows)
select customername from depositor
union
select customername from borrower

--CTE (Common Table Expression)

use AdventureWorks
SELECT max(rate) from HumanResources.EmployeePayHistory
select rate from HumanResources.EmployeePayHistory
with RateCTE(Rate)
as
(
select top 10 rate=rate from HumanResources.EmployeePayHistory
)
select rate,max_rate=(select max(rate) from RateCTE)
from RateCTE
select * from HumanResources.Employee
with rec_cte(LoginId,ManagerID,EmployeeID) as
(
select loginid,Managerid,EmployeeID from HumanResources.Employee
where ManagerID is null
union all
select e.Loginid,e.Managerid,e.EmployeeID from
HumanResources.Employee e
inner join rec_cte d
on e.ManagerID=d.EmployeeID
)
select * from rec_cte

use TestTraining
select * into tempEmp from AdventureWorks2012.HumanResources.EmployeePayHistory
select * from tempEmp
select * into dmloutput from tempEmp
truncate table dmloutput
select * from dmloutput

--deleted
update tempEmp
set Rate=12.55
output deleted.*
into dmloutput where BusinessEntityID = 1

select * from dmloutput

--inserted.*
update tempemp
set Rate=50.45
output inserted.*
into dmloutput where BusinessEntityID=1

--merge (Comparing and updating data)
create table education
(
edcode int primary key,
education char(20)
)
insert into education values(1,'B.Com')
insert into education values(2,'Bsc')
insert into education values(3,'MBA')
insert into education values(4,'MCA')

select * from education
select * into edu_backup from education
select * from edu_backup

create trigger trg1 on education 
for insert,update,delete
as
begin
merge edu_backup as target using education as source
on(target.edcode=source.edcode)
when matched and target.education<>source.education
then update set target.education=source.education
when not matched then
insert values(source.edcode,source.education)
when not matched by source then
delete;
end

select * from education
select * from edu_backup
	
insert into education values(5,'M.tech')
update education set education='BPharm' where edcode=5
delete education where edcode=5

--view

select * into Employee from AdventureWorks.HumanResources.Employee
select * from Employee

create view vwEmployee
as
select EmployeeID,LoginId,Title from Employee

select * from vwEmployee
update vwEmployee set Title='Engineering Manager' where EmployeeID=1


select * from sys.system_views
select * from sys.views
select * from INFORMATION_SCHEMA.views

--creating linked servers

exec sp_addlinkedserver
@server='server1',
@srvproduct='SQLServer OLEDB Provider',
@provider='SQLOLEDB',
@datasrc='DELL'

exec sp_addlinkedserver
@server='server2',
@srvproduct='SQLServer OLEDB Provider',
@provider='SQLOLEDB',
@datasrc='DELL\MSSQLSERVER01'

EXEC sp_addlinkedsrvlogin server2, FALSE, 'sa', 'syntel123$';  

create view vwProduct_Sales
as
SELECT pr.ProductID,pr.Name, sod.SalesOrderID FROM 
Server1.Adventureworks2012.Production.Product AS pr  
INNER JOIN Server2.AdventureWorks2012.Sales.SalesOrderDetail AS sod  
ON pr.ProductID = sod.ProductID
where pr.Name like 'Bike%'

select * from vwProduct_Sales

--indexes

select * from depositor
sp_help depositor
sp_helpindex depositor

create table UserInfo
(
userid int not null,
UserName char(10),
Password char(10)
)

sp_helpindex UserInfo

create clustered index idx_userid on userinfo(userid)
with fillfactor=80

create index idx_name on userinfo(username)
where username > 'D'

select * from sys.indexes
select * from UserInfo
alter index idx_userid on userinfo disable
alter index idx_userid on userinfo rebuild

exec sp_rename 'userinfo.idx_name','idx_username','index'
exec sp_helpindex userinfo;

drop index userinfo.idx_username

select * from depositor

set showplan_all on
set showplan_all off

set showplan_xml on
set showplan_xml off

--Full text search
use AdventureWorks2012
select * from Production.ProductDescription

create fulltext catalog catalog1 as default

create unique index idx_desc on Production.ProductDescription
(ProductDescriptionID)

sp_helpindex 'production.productdescription'

create fulltext index on Production.ProductDescription(Description)
key index idx_desc

alter fulltext index on Production.ProductDescription
start full population

--FreeText (displays the rows that contains word related to race and winners')
SELECT Description FROM 
Production.ProductDescription 
WHERE FREETEXT (Description, 'race winners')

--FreeTextTable
SELECT * FROM FREETEXTTABLE (Production.ProductDescription, Description, 
'high level of performance');  

SELECT FT_TBL.Description  
    ,KEY_TBL.RANK  
FROM Production.ProductDescription AS FT_TBL   
    INNER JOIN FREETEXTTABLE(Production.ProductDescription,  
    Description,   
    'high level of performance') AS KEY_TBL  
ON FT_TBL.ProductDescriptionID = KEY_TBL.[KEY]  
ORDER BY RANK DESC;  
GO 

--Contains
SELECT Description 
FROM Production.ProductDescription
WHERE CONTAINS (Description, 'ride NEAR bike')

--containstable (Matching word for entry)
SELECT f.RANK,ProductDescriptionID,Description
From Production.ProductDescription d
INNER JOIN 
CONTAINSTABLE(Production.ProductDescription, 
Description,'Entry ')f
ON d.ProductDescriptionID = f.[KEY]
ORDER BY f.RANK DESC

