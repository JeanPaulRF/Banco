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
	ID int IDENTITY(1,1),
	NumeroCuenta varchar(32) not null,   
	Saldo money not null,
	FechaConstitucion date not null,
	ValorDocumentoIdentidadCliente int not null,
	TipoCuenta int not null,
	
	CONSTRAINT pk_CuentaAhorro PRIMARY KEY (ID)
);

CREATE TABLE TipoCuentaAhorro(
	ID int not null,
	Nombre varchar(32) not null,
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
	Nombre varchar(64) not null,
	ValorDocumentoIdentidad varchar(32) not null,
	TipoIdentidad int not null,
	FechaDeNacimiento date not null,
	Email TCorreo not null,
	Telefono1 int not null,
	Telefono2 int not null,
	
	CONSTRAINT pk_Persona PRIMARY KEY (ID)
);

CREATE TABLE Beneficiario(
	ID int IDENTITY(1,1),
	Porcentaje int not null,
	IdentidadCliente int not null,
	ValorParentesco int not null,
	
	CONSTRAINT pk_Beneficiario PRIMARY KEY (ID)
);

CREATE TABLE Usuario(
	ID int IDENTITY(1,1),
	Nombre varchar(20) not null,
	Contrasena varchar(20) not null,
	Administrador bit not null,
	
	CONSTRAINT pk_Usuario PRIMARY KEY (ID)
);

-- FKs
-- Persona-TipoIdentidad
ALTER TABLE Persona 
	ADD CONSTRAINT fk_Persona_TipoIdentidad FOREIGN KEY (TipoIdentidad) 
	REFERENCES TipoIdentidad (ID);

-- Beneficiario-Persona
ALTER TABLE Beneficiario 
	ADD CONSTRAINT fk_Beneficiario_Persona FOREIGN KEY (IdentidadCliente) 
	REFERENCES Persona (ID);

-- CuentaAhorro-Persona
ALTER TABLE CuentaAhorro 
	ADD CONSTRAINT fk_CuentaAhorro_Persona FOREIGN KEY (ValorDocumentoIdentidadCliente) 
	REFERENCES Persona (ID);

-- CuentaAhorro-TipoCuentaAhorro
ALTER TABLE CuentaAhorro 
	ADD CONSTRAINT fk_CuentaAhorro_TipoCuentaAhorro FOREIGN KEY (ValorDocumentoIdentidadCliente) 
	REFERENCES TipoCuentaAhorro (ID);

-- Beneficiario-Parentesco
ALTER TABLE Beneficiario 
	ADD CONSTRAINT fk_CuentaAhorro_Beneficiario FOREIGN KEY (ValorParentesco) 
	REFERENCES Parentesco (ID);
