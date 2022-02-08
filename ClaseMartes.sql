create database CV

restore database CV from disk='D:\CV.bak' with replace

use CV

select * from Clientes

-- Ejemplo 1: Muestra el primer registro de la tabla Clientes
DECLARE listac CURSOR  
    FOR SELECT * FROM Clientes  
OPEN listac 
FETCH NEXT FROM listac 

-- Ejemplo 2:
SET NOCOUNT ON 
  
DECLARE @IDC INT, @PN NVARCHAR(15), @PA nvarchar(15),  
    @DirC nVARCHAR(70), @TelC CHAR(8) 
  
PRINT '-------- Listado de Clientes --------';  
  
DECLARE Clientes_cursor CURSOR FOR   
SELECT Id_Cliente, PN, PA, DirC, TelC  
FROM Clientes  
  
OPEN Clientes_cursor  
  
FETCH NEXT FROM Clientes_cursor   
INTO @IDC, @PN, @PA,@DirC,@TelC  
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
    PRINT ' '  
    SELECT PN,PA,DirC,TelC from CLientes 
    
        -- Get the next vendor.  
    FETCH NEXT FROM Clientes_cursor   
    INTO @IDC, @PN, @PA, @DirC, @TelC  
END   
CLOSE Clientes_cursor;  
DEALLOCATE Clientes_cursor; 

-- Verificar informacion de compras
select * from Compras

-- Crear un procedimiento almacenado para la compra
create procedure NCompra
@IDC char(6),
@FC date,
@IDP char(5),
@TC float
as
declare @IdCo as Char(6)
set @IdCo=(select Id_Compra from Compras where Id_Compra=@IDC)
declare @IdProv as char(5)
set @IdProv=(select Id_Prov from Proveedor where Id_Prov=@IDP)
if(@IDC=@IdCo)
begin
  print 'Compra ya registrada'
end
else
begin
  if(@IDC='')
  begin
    print 'El Id Compra no puede ser nulo'
  end
  else
  begin
    if(@IDP='')
	begin
	  print 'El Id Prov no puede ser nulo'
	end
	else
	begin
	  if(@IDP=@IdProv)
	  begin
	    if(@FC is null)
		begin
		  print 'La fecha de compra no puede ser nula'
		end
		else
		begin
		  if(@TC>0)
		  begin
		    insert into Compras values(@IDC,@FC,@IDP,@TC)
		  end
		  else
		  begin
		    print 'El total de la compra no puede ser - ni 0'
		  end
		end
	  end
	  else
	  begin
	    print 'Proveedor no registrado'
	  end
	end
  end
end



-- Ejercicio 1: Actualizar Precio del Producto siempre
-- y cuando el precio de compra sea mayor o igual al precio
-- del producto
create procedure APP
as
SET NOCOUNT ON 


DECLARE @IDCo Char(6),@CodP char(5), @PC float

declare @p as float
set @p=(select precio from Productos where CodProd=@CodP)

DECLARE ActPP_cursor CURSOR FOR   
SELECT Id_Compra,CodProd, pc 
FROM DetCompras 
  
OPEN ActPP_cursor  
  
FETCH NEXT FROM ActPP_cursor   
INTO @IDCo,@CodP,@PC 
  
WHILE @@FETCH_STATUS = 0  
BEGIN  
    if(@PC>=@p)
	begin
	  update Productos set precio=@PC*1.1 where CodProd=@CodP
	  FETCH NEXT FROM ActPP_cursor   
        INTO @IDCo, @CodP, @PC  
      END   
      CLOSE ActPP_cursor;  
      DEALLOCATE ActPP_cursor; 
	end

	
--Verificar proveedores

select * from Proveedor

NCompra '01','08-02-2022','001',2000

select * from Compras

--Actualizar primer registro
update Compras set Fecha_Compra = '07-02-2022' where Id_Compra = '01'

--verificar el subtotal de compras 
create trigger ActC
on
DetCompras
after insert 
as
 update Productos set exist=exist+(Select cc from inserted)
 from DetCompras dc, Prodcutos p where p.CodProd =dc.CodProd

 --Creacion de procedimiento almacenado     
 create Procedure  DetCN
 @IDC char (6),
 @CP char (5),
 @cc int,
 @pc float
 as
 declare @IdCo as char (6)
 set @IdCo=(select Id_Compra from Compras where Id_Compra=@IDC)
 declare @CodP as char (5)
 set @CodP=(select CodProd from Productos where CodProd=@CP)
 declare @P as float
 set @P=(select  precio from Productos where CodProd=@CP)
 if (@IDC = '  ')
 begin
     print ' El ID compra no puede ser nulo'
 end
 else
 begin
     if (@IDC=@IdCo)
	 begin
	     if (@CP = ' ')
		 begin
		 print 'El codigo del producto no puede ser nulo'
		 end
		 else 
		 begin
		     if(@CP=@CodP)
			  begin
			      if(@cc>0)
				  begin
				     if (@pc>0)
					 begin
					     if(@pc>@p)
						 begin 
						     insert into DetCompras values (@IDC,@CP,@cc,@pc,(@pc*cc))
							 update Productos set precio = @pc*1.1 where CodProd=
							 end
							 else
							 begin
							    insert into Productos values (@IDC, @CP)
							 end
							end
						end
						else



--Tablas Temporales
CREATE TABLE ##Usuarios(
Id_Usuario INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
NombreUsuario NVARCHAR (25) NOT NULL,
Contraseña VARBINARY (8000) NOT NULL
)

INSERT INTO ##Usuarios VALUES ('Evesar', 10101011)

select * from ##Usuarios

--Tabla Temporal Global
create table #Usuarios(
Id_Usuario INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
NombreUsuario NVARCHAR (25) NOT NULL,
Contraseña VARBINARY (8000) NOT NULL
)

insert into #Usuarios values ('evaser')

--Tabla temporal con manejo de sistemas }
CREATE TABLE dbo.Employee   
(    
  [EmployeeID] int NOT NULL PRIMARY KEY CLUSTERED   
  , [Name] nvarchar(100) NOT NULL  
  , [Position] varchar(100) NOT NULL   
  , [Department] varchar(100) NOT NULL  
  , [Address] nvarchar(1024) NOT NULL  
  , [AnnualSalary] decimal (10,2) NOT NULL  
  , [ValidFrom] datetime2 (2) GENERATED ALWAYS AS ROW START  
  , [ValidTo] datetime2 (2) GENERATED ALWAYS AS ROW END  
  , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)  
 )    
 WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));  

 insert into Employee(EmployeeID,Name,Position,Department,Address,
 AnnualSalary) values (1,'Andy Cruz', 'Alumno nuevo',
 'Informatica', 'Managua',1000)

 select * from Employee

 select * from EmplyeeHistory

 update Employee set AnnualSalary= 30000 where EmployeeID=1

 --tabla temporal clientes
 CREATE TABLE dbo.ClientesTemp 
(    
    [ID] int NOT NULL PRIMARY KEY CLUSTERED   
  , [PN] nvarchar(15) NOT NULL  
  , [SN] nvarchar(15) NOT NULL   
  , [PA] nvarchar(15) NOT NULL  
  , [SA] nvarchar(15) NOT NULL  
  , [DirC] nvarchar (70) NOT NULL  
  , [TelC] char (8) NOT NULL 
  , [Id_Depto] int foreign key references Dept(Id_Dpto)
  , [ValidFrom] datetime2 (2) GENERATED ALWAYS AS ROW START  
  , [ValidTo] datetime2 (2) GENERATED ALWAYS AS ROW END  
  , PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo) 
  
 )    
 select * from ClientesTemp





	
    