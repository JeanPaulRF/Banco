USE [Banco]
GO

DECLARE @xmlData XML

DECLARE @CurrentTime DATETIME=GETDATE();

SET @xmlData = 
		(SELECT *
		FROM OPENROWSET(BULK 'C:\Archivos\DatosNoCatalogo.xml', SINGLE_BLOB) 
		AS xmlData);

DELETE [dbo].[Persona]
INSERT INTO [dbo].[Persona](
	[TipoIdentidad],
	[Nombre],
	[ValorDocumentoIdentidad],
	[FechaDeNacimiento],
	[Email],
	[Telefono1],
	[Telefono2])
SELECT 
	T.Item.value('@TipoDocuIdentidad','INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)'),
	T.Item.value('@ValorDocumentoIdentidad', 'VARCHAR(32)'),
	T.Item.value('@FechaNacimiento','DATE'),
	T.Item.value('@Email','VARCHAR(64)'),
	T.Item.value('@telefono1','VARCHAR(16)'),
	T.Item.value('@telefono2','VARCHAR(16)')
FROM @xmlData.nodes('Personas/Persona') as T(Item)

DELETE [dbo].[Usuario]
INSERT INTO [dbo].[Usuario](
	[Nombre],
	[Contrasena],
	[Administrador])
SELECT 
	T.Item.value('@User', 'VARCHAR(16)'),
	T.Item.value('@Pass', 'VARCHAR(32)'),
	T.Item.value('@EsAdministrador', 'BIT')
FROM @xmlData.nodes('Usuarios/Usuario') as T(Item)


DECLARE @TempCuentas TABLE
	(Saldo money,
	Fecha date,
	TipoCuenta INT,
	IdentidadCliente VARCHAR(32),  -- Valor DocumentoId del duenno de la cuenta
	NumeroCuenta VARCHAR(32))

DELETE @TempCuentas
INSERT INTO @TempCuentas(
	NumeroCuenta,
	Saldo,
	Fecha,
	IdentidadCliente,
	TipoCuenta
	)
SELECT T.Item.value('@NumeroCuenta','VARCHAR(32)'),
	T.Item.value('@Saldo','MONEY'),
	T.Item.value('@FechaCreacion','DATE'),
	T.Item.value('@ValorDocumentoIdentidadDelCliente','VARCHAR(32)'),
	T.Item.value('@TipoCuentaId','INT')
FROM @xmlData.nodes('Cuentas/Cuenta') as T(Item)

-- Mapeo @TempCuentas-CuentaAhorro
DELETE [dbo].[CuentaAhorro]
INSERT INTO [dbo].[CuentaAhorro](
	[IdentificacionCliente], 
	[NumeroCuenta], 
	[Saldo], 
	[FechaConstitucion],
	[ValorDocumentoIdentidadCliente],
	[TipoCuenta]
	)
SELECT P.IdPersona,
	C.NumeroCuenta,
	C.Saldo,
	C.Fecha,
	P.ValorDocumentoIdentidad,
	C.TipoCuenta
FROM @TempCuentas C, [dbo].[Persona] P 
WHERE C.IdentidadCliente=P.[ValorDocumentoIdentidad]


DECLARE @TempBeneficiario TABLE
	(NumeroCuenta varchar(32),
	ValorDocumentoIdentidadBeneficiario varchar(32),
	ParentezcoId INT,
	Porcentaje int)

INSERT INTO @TempBeneficiario(
	NumeroCuenta,
	ValorDocumentoIdentidadBeneficiario,
	ParentezcoId,
	Porcentaje
	)
SELECT T.Item.value('@NumeroCuenta','VARCHAR(32)'),
	T.Item.value('@ValorDocumentoIdentidadBeneficiario','VARCHAR(32)'),
	T.Item.value('@ParentezcoId','INT'),
	T.Item.value('@Porcentaje','INT')
FROM @xmlData.nodes('Beneficiarios/Beneficiario') as T(Item)


-- Mapeo @@TempBeneficiario-Beneficiario
INSERT INTO [dbo].[Beneficiario](
	[IdentificacionCliente], 
	[IdentificacionCuenta], 
	[NumeroCuenta], 
	[Porcentaje],
	[ValorDocumentoIdentidadBeneficiario],
	[ValorParentesco]
	)
SELECT C.IdentificacionCliente,
	C.IdCuentaAhorro,
	C.NumeroCuenta,
	B.Porcentaje,
	B.ValorDocumentoIdentidadBeneficiario,
	B.ParentezcoId
FROM @TempBeneficiario B, [dbo].[CuentaAhorro] C
WHERE C.NumeroCuenta=B.NumeroCuenta

DECLARE @TempUsuario TABLE
	(Usuario varchar(16),
	NumeroCuenta varchar(32))

INSERT INTO @TempUsuario(
	Usuario,
	NumeroCuenta
	)
SELECT T.Item.value('@User','VARCHAR(16)'),
	T.Item.value('@NumeroCuenta','VARCHAR(32)')
FROM @xmlData.nodes('Usuarios_Ver/UsuarioPuedeVer') as T(Item)

-- Mapeo @TempUsuario-UsuarioPuedeVer
INSERT INTO [dbo].[UsuarioPuedeVer](
	[IdentificacionCuenta],
	[IdentificacionUsuario],
	[Nombre],
	[NumeroCuenta]
	)
SELECT C.IdCuentaAhorro,
	A.IdUsuario,
	A.Nombre,
	C.NumeroCuenta
FROM @TempUsuario U, [dbo].[Usuario] A, [dbo].[CuentaAhorro] C
WHERE A.Nombre=U.Usuario AND U.NumeroCuenta=C.NumeroCuenta 