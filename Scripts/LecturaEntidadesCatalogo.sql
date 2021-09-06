USE Banco
GO

--SELECT * FROM [dbo].[Parentesco]

DECLARE @xmlData XML

SET @xmlData = 
		(SELECT *
		FROM OPENROWSET(BULK 'C:\Archivos\DatosCatalogos.xml', SINGLE_BLOB) 
		AS xmlData);


INSERT INTO [dbo].[TipoIdentidad]([IdTipoIdentidad], [Nombre])
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)')
FROM @xmlData.nodes('Tipo_Doc/TipoDocuIdentidad') as T(Item)

INSERT INTO [dbo].[Moneda]([IdMoneda], [Nombre])
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(16)')
FROM @xmlData.nodes('Monedas/Moneda') as T(Item)

INSERT INTO [dbo].[TipoCuentaAhorro]
	([IdTipoCuentaAhorro], 
	[Nombre],
	[IdTipoMoneda],
	[SaldoMinimo],
	[MultaSaldoMin],
	[CargoAnual],
	[NumRetirosHumanos],
	[NumRetirosAutomaticos],
	[ComisionHumano],
	[ComisionAutomatico],
	[Interes])
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)'),
	T.Item.value('@IdTipoMoneda', 'INT'),
	T.Item.value('@SaldoMinimo', 'MONEY'),
	T.Item.value('@MultaSaldoMin', 'MONEY'),
	T.Item.value('@CargoAnual', 'INT'),
	T.Item.value('@NumRetirosHumano', 'INT'),
	T.Item.value('@NumRetirosAutomatico', 'INT'),
	T.Item.value('@comisionHumano', 'INT'),
	T.Item.value('@comisionAutomatico', 'INT'),
	T.Item.value('@interes', 'INT')
FROM @xmlData.nodes('Tipo_Cuenta_Ahorros/TipoCuentaAhorro') as T(Item)


INSERT INTO [dbo].[Parentesco]([IdParentesco], [Nombre])
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)')
FROM @xmlData.nodes('Parentezcos/Parentezco') as T(Item)
