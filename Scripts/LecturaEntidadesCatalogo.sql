USE Banco
GO

--SELECT * FROM [dbo].[Parentesco]

DECLARE @xmlData XML

SET @xmlData = 
		(SELECT *
		FROM OPENROWSET(BULK 'C:\Archivos\DatosTarea-1-V2.xml', SINGLE_BLOB) 
		AS xmlData);


INSERT INTO [dbo].[TipoIdentidad]([IdTipoIdentidad], [Nombre])
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)')
FROM @xmlData.nodes('Datos/Tipo_Doc/TipoDocuIdentidad') as T(Item)


INSERT INTO [dbo].[Moneda]([IdMoneda], [Nombre])
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(16)')
FROM @xmlData.nodes('Datos/Tipo_Moneda/TipoMoneda') as T(Item)


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
	T.Item.value('@ComisionHumano', 'INT'),
	T.Item.value('@ComisionAutomatico', 'INT'),
	T.Item.value('@Interes', 'INT')
FROM @xmlData.nodes('Datos/Tipo_Cuenta_Ahorros/TipoCuentaAhorro') as T(Item)


INSERT INTO [dbo].[Parentesco]([IdParentesco], [Nombre])
SELECT  
	T.Item.value('@Id', 'INT'),
	T.Item.value('@Nombre', 'VARCHAR(64)')
FROM @xmlData.nodes('Datos/Parentezcos/Parentezco') as T(Item)
