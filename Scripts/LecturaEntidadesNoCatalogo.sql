USE [Banco]
GO

DECLARE @xmlData XML
-- Funciona en una direccion fisica, del archivo que contiene el XML, en la compu donde esta el servidor.
-- Si el servidor esta en la nube, hay una manera de indicar al servidor que busque en una direccion local.
-- Para efectos de pruebas, pueden iniciar asignando el documento XML: Set @xmlData='<DatosPrueba> <TipoDocId>..</TipoDocId>.. </DatosPrueba>'

DECLARE @CurrentTime DATETIME=GETDATE();

SET @xmlData = 
		(SELECT *
		FROM OPENROWSET(BULK 'C:\Users\yeico\Desktop\BDTarea2\XML\Datos.xml', SINGLE_BLOB) 
		AS xmlData);


INSERT INTO [dbo].[Persona](
	[ID],   -- FK a TipoDucumentoIdentidad
	[Nombre],
	[ValorDeIdentidad],
	[FechaDeNacimiento],
	[Email],
	[Telefono1],
	[Telefono2])
SELECT  T.Item.value('@TipoDocuIdentidad','INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)'),
	T.Item.value('@ValorDocumentoIdentidad', 'VARCHAR(32)'),
	T.Item.value('@FechaNacimiento','DATE'),
	T.Item.value('@Email','VARCHAR(64)'),
	T.Item.value('@telefono1','VARCHAR(16)'),
	T.Item.value('@telefono2','VARCHAR(16)')
FROM @xmlData.nodes('Personas/Persona') as T(Item)


DECLARE @TempCuentas TABLE
	(TipoCuenta INT
	, IdentidadCliente VARCHAR(64)  -- Valor DocumentoId del duenno de la cuenta
	, NumeroCuenta VARCHAR(32))

INSERT INTO @TempCuentas(
	TipoCuenta,
	IdentidadCliente,
	NumeroCuenta)
SELECT T.Item.value('@TipoCuentaId','INT'),
	T.Item.value('@ValorDocumentoIdentidadDelCliente','VARCHAR(50)'),
	T.Item.value('@NumeroCuenta','VARCHAR(50)')
FROM @xmlData.nodes('Cuentas/Cuenta') as T(Item)

INSERT [dbo].[CuentaAhorro] ([TipoCuenta], [IdentidadCliente], NumeroCuenta, Saldo)
SELECT  C.TipoCuenta, P.Id, T.NumeroCuenta, 0
FROM @TempCuentas C
INNER JOIN dbo.Personas on C.ValDocIDent=P.ValDocIDent

-- otra manera, es equivalente
Insert dbo.Cuentas (IdTipoCuenta, IdPersona, NumeroCuenta, Saldo)
SELECT  C.IdTipoCuenta, P.Id, T.NumeroCuenta, 0
FROM @TempCuentas C, dbo.Personas 
WHERE C.ValDocIDent=P.ValDocIDent