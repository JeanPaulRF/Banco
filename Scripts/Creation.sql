--BASE DE DATOS
CREATE DATABASE Banco
GO
use Banco
GO

--TABLAS
--Catalogo
CREATE TABLE dbo.TipoIdentidad(
	ID int not null,
	Nombre varchar(32) not null,
	
	CONSTRAINT pk_TipoIdentidad PRIMARY KEY (ID)
);

CREATE TABLE dbo.Parentesco(
	ID int not null,
	Nombre varchar(64) not null,
	
	CONSTRAINT pk_Parentesco PRIMARY KEY (ID)
);

CREATE TABLE dbo.TipoCuentaAhorro(
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

CREATE TABLE dbo.Moneda(
	ID int not null,
	Nombre varchar(16) not null,

	CONSTRAINT pk_Moneda PRIMARY KEY (ID)
);


--No Catalogodbo.
CREATE TABLE dbo.Persona(
	ID int IDENTITY(1,1),
	Nombre varchar(64) not null,
	ValorDocumentoIdentidad varchar(32) not null,
	TipoIdentidad int not null,
	FechaDeNacimiento date not null,
	Email varchar(32) not null,
	Telefono1 int not null,
	Telefono2 int not null,
	
	CONSTRAINT pk_Persona PRIMARY KEY (ID),
);

CREATE TABLE dbo.CuentaAhorro(
	ID int IDENTITY(1,1),
	IDCliente int not null,
	NumeroCuenta varchar(32) not null,   
	Saldo money not null,
	FechaConstitucion date not null,
	ValorDocumentoIdentidadCliente varchar(32) not null,
	TipoCuenta int not null,
	
	CONSTRAINT pk_CuentaAhorro PRIMARY KEY (ID)
);

CREATE TABLE dbo.Beneficiario(
	ID int IDENTITY(1,1),
	IDCliente int not null,
	IDCuenta int not null,
	NumeroCuenta varchar(32) not null,
	Porcentaje int not null,
	ValorDocumentoIdentidadBeneficiario varchar(32) not null,
	ValorParentesco int not null,

	CONSTRAINT pk_Beneficiario PRIMARY KEY (ID)
);

CREATE TABLE dbo.Usuario(
	ID int IDENTITY(1,1),
	Nombre varchar(16) not null,
	Contrasena varchar(32) not null,
	Administrador bit not null,
	
	CONSTRAINT pk_Usuario PRIMARY KEY (ID)
);

CREATE TABLE dbo.UsuarioPuedeVer(
	ID int IDENTITY(1,1),
	IDCuenta int not null,
	IDUsuario int not null,
	Nombre varchar(16) not null,
	NumeroCuenta varchar(32) not null,
	
	CONSTRAINT pk_UsuarioPuedeVer PRIMARY KEY (ID)
);


-- FKs
--TipoCuentaAhorro-Moneda
ALTER TABLE dbo.TipoCuentaAhorro 
	ADD CONSTRAINT fk_TipoCuentaAhorro_Moneda FOREIGN KEY (IdTipoMoneda) 
	REFERENCES dbo.Moneda (ID);

-- Persona-TipoIdentidad
ALTER TABLE dbo.Persona 
	ADD CONSTRAINT fk_Persona_TipoIdentidad FOREIGN KEY (TipoIdentidad) 
	REFERENCES dbo.TipoIdentidad (ID);

-- CuentaAhorro-TipoCuentaAhorro
ALTER TABLE dbo.CuentaAhorro 
	ADD CONSTRAINT fk_CuentaAhorro_TipoCuentaAhorro FOREIGN KEY (TipoCuenta) 
	REFERENCES dbo.TipoCuentaAhorro (ID);
-- CuentaAhorro-Persona
ALTER TABLE dbo.CuentaAhorro 
	ADD CONSTRAINT fk_CuentaAhorro_Persona FOREIGN KEY (IDCliente) 
	REFERENCES dbo.Persona (ID); 


-- Beneficiario-Persona
ALTER TABLE dbo.Beneficiario 
	ADD CONSTRAINT fk_Beneficiario_Persona FOREIGN KEY (IDCliente) 
	REFERENCES dbo.Persona (ID);
-- Beneficiario-CuentaAhorros
ALTER TABLE dbo.Beneficiario 
	ADD CONSTRAINT fk_Beneficiario_CuentaAhorro FOREIGN KEY (IDCuenta) 
	REFERENCES CuentaAhorro (ID);
-- Beneficiario-Parentesco
ALTER TABLE dbo.Beneficiario 
	ADD CONSTRAINT fk_CuentaAhorro_Beneficiario FOREIGN KEY (ValorParentesco) 
	REFERENCES dbo.Parentesco (ID);


-- UsuarioPuedeVer-Usuario
ALTER TABLE dbo.UsuarioPuedeVer 
	ADD CONSTRAINT fk_UsuarioPuedeVer_Usuario FOREIGN KEY (IDUsuario) 
	REFERENCES dbo.Usuario (ID);
-- UsuarioPuedeVer-CuentaAhorro
ALTER TABLE dbo.UsuarioPuedeVer 
	ADD CONSTRAINT fk_UsuarioPuedeVer_CuentaAhorros FOREIGN KEY (IDCuenta) 
	REFERENCES dbo.CuentaAhorro (ID);