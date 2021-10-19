CREATE DATABASE OPENXMLTesting
GO

USE OPENXMLTesting
GO

CREATE TABLE XMLwithOpenXML
(
Id INT IDENTITY PRIMARY KEY,
XMLData XML,
LoadedDateTime DATETIME
)

INSERT INTO XMLwithOpenXML(XMLData, LoadedDateTime)
SELECT CONVERT(XML, BulkColumn) AS BulkColumn, GETDATE() 
FROM OPENROWSET(BULK 'D:\XML\Demo2.xml', SINGLE_BLOB) AS x

SELECT * FROM XMLwithOpenXML


DECLARE @XML AS XML, @hDoc AS INT, @SQL NVARCHAR (MAX)

SELECT @XML = XMLData FROM XMLwithOpenXML

EXEC sp_xml_preparedocument @hDoc OUTPUT, @XML

SELECT CustomerID, CustomerName, Address, OrderID, OrderDate, ProductID, Quantity
FROM OPENXML(@hDoc, 'ROOT/Customers/Customer/Orders/Order/OrderDetail')
WITH 
(
CustomerID [varchar](50) '../../../@CustomerID',
CustomerName [varchar](100) '../../../@CustomerName',
Address [varchar](100) '../../../Address',
OrderID [varchar](1000) '../@OrderID',
OrderDate datetime '../@OrderDate',
ProductID [varchar](50) '@ProductID',
Quantity int '@Quantity'
)

EXEC sp_xml_removedocument @hDoc
GO