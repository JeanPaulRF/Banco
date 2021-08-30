--BASE DE DATOS
CREATE DATABASE Banco
GO
use Banco
GO

-- TIPOS DE DATOS
CREATE RULE RCorreo AS (@correo like ('[a-Z]%@[a-Z]%.[a-Z]%'))
GO
EXEC sp_addtype 'TCorreo','varchar(50)','not null'
GO
EXEC sp_bindrule 'RCorreo','TCorreo'

GO

--TABLAS
CREATE TABLE TipoIdentidad(
	ID int not null,
	Nombre varchar(32) not null,
	
	CONSTRAINT pk_TipoIdentidad PRIMARY KEY (ID)
);

CREATE TABLE Parentesco(
	ID int not null,
	Nombre varchar(64) not null,
	
	CONSTRAINT pk_Parentesco PRIMARY KEY (ID)
);

CREATE TABLE CuentaAhorro(
	ID int not null,
	Saldo money not null,
	FechaConstitucion date not null,
	
	CONSTRAINT pk_CuentaAhorro PRIMARY KEY (ID)
);

CREATE TABLE TipoCuentaAhorro(
	ID int IDENTITY(1,1),
	Nombre varchar(20) not null,
	IdTipoMoneda int not null,
	SaldoMinimo money not null,
	MultaSaldoMin money not null,
	CargoAnual int not null,
	NumRetirosHumanos int not null,
	NumRetirosAutomaticos int not null,
	ComisionHumano int not null,
	ComisionAutomatico int not null,
	Interes int not null,
	
	CONSTRAINT pk_TipoCuentaAhorro PRIMARY KEY (ID)
);

CREATE TABLE Persona(
	ID int IDENTITY(1,1),
	Nombre varchar(40) not null,
	ValorDeIdentidad int not null,
	FechaDeNacimiento date not null,
	Email TCorreo not null,
	Telefono1 int not null,
	Telefono2 int not null,
	
	CONSTRAINT pk_Persona PRIMARY KEY (ID)
);

CREATE TABLE Beneficiario(
	ID int IDENTITY(1,1),
	Porcentaje int not null,
	
	CONSTRAINT pk_Beneficiario PRIMARY KEY (ID)
);

-- FKs
-- Direccion-Distrito
--ALTER TABLE Persona 
--ADD CONSTRAINT fk_TipoIdentidad
--FOREIGN KEY (ID) 
--REFERENCES TipoIdentidad (ID)