--Transactions
use TestTraining
begin transaction
select * from Sales
commit transaction

SET IMPLICIT_TRANSACTIONS ON 
insert Sales values('NorthEast',70,75) --start the first transaction
COMMIT TRANSACTION --commit the first transaction
select * from Sales --starts the second transaction
COMMIT TRANSACTION --commit the second transaction

SET IMPLICIT_TRANSACTIONS OFF

--EXPLICIT TRANSACTIONS
use AdventureWorks
select * from Person.Contact where ContactId=3
select * from HumanResources.EmployeeAddress where Employeeid=1

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRANSACTION TR1
BEGIN TRY
	UPDATE Person.Contact 
	SET EmailAddress='kim2@yahoo.com' 
	WHERE ContactID = 3
	save transaction tr1
	--Statement 1
	UPDATE HumanResources.EmployeeAddress SET AddressID = 65345
	WHERE EmployeeID = 1
	COMMIT TRANSACTION TR1
	--Statement 2
	SELECT 'Transaction Executed'
END TRY
BEGIN CATCH
  ROLLBACK TRANSACTION TR1
  SELECT 'Transaction Rollbacked'
END CATCH

create table TestTable1(id int, value int)
BEGIN TRANSACTION 
 
INSERT INTO TestTable1( ID, Value )VALUES  ( 1, 10)
-- create a savepoint after the first INSERT
SAVE TRANSACTION FirstInsert

INSERT INTO TestTable1( ID, Value )VALUES  ( 2, 20) 
-- will rollback to the savepoint after the first INSERT was done
ROLLBACK TRANSACTION FirstInsert

-- commit the transaction leaving just the first INSERT 
COMMIT
 
SELECT * FROM TestTable1

