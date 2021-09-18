--BASE DE DATOS
CREATE DATABASE Banco
GO
use Banco
GO

--TABLAS
--Catalogo
CREATE TABLE dbo.TipoIdentidad(
	IdTipoIdentidad int not null,
	Nombre varchar(32) not null,
	
	CONSTRAINT pk_TipoIdentidad PRIMARY KEY (IdTipoIdentidad)
);

CREATE TABLE dbo.Parentesco(
	IdParentesco int not null,
	Nombre varchar(64) not null,
	
	CONSTRAINT pk_Parentesco PRIMARY KEY (IdParentesco)
);

CREATE TABLE dbo.TipoCuentaAhorro(
	IdTipoCuentaAhorro int not null,
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
	
	CONSTRAINT pk_TipoCuentaAhorro PRIMARY KEY (IdTipoCuentaAhorro)
);

CREATE TABLE dbo.Moneda(
	IdMoneda int not null,
	Nombre varchar(16) not null,

	CONSTRAINT pk_Moneda PRIMARY KEY (IdMoneda)
);


--No Catalogodbo.
CREATE TABLE dbo.Persona(
	IdPersona int IDENTITY(1,1),
	Nombre varchar(64) not null,
	ValorDocumentoIdentidad varchar(32) not null,
	TipoIdentidad int not null,
	FechaDeNacimiento varchar(32) not null,
	Email varchar(32) not null,
	Telefono1 int not null,
	Telefono2 int not null,
	
	CONSTRAINT pk_Persona PRIMARY KEY (IdPersona),
);

CREATE TABLE dbo.CuentaAhorro(
	IdCuentaAhorro int IDENTITY(1,1),
	IdentificacionCliente int not null,
	NumeroCuenta varchar(32) not null,   
	Saldo money not null,
	FechaConstitucion varchar(32) not null,
	ValorDocumentoIdentidadCliente varchar(32) not null,
	TipoCuenta int not null,
	
	CONSTRAINT pk_CuentaAhorro PRIMARY KEY (IdCuentaAhorro)
);

CREATE TABLE dbo.Beneficiario(
	IdBeneficiario int IDENTITY(1,1),
	IdentificacionCliente int not null,
	IdentificacionCuenta int not null,
	NumeroCuenta varchar(32) not null,
	Porcentaje int not null,
	ValorDocumentoIdentidadBeneficiario varchar(32) not null,
	ValorParentesco int not null,
	Activo bit DEFAULT (1),
	FechaDesactivacion varchar(32),

	CONSTRAINT pk_Beneficiario PRIMARY KEY (IdBeneficiario)
);

--alter table beneficiario add Activo bit DEFAULT (1)
--alter table beneficiario add FechaDesactivacion date

CREATE TABLE dbo.Usuario(
	IdUsuario int IDENTITY(1,1),
	Nombre varchar(16) not null,
	ValorDocumentoIdentidad varchar(32) not null,
	Contrasena varchar(32) not null,
	Administrador bit not null,
	
	CONSTRAINT pk_Usuario PRIMARY KEY (IdUsuario)
);

CREATE TABLE dbo.UsuarioPuedeVer(
	IdUsuarioPuedeVer int IDENTITY(1,1),
	IdentificacionCuenta int not null,
	IdentificacionUsuario int not null,
	Nombre varchar(16) not null,
	NumeroCuenta varchar(32) not null,
	
	CONSTRAINT pk_UsuarioPuedeVer PRIMARY KEY (IdUsuarioPuedeVer)
);

-- FKs
--TipoCuentaAhorro-Moneda
ALTER TABLE dbo.TipoCuentaAhorro 
	ADD CONSTRAINT fk_TipoCuentaAhorro_Moneda FOREIGN KEY (IdTipoMoneda) 
	REFERENCES dbo.Moneda (IdMoneda);

-- Persona-TipoIdentidad
ALTER TABLE dbo.Persona 
	ADD CONSTRAINT fk_Persona_TipoIdentidad FOREIGN KEY (TipoIdentidad) 
	REFERENCES dbo.TipoIdentidad (IdTipoIdentidad);

-- CuentaAhorro-TipoCuentaAhorro
ALTER TABLE dbo.CuentaAhorro 
	ADD CONSTRAINT fk_CuentaAhorro_TipoCuentaAhorro FOREIGN KEY (TipoCuenta) 
	REFERENCES dbo.TipoCuentaAhorro (IdTipoCuentaAhorro);
-- CuentaAhorro-Persona
ALTER TABLE dbo.CuentaAhorro 
	ADD CONSTRAINT fk_CuentaAhorro_Persona FOREIGN KEY (IdentificacionCliente) 
	REFERENCES dbo.Persona (IdPersona); 


-- Beneficiario-Persona
ALTER TABLE dbo.Beneficiario 
	ADD CONSTRAINT fk_Beneficiario_Persona FOREIGN KEY (IdentificacionCliente) 
	REFERENCES dbo.Persona (IdPersona);
-- Beneficiario-CuentaAhorros
ALTER TABLE dbo.Beneficiario 
	ADD CONSTRAINT fk_Beneficiario_CuentaAhorro FOREIGN KEY (IdentificacionCuenta) 
	REFERENCES CuentaAhorro (IdCuentaAhorro);
-- Beneficiario-Parentesco
ALTER TABLE dbo.Beneficiario 
	ADD CONSTRAINT fk_CuentaAhorro_Beneficiario FOREIGN KEY (ValorParentesco) 
	REFERENCES dbo.Parentesco (IdParentesco);


-- UsuarioPuedeVer-Usuario
ALTER TABLE dbo.UsuarioPuedeVer 
	ADD CONSTRAINT fk_UsuarioPuedeVer_Usuario FOREIGN KEY (IdentificacionUsuario) 
	REFERENCES dbo.Usuario (IdUsuario);
-- UsuarioPuedeVer-CuentaAhorro
ALTER TABLE dbo.UsuarioPuedeVer 
	ADD CONSTRAINT fk_UsuarioPuedeVer_CuentaAhorros FOREIGN KEY (IdentificacionCuenta) 
	REFERENCES dbo.CuentaAhorro (IdCuentaAhorro);