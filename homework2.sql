1. Все товары, в которых в название есть пометка urgent или название начинается с Animal
select * from warehouse.StockItems where StockItemName like 'Animal%' or StockItemName like '%urgent%';

2. Поставщиков, у которых не было сделано ни одного заказа (потом покажем как это делать через подзапрос, сейчас сделайте через JOIN)
select ps.SupplierID, ppo.SupplierID 
from Purchasing.Suppliers as ps left join Purchasing.PurchaseOrders as ppo
on ps.SupplierID = ppo.SupplierID
where ppo.SupplierID = null;

3. Продажи с названием месяца, в котором была продажа, номером квартала, к которому относится продажа,
включите также к какой трети года относится дата - каждая треть по 4 месяца, дата забора заказа должна быть задана,
с ценой товара более 100$ либо количество единиц товара более 20. Добавьте вариант этого запроса с постраничной
выборкой пропустив первую 1000 и отобразив следующие 100 записей. Соритровка должна быть по номеру квартала, трети года, дате продажи.
select 
    FORMAT(s.OrderDate, 'MMMM'), DATEPART (quarter, s.OrderDate ) as quarter_1,
    CEILING((MONTH(s.OrderDate) * 3) / 12) + 1 as quarter_2, so.UnitPrice, s.OrderID
from sales.orders as s
left join Sales.OrderLines as so on s.OrderID = so.OrderID
where so.UnitPrice > 100  or so.PickedQuantity > 20
order by quarter_1, quarter_2, s.OrderDate
offset 1000 rows fetch next 100 rows only;

4. Заказы поставщикам, которые были исполнены за 2014й год с доставкой Road Freight или Post, добавьте название поставщика, имя контактного лица принимавшего заказ
select ps.SupplierName, ap.FullName
from Purchasing.PurchaseOrders po
left join Application.DeliveryMethods as ad on  po.DeliveryMethodID = ad.DeliveryMethodID
inner join Purchasing.Suppliers as ps on po.SupplierID = ps.SupplierID
inner join Application.People as ap on ap.PersonID = po.ContactPersonID
where po.ExpectedDeliveryDate >= '2014' and po.ExpectedDeliveryDate < '2015'
and DeliveryMethodName = 'Road Freight' or DeliveryMethodName = 'Post';

5. 10 последних по дате продаж с именем клиента и именем сотрудника, который оформил заказ.
select top(10)
    ap.FullName,
    sc.CustomerName
from Sales.Orders as so
left join Application.People as ap on ap.PersonID = so.ContactPersonID 
left join Sales.Customers as sc on sc.CustomerID = so.CustomerID
order by so.OrderDate desc;

6. Все ид и имена клиентов и их контактные телефоны, которые покупали товар Chocolate frogs 250g
select DISTINCT
       ap.PersonID,
       ap.FullName,
       ap.PhoneNumber 
from Sales.Orders as so
left join Sales.OrderLines as sol on so.OrderID = sol.OrderID
left join Application.People as ap on ap.PersonID = so.SalespersonPersonID
left join Warehouse.StockItems as wsi on sol.StockItemID = wsi.StockItemID 
where wsi.StockItemName = 'Chocolate frogs 250g';
