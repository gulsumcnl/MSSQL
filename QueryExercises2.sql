use Northwind
--1.	Tedarikçisinin posta kodu '33007' olan deniz ürünleri 'Seafood' hariç sipariþler ile ilgilenmiþ çalýþanlarýmýn ad, soyad, ev telefonu alanlarýný getir

select distinct
	e.FirstName,
	e.LastName,
	e.HomePhone 
from Suppliers sup
	inner join Products p on sup.SupplierID=p.SupplierID
	inner join Categories cat on p.CategoryID = cat.CategoryID
	inner join [Order Details] od on p.ProductID = od.ProductID
	inner join Orders o on od.OrderID=o.OrderID
	inner join Employees e on o.EmployeeID=e.EmployeeID
where sup.PostalCode='33007' and 
	cat.CategoryName!='Seafood'

--2.	Region'u 'SP' olan müþterilerimin, Federal Shipping ile taþýnan ürünlerini kategorilerine göre sýralanmýþ halini listeleyiniz.

select distinct
 co.CategoryName, p.ProductName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join Shippers shp on shp.ShipperID=o.ShipVia
	join [Order Details] od on o.OrderID = od.OrderID
	join Products p on p.ProductID= od.ProductID
	join Categories co on p.CategoryID=co.CategoryID
where c.Region='SP' and
	shp.CompanyName='Federal Shipping'
order by co.CategoryName asc

--3.	Tedarik þehri Londra olan, kargo þirketinin 4. harfi e olan stoðumda bulunan sipariþlerim nelerdir?

select
o.OrderID
from Orders o
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on p.ProductID=od.ProductID
	join Suppliers sup on sup.SupplierID=p.SupplierID
	join Shippers shp on shp.ShipperID=o.ShipVia
where
	sup.City='London' and
	shp.CompanyName like '___e%'and
	p.UnitsInStock>0
	
--4.	Stoðumdaki miktar 0-20 arasýnda ise %20 zam 20-40 arasýnda ise ayný fiyat 40-90 arasýnda ise yüzde 10 indirim 90 üzerinde ise yüzde 40 indirim yapsýn

select ProductName, UnitPrice,
	(
	case 
	when (UnitsInStock between 0 and 20) then (UnitPrice*1.2)
	when (UnitsInStock between 40 and 90) then (UnitPrice*0.9)
	when (UnitsInStock>90) then (UnitPrice*0.6)
	else UnitPrice
	end
	) Fiyat
from Products

--5.	Stokta bulunan indirimsiz ürünleri adetleriyle birlikte listeleyiniz.

select distinct
p.ProductID , p.UnitsInStock , od.Discount
from Products p
	join [Order Details] od on od.ProductID=p.ProductID
where p.UnitsInStock>0 and
	od.Discount=0
order by p.ProductID

--6.	Þehri Tacoma olan çalýþanlarýmýn aldýðý sipariþlerin listesi?

select
o.OrderID
from Orders o
	join Employees e on e.EmployeeID=o.EmployeeID
where e.City='Tacoma'
order by o.OrderID

--7.	Stoðu 20den fazla olan sipariþlerimin hangi kargo þirketleriyle teslim edildiðini listeleyiniz

select distinct
o.OrderID , shp.CompanyName
from Orders o
	join [Order Details] od on od.OrderID=o.OrderID
	join Products p on p.ProductID=od.ProductID
	join Shippers shp on shp.ShipperID=o.ShipVia
where p.UnitsInStock>20
order by o.OrderID

--8.	Stokta 40tan fazla olan ürünlerimin adlarý ve kategori isimleri?

select 
p.ProductName, c.CategoryName
from Products p
	left join Categories c on p.CategoryID = c.CategoryID
where p.UnitsInStock>40

--9.	Stokta olmayan ürünlerimin ve devamlýlýðý olmayanlarýn tedarikçilerinin telefon numaralarýný listeleyiniz

select
p.ProductID, sup.Phone
from Products p
	join Suppliers sup on sup.SupplierID=p.SupplierID
where p.UnitsInStock=0 and
	p.Discontinued=1

--10.   Taþýnan sipariþlerin hangi kargo firmasý ile taþýndýðýný kargo firmasýnýn ismi ile belirtiniz.

select
o.OrderID , shp.CompanyName
from Orders o
	join Shippers shp on shp.ShipperID=o.ShipVia
where o.ShippedDate is not null

--11.   Hiç satýþ yapýlmamýþ müþterilerin isimlerini ve telefonlarýný listeleyiniz.

select
	c.CompanyName,c.Phone
from Customers c
	left join Orders o on c.CustomerID=o.CustomerID
where o.CustomerID is null
	
--12.   Ýndirimli gönderdiðim sipariþlerdeki ürün adlarýný, birim fiyatýný ve indirim tutarýný gösterin

select
	p.ProductName , p.UnitPrice , od.Discount
from [Order Details] od
	join Products p on od.ProductID=p.ProductID
where od.Discount!=0 

--13.   Amerikali toptancilardan alinmis olan urunleri gosteriniz...

select
	p.ProductName
from Products p 
	join Suppliers sup on p.SupplierID=sup.SupplierID
where sup.Country = 'USA'
order by p.ProductName

--14.   Speedy Express ile tasinmis olan siparisleri gosteriniz...

select
	o.OrderID
from Orders o
	join Shippers s on o.ShipVia=s.ShipperID
where s.CompanyName='Speedy Express'

--15.   Federal Shipping ile tasinmis ve Nancy'nin almis oldugu siparisleri gosteriniz...

select
	*
from Orders o
	join Shippers s on o.ShipVia=s.ShipperID
	join Employees e on o.EmployeeID= e.EmployeeID
where s.CompanyName='Federal Shipping' and
	e.FirstName like '%Nancy%'
	
--16.   Web sayfasý olan tedarikçilerimden hangi ürünleri tedarik ediyorum?

select
	p.ProductName
from Products p
	join Suppliers s on p.SupplierID=s.SupplierID
where s.HomePage is not null
order by p.ProductName

--17.   Hangi çalýþaným hangi çalýþanýma rapor veriyor? 

select 
	calisan.FirstName Calisan, 
	mudur.FirstName Mudur 
from Employees calisan
	left join Employees mudur on calisan.ReportsTo=mudur.EmployeeID

--18.   Doðu konumundaki bölgeleri listeleyin

select
	t.TerritoryID , t.TerritoryDescription
from Territories t
	join Region r on t.RegionID=r.RegionID
where r.RegionDescription like '%East%'

--20.   Konumu 'Eastern' olan müþterilerimin, federal shipping ile taþýnan ürünlerini
--kategorilere göre sýralayýnýz.

select distinct
	 c.CategoryID, c.CategoryName, p.ProductID, p.ProductName
from Products p
	join [Order Details] od on p.ProductID=od.ProductID
	join Orders o on od.OrderID=o.OrderID
	join Shippers sh on o.ShipVia=sh.ShipperID
	join Employees e on o.EmployeeID=e.EmployeeID
	join EmployeeTerritories et on e.EmployeeID=et.EmployeeID
	join Territories t on et.TerritoryID=t.TerritoryID
	join Region r on t.RegionID=r.RegionID
	join Categories c on p.CategoryID=c.CategoryID
where sh.CompanyName='Federal shipping' and
	r.RegionDescription='Eastern'
order by c.CategoryID
	
--21.   Tedarik þehri londra olan, kargo þirketinin  4. harfi e olan stoðumda bulunan ve birim fiyatý 10 - 30 arasýnda olan sipariþlerim nelerdir? 

select
	o.OrderID 
from Orders o
	inner join Shippers sp on o.ShipVia=sp.ShipperID
	inner join [Order Details] od on od.OrderID=o.OrderID
	inner join Products p on p.ProductID = od.ProductID
	inner join Suppliers su on su.SupplierID=p.SupplierID
where su.City='London' and
	sp.CompanyName like '___e%' and
	p.UnitsInStock>0 and
	p.UnitPrice between 10 and 30

--22.   Þehri tacoma olan çalýþanlarýmýn aldýðý sipariþlerin listesi?

select
	o.OrderID
from Orders o
	join Employees e on o.EmployeeID=e.EmployeeID
where e.City like '%Tacoma%'

--23.   Satýþý durdurulmuþ ve ayný zamanda stoðu kalmamýþ ürünlerimin tedarikçilerinin isimlerini ve telefon numaralarýný listeleyiniz.

select 
	s.CompanyName, s.Phone, p.ProductName
from Suppliers s
	join Products p on s.SupplierID=p.SupplierID
where p.Discontinued=1 and
	p.UnitsInStock=0

--24.   New York þehrinden sorumlu çalýþan(lar)ým kim?

select distinct
	e.FirstName+' '+e.LastName Employee
from Employees e
	join EmployeeTerritories et on e.EmployeeID=et.EmployeeID
	join Territories t on et.TerritoryID = t.TerritoryID
where t.TerritoryDescription= 'New York'

--25.   1 Ocak 1998 tarihinden sonra sipariþ veren müþterilerimin isimlerini artan olarak sýralayýnýz.

select distinct
	c.CompanyName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
where o.OrderDate>'1998-01-01'
order by c.CompanyName asc

--26.	CHAI ürününü hangi müþterilere satmýþým?

select distinct
	c.CompanyName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
where p.ProductName like 'chai'

--27.	10248 ID'li sipariþimle hangi çalýþaným ilgilenmiþtir?

select
	e.FirstName+' '+e.LastName
from Employees e
	join Orders o on e.EmployeeID=o.EmployeeID
where o.OrderID=10248

--28.   Þiþede satýlan ürünlerimi sipariþ ile gönderdiðim ülkeler hangileridir?

select distinct
	o.ShipCountry
from Orders o
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
where p.QuantityPerUnit like '%bottle%' 


--29.	Aðustos ayýnda teslim edilen sipariþlerimdeki ürünlerden kategorisi içecekler olanlarýn,
--ürün isimlerini, teslim tarihini ve hangi þehre teslim edildiðini kargo ücretine göre ters sýralý þekilde listeleyiniz.

select
	p.ProductName, o.ShippedDate, o.ShipCity
from Orders o
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	join Categories c on p.CategoryID=c.CategoryID
where c.CategoryName='Beverages' and
	format(o.ShippedDate,'MMMM')='august'
order by o.Freight desc

--30.	Speedy Express ile taþýnan tedarikçilerimden pazarlama müdürleriyle iletiþime geçtiðim,
--Steven Buchanan adlý çalýþanýma rapor veren çalýþanlarýmýn ilgilendiði,
--Amerika'ya gönderdiðim sipariþlerimin ürünlerinin kategorileri nelerdir?

select 
		cat.CategoryName
from Employees Calisan
	inner join Employees Mudur on calisan.ReportsTo=Mudur.EmployeeID
	join Orders o on o.EmployeeID=Calisan.EmployeeID
	join Shippers s on s.ShipperID=o.ShipVia
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on p.ProductID=od.ProductID
	join Suppliers su on su.SupplierID=p.SupplierID
	join Categories cat on p.CategoryID=cat.CategoryID
where 
	mudur.FirstName='Steven' and
	mudur.LastName='Buchanan' and
	s.CompanyName='Speedy Express' and
	su.ContactTitle='Marketing Manager' and
	o.ShipCountry='USA'
	

--31.	Meksikalý müþterilerimden þirket sahibi ile iletiþime geçtiðim,
--kargo ücreti 30 dolarýn altýnda olan sipariþlerle hangi çalýþanlarým ilgilenmiþtir?

select distinct
	e.EmployeeID, e.FirstName+' '+e.LastName
from Orders o
	join Customers c on o.CustomerID=c.CustomerID
	join Employees e on o.EmployeeID=e.EmployeeID
where c.Country='Mexico' and
	c.ContactTitle='Owner' and
	o.Freight<30
order by e.EmployeeID

--32.	Seafood ürünlerinden sipariþ gönderdiðim müþterilerim kimlerdir?

select distinct
	c.CompanyName
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	join Categories cat on p.CategoryID=cat.CategoryID
where cat.CategoryName='SeaFood'

--33.	Doktora yapmamýþ kadýn çalýþanlarýmýn ilgilendiði sipariþlerin,
--gönderildiði müþterilerimden iletiþime geçtiðim kiþilerin isimleri ve þehirleri nelerdir?

select distinct
c.ContactName,c.City 
from Employees e
	join Orders o on e.EmployeeID=o.EmployeeID
	join Customers c on c.CustomerID=o.CustomerID
where e.TitleOfCourtesy in ('Ms.','Mrs.') and
	e.TitleOfCourtesy!='Dr.'
	
--------------Union - Union All
--34.	Hangi þirketlerle çalýþýyorum => hem suppliers hem customers hem de shippers

select s.CompanyName from Suppliers s
union
select c.CompanyName from Customers c
union
select sh.CompanyName from Shippers sh

--35.	Hangi insanlarla çalýþýyorum => hem customers hem suppliers hem Employees

select c.ContactName from Customers c
union
select e.FirstName+' '+e.LastName from Employees e

--------------Case-When
--36.	içecekler kategorisinden sipariþ veren müþterilerimin ürün adý þirket isimlerini 
--tedarikçi þirket ismini kargo ücretini ve eðer kargo ücreti 20 den az ise 'ucuz',
--20-40 aralýðýnda ise 'orta', 40 dan büyük ise 'pahalý' yazacak þekilde listeleyiniz. 
--(kolon isimleri müþteri þirketi, ürün adý, tedarikçinin þirketi, kargo ücreti, ücret deðerlendirmesi)	

select
	c.CompanyName [Müþteri Þirketi],
	p.ProductName [Ürün Adý],
	sup.CompanyName [Tedarikçinin Þirketi],
	o.Freight [Kargo Ücreti],
	(
	case 
	when (o.Freight <= 20) then 'Ucuz'
	when (o.Freight between 20 and 40) then 'Orta'
	when (o.Freight>40) then 'Pahalý'
	end
	) [Ücret Deðerlendirmesi]
from Customers c
	join Orders o on c.CustomerID=o.CustomerID
	join [Order Details] od on o.OrderID=od.OrderID
	join Products p on od.ProductID=p.ProductID
	join Categories cat on p.CategoryID=cat.CategoryID
	join Suppliers sup on p.SupplierID=sup.SupplierID
where cat.CategoryName='Beverages'
order by c.CompanyName