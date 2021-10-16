USE [Banco]
GO

CREATE TABLE dbo.TipoCambio(
	ID int not null,
	Fecha date not null,
	CompraTC money not null,
	VentaTC money not null,
	IdMoneda int not null,

	CONSTRAINT pk_TipoCambio PRIMARY KEY (ID)
);


ALTER TABLE [dbo].[Moneda] ADD IdTipoCambioFinal int not null;


CREATE TABLE dbo.TipoMovimientoCA(
	ID int not null,
	Nombre varchar(64) not null,

	CONSTRAINT pk_TipoMovimientoCA PRIMARY KEY (ID)
);


CREATE TABLE dbo.MovimientoCA(
	ID int not null,
	Fecha date not null,
	Monto money not null,
	NuevoSaldo money not null,
	IdCuentaAhorro int not null,
	IdTipoMovimientoCA int not null,

	CONSTRAINT pk_MovimientoCuentaAhorro PRIMARY KEY (ID)
);


CREATE TABLE dbo.EstadoCuenta(
	ID int not null,
	FechaInicio date not null,
	FechaFin date not null,
	SaldoInicial money not null,
	SaldoFinal money not null,

	CONSTRAINT pk_EstadoCuenta PRIMARY KEY (ID)
);


CREATE TABLE dbo.CuentaObjetivo(
	ID int not null,
	FechaInicio date not null,
	FechaFin date not null,
	Costo money not null,
	Objetivo varchar(64),
	Saldo money  not null,
	InteresAcumulado int not null

	CONSTRAINT pk_CuentaObjetivo PRIMARY KEY (ID)
);