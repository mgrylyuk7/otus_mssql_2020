1. Выберите сотрудников, которые являются продажниками, и еще не сделали ни одной продажи.

select
    PersonId,
    FullName
from 
    Application.People where (
            select 
                count(InvoiceId) as SalesCount 
                from Sales.Invoices
                where Invoices.SalespersonPersonID = People.PersonID) = 0;


2. Выберите товары с минимальной ценой (подзапросом), 2 варианта подзапроса.

SELECT StockItemID, StockItemName, UnitPrice 
FROM Warehouse.StockItems
WHERE UnitPrice <= ALL (SELECT top(5) UnitPrice 
	FROM Warehouse.StockItems);

 
 Выберите информацию по клиентам, которые перевели компании 5 максимальных платежей из [Sales].[CustomerTransactions] представьте 3 способа (в том числе с CTE)


select * from Sales.Customers as sc
join (select top(5) CustomerID
        from Sales.CustomerTransactions 
        ORDER by TransactionAmount desc) as  sub_query_sc on sub_query_sc.CustomerID = sc.CustomerID;


select * from Sales.Customers
where Sales.Customers.CustomerID in (select top(5) CustomerID
        from Sales.CustomerTransactions 
        ORDER by TransactionAmount desc);


WITH totalamount as (select top(5) CustomerID
        from Sales.CustomerTransactions ORDER by TransactionAmount desc)
Select *from Sales.Customers where Sales.Customers.CustomerId in (select *from totalamount);


Выберите города (ид и название), в которые были доставлены товары, входящие в тройку самых дорогих товаров,
 а также Имя сотрудника, который осуществлял упаковку заказов
		
Не могу понять какие таблицы нужно соединять и по каким полям.


5. Объясните, что делает и оптимизируйте запрос:

SELECT
Invoices.InvoiceID,
Invoices.InvoiceDate,
(SELECT People.FullName
FROM Application.People
WHERE People.PersonID = Invoices.SalespersonPersonID
) AS SalesPersonName,
SalesTotals.TotalSumm AS TotalSummByInvoice,
(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
FROM Sales.OrderLines
WHERE OrderLines.OrderId = (SELECT Orders.OrderId
FROM Sales.Orders
WHERE Orders.PickingCompletedWhen IS NOT NULL
AND Orders.OrderId = Invoices.OrderId)
) AS TotalSummForPickedItems
FROM Sales.Invoices
JOIN
(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
FROM Sales.InvoiceLines
GROUP BY InvoiceId
HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

Запрос выбводит поля Invoices.InvoiceID, Invoices.InvoiceDate,
 делает выборку полного имени из таблицы Application.People, подсчитывает сумму 
Invoice где товары не равны нулю и общаю сумма выбранных единиц больше 27000 отсортированных
по убыванию. 
