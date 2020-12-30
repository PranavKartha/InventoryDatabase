--*************************************************************************--
-- Title: Assignment05
-- Author: PKartha
-- Desc: This file demonstrates how to use stored procedures.
-- Change Log: 5/1/2020, PKartha, wrote script
--**************************************************************************--
-- Step 1: Create the assignment database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'Assignment05DB_PKartha')
 Begin 
  Alter Database [Assignment05DB_PKartha] set Single_user With Rollback Immediate;
  Drop Database Assignment05DB_PKartha;
 End
go

Create Database Assignment05DB_PKartha;
go

Use Assignment05DB_PKartha;
go

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go


-- Show the Current data in the Categories, Products, and Inventories Tables


-- Step 2: Add some starter data to the database


/* Add the following data to this database using inserts:
Category	Product	Price	Date		Count
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	17

Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	12

Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
*/

Insert into Categories(CategoryName)
	Values('Beverages');
go
Insert into Products(ProductName, CategoryID, UnitPrice)
	Values('Chai', 1, 18),
		  ('Chang', 1, 19);

Insert into Inventories(InventoryDate, ProductID, [Count])
	Values('2017-01-01', 1, 61),
		  ('2017-01-01', 2, 17),
		  ('2017-02-01', 1, 13),
		  ('2017-02-01', 2, 12),
		  ('2017-03-02', 1, 18),
		  ('2017-03-02', 2, 12)
		   


Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go


-- Step 3: Create transactional stored procedures for each table using the proviced template:
Create Procedure pInsCategory
(@CategoryName nvarchar(100))
/* Author: PKartha
** Desc: Inserts values into Category Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Insert into Categories(CategoryName)
			Values(@CategoryName);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

exec pInsCategory @CategoryName ='Beverages'
go




Create Procedure pUpdCategory
(@CategoryID int, @CategoryName nvarchar(100))
/* Author: PKartha
** Desc: Updates values in Category Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Update Categories
			set CategoryName = @CategoryName
			where CategoryID = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelCategory
(@CategoryID int)
/* Author: PKartha
** Desc: Deletes values in Category Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Delete from Categories
			where CategoryID = @CategoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsProduct
(@ProductName nvarchar(100), @CategoryID int, @UnitPrice money)
/* Author: PKartha
** Desc: Inserts values into Product Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Insert into Products(ProductName, CategoryID, UnitPrice)
			Values(@ProductName, @CategoryID, @UnitPrice);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdProduct
(@ProductID int, @ProductName nvarchar(100), @CategoryID int, @UnitPrice money)
/* Author: PKartha
** Desc: Updates values in Category Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Update Products
			set ProductName = @ProductName,
				CategoryID = @CategoryID,
				UnitPrice = @UnitPrice
			where ProductID = @ProductID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelProduct
(@ProductID int)
/* Author: PKartha
** Desc: Deletes values in Products Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Delete from Products
			where ProductID = @ProductID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsInventory
(@InventoryDate date, @ProductID int, @Count int)
/* Author: PKartha
** Desc: Inserts values into Product Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Insert into Inventories(InventoryDate, ProductID, [Count])
			Values(@InventoryDate, @ProductID, @Count);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdInventory
(@InventoryID int, @InventoryDate date, @ProductID int, @Count int)
/* Author: PKartha
** Desc: Updates values in Inventory Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Update Inventories
			set InventoryDate = @InventoryDate,
				ProductID = @ProductID,
				[Count] = @Count
			where InventoryID = @InventoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelInventory
(@InventoryID int)
/* Author: PKartha
** Desc: Deletes values in Products Table
** Change Log: 5/1/2020-Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
		Delete from Inventories
			where InventoryID = @InventoryID;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Step 4: Create code to test each transactional stored procedure. 

--test for pInsCategory
Declare @Status int;
Exec @Status = pInsCategory @CategoryName = 'Food'
Select Case @Status
	When +1 Then 'Insert was successful!'
	When -1 Then 'Insert failed! Common issues: Duplicate Data'
	End as [Status]
Select [The new identity was:] = @@IDENTITY
go



--negative test for pInsCategory. contains repeated data
Declare @Status int;
Exec @Status = pInsCategory @CategoryName = 'Food'
Select Case @Status
	When +1 Then 'Insert was successful!'
	When -1 Then 'Insert failed! Common issues: Duplicate Data'
	End as [Status]
Select [The new identity was:] = @@IDENTITY
go 




--test for pUpdCategory
Declare @Status int;
Exec @Status = pUpdCategory @CategoryID = 1, @CategoryName = 'Drinks'
Select Case @Status
	When +1 Then 'Update was successful!'
	When -1 Then 'Update failed! Common issues: Check values'
	End as [Status]
go
Select * from Categories

-- negative test for pUpdCategory. Contains incorrect data types
Declare @Status int;
Exec @Status = pUpdCategory @CategoryID = 3, @CategoryName = 'Drinks'
Select Case @Status
	When +1 Then 'Update was successful!'
	When -1 Then 'Update failed! Common issues: Check values'
	End as [Status]
go
Select * from Categories;


--test for pDelCategory
Declare @Status int;
Exec @Status = pDelCategory @CategoryID = 3
Select Case @Status
	When +1 Then 'Delete was successful!'
	When -1 Then 'Delete failed! Common issues: Foreign Key Values must be deleted first'
	End as [Status]
go

Select * from Categories;


--test for pInsProduct
Declare @Status int;
Exec @Status = pInsProduct @ProductName = 'Juice', @CategoryID = 1, @UnitPrice = 2
Select Case @Status
	When +1 Then 'Insert was successful!'
	When -1 Then 'Insert failed! Common issues: Check values'
	End as [Status]
Select [The new identity was:] = @@IDENTITY
go

Select * from Products;

--negative test for pInsProduct, repeat values
Declare @Status int;
Exec @Status = pInsProduct @ProductName = 'Juice', @CategoryID = 1, @UnitPrice = 2
Select Case @Status
	When +1 Then 'Insert was successful!'
	When -1 Then 'Insert failed! Common issues: Check values'
	End as [Status]
Select [The new identity was:] = @@IDENTITY
go

Select * from Products;


--test for pUpdProduct
Declare @Status int;
Exec @Status = pUpdProduct @ProductID = 1, @ProductName = 'Tea', @CategoryID = 1, @UnitPrice  = 2
Select Case @Status
	When +1 Then 'Update was successful!'
	When -1 Then 'Update failed! Common issues: Check values'
	End as [Status]
go

Select * from Products;


--negative test for pUpdProduct
Declare @Status int;
Exec @Status = pUpdProduct @ProductID = 1, @ProductName = 'Chang', @CategoryID = 1, @UnitPrice  = 2
Select Case @Status
	When +1 Then 'Update was successful!'
	When -1 Then 'Update failed! Common issues: Check values'
	End as [Status]
go

Select * from Products;

--test for pDelProduct
Declare @Status int;
Exec @Status = pDelProduct @ProductID = 2
Select Case @Status
	When +1 Then 'Delete was successful!'
	When -1 Then 'Delete failed! Common issues: Foreign Key Values must be deleted first'
	End as [Status]
go

Select * from Products;
--test for pInsInventory
Declare @Status int;
Exec @Status = pInsInventory @InventoryDate = '2020-2-2', @ProductID = 2, @Count = 2
Select Case @Status
	When +1 Then 'Insert was successful!'
	When -1 Then 'Insert failed! Common issues: Check values'
	End as [Status]
Select [The new identity was:] = @@IDENTITY
go

Select * from Inventories;

--negative test for pInsInventory, repeat values
Declare @Status int;
Exec @Status = pInsInventory @InventoryDate = '2020-2-2', @ProductID = 1000, @Count = 2
Select Case @Status
	When +1 Then 'Insert was successful!'
	When -1 Then 'Insert failed! Common issues: Check values'
	End as [Status]
Select [The new identity was:] = @@IDENTITY
go

Select * from Inventories;


--test for pUpdInventory
Declare @Status int;
Exec @Status = pUpdInventory @InventoryID = 1, @InventoryDate = '2020-1-7', @ProductID = 2, @Count = 27
Select Case @Status
	When +1 Then 'Update was successful!'
	When -1 Then 'Update failed! Common issues: Check values'
	End as [Status]
go

Select * from Inventories;

--negative test for pUpdInventory
Declare @Status int;
--Declare @NewID int = IDENT_CURRENT('Inventories')
Exec @Status = pUpdInventory @InventoryID = 1, @InventoryDate = '2020-1-7', @ProductID = 7000, @Count = 27
Select Case @Status
	When +1 Then 'Update was successful!'
	When -1 Then 'Update failed! Common issues: Check values'
	End as [Status]
go

Select * from Inventories;
--test for pDelInventory
Declare @Status int;
Declare @NewID int = IDENT_CURRENT('Inventories')
Exec @Status = pDelInventory @InventoryID = @NewID
Select Case @Status
	When +1 Then 'Delete was successful!'
	When -1 Then 'Delete failed! Common issues: Foreign Key Values must be deleted first'
	End as [Status]
go

Select * from Inventories;



