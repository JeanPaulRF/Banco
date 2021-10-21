USE [Banco]
GO

DECLARE @xmlData XML

SET @xmlData = 
		(SELECT *
		FROM OPENROWSET(BULK 'C:\Archivos\DatosTarea-2.xml', SINGLE_BLOB) 
		AS xmlData);

DECLARE @FechasProcesar TABLE (Fecha date)
INSERT INTO @FechasProcesar(Fecha)
SELECT T.Item.value('@Fecha', 'DATE')--<campo del XML para fecha de operacion>
FROM @xmlData.nodes('Datos/FechaOperacion') as T(Item) --<documento XML>

DECLARE @fechaInicial DATE, @fechaFinal DATE, @DiaCierreEC DATE
DECLARE @CuentasCierran TABLE( sec int identity(1,1), Id Int)
DECLARE @TipoOperacion int

SELECT @fechaInicial=MIN(Fecha), @fechaFinal=MAX(Fecha) FROM @FechasProcesar

WHILE @fechaInicial<=@fechaFinal
BEGIN

	--Insertar Personas
	INSERT INTO [dbo].[Persona](
		[IdTipoIdentidad],
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
		T.Item.value('@Email', 'VARCHAR(32)'),
		T.Item.value('@Telefono1','VARCHAR(16)'),
		T.Item.value('@Telefono2','VARCHAR(16)')
	FROM @xmlData.nodes('Datos/FechaOperacion/AgregarPersona') as T(Item)
	WHERE T.Item.value('../@Fecha', 'DATE') = @fechaInicial;


	--CuentaAhorros
	DECLARE @TempCuentas TABLE
		(Saldo money,
		Fecha date,
		TipoCuenta INT,
		IdentidadCliente VARCHAR(32),  -- Valor DocumentoId del duenno de la cuenta
		NumeroCuenta VARCHAR(32))

	INSERT INTO @TempCuentas(
		NumeroCuenta,
		Saldo,
		Fecha,
		IdentidadCliente,
		TipoCuenta)
	SELECT T.Item.value('@NumeroCuenta','VARCHAR(32)'),
		T.Item.value('@Saldo','MONEY'),
		T.Item.value('@FechaCreacion','DATE'),
		T.Item.value('@ValorDocumentoIdentidadDelCliente','VARCHAR(32)'),
		T.Item.value('@TipoCuentaId','INT')
	FROM @xmlData.nodes('Datos/FechaOperacion/AgregarCuenta') as T(Item)
	WHERE T.Item.value('../@Fecha', 'DATE') = @fechaInicial;

	-- Mapeo @TempCuentas-CuentaAhorro
	INSERT INTO [dbo].[CuentaAhorro](
		[IdCliente], 
		[NumeroCuenta], 
		[Saldo], 
		[FechaConstitucion],
		[IdTipoCuentaAhorro])
	SELECT 
		P.ID,
		C.NumeroCuenta,
		C.Saldo,
		C.Fecha,
		C.TipoCuenta
	FROM @TempCuentas C, [dbo].[Persona] P 
	WHERE C.IdentidadCliente=P.[ValorDocumentoIdentidad]
	

	------------------


	--Insertar Beneficiario
	DECLARE @TempBeneficiario TABLE
		(NumeroCuenta varchar(32),
		ValorDocumentoIdentidadBeneficiario varchar(32),
		ParentezcoId INT,
		Porcentaje int)

	INSERT INTO @TempBeneficiario(
		NumeroCuenta,
		ValorDocumentoIdentidadBeneficiario,
		ParentezcoId,
		Porcentaje)
	SELECT T.Item.value('@NumeroCuenta','VARCHAR(32)'),
		T.Item.value('@ValorDocumentoIdentidadBeneficiario','VARCHAR(32)'),
		T.Item.value('@ParentezcoId','INT'),
		T.Item.value('@Porcentaje','INT')
	FROM @xmlData.nodes('Datos/FechaOperacion/AgregarBeneficiario') as T(Item)
	WHERE T.Item.value('../@Fecha', 'DATE') = @fechaInicial;


	-- Mapeo @@TempBeneficiario-Beneficiario
	INSERT INTO [dbo].[Beneficiario](
		[IdCliente], 
		[IdCuentaAhorro], 
		[NumeroCuenta], 
		[Porcentaje],
		[IdBeneficiario],
		[IdParentesco]
		)
	SELECT C.IdCliente,
		C.ID,
		C.NumeroCuenta,
		B.Porcentaje,
		P.ID,
		B.ParentezcoId
	FROM @TempBeneficiario B, [dbo].[CuentaAhorro] C, [dbo].[Persona] P
	WHERE C.NumeroCuenta=B.NumeroCuenta
		AND P.ValorDocumentoIdentidad=B.ValorDocumentoIdentidadBeneficiario


	--Insertat TipodeCambio
	INSERT INTO [dbo].[TipoCambio](
		[Fecha],
		[CompraTC],
		[VentaTC],
		[IdMoneda])
	SELECT @fechaInicial,
		T.Item.value('@Compra','MONEY'),
		T.Item.value('Venta','MONEY'),
		1
	FROM @xmlData.nodes('Datos/FechaOperacion/TipoCambioDolares') as T(Item)
	WHERE T.Item.value('../@Fecha', 'DATE') = @fechaInicial;
	
	DECLARE @TempMovimientos TABLE (
		Descripcion varchar(64),
		Fecha date,
		Monto money,
		NuevoSaldo money,
		NumeroCuenta int,
		IdMoneda int,
		IdTipoMovimiento int)

	--Insertar Movimientos
	INSERT INTO @TempMovimientos(
		Descripcion,
		Fecha,
		Monto,
		NuevoSaldo,
		NumeroCuenta,
		IdMoneda,
		IdTipoMovimiento)
	SELECT T.Item.value('@Descripcion','VARCHAR(64)'),
		@fechaInicial,
		T.Item.value('@Monto','MONEY'),
		0,
		T.Item.value('@NumeroCuenta','VARCHAR(32)'),
		T.Item.value('@IdMoneda','INT'),
		T.Item.value('@Tipo','INT')
	FROM @xmlData.nodes('Datos/FechaOperacion/Movimientos') as T(Item)
	WHERE T.Item.value('../@Fecha', 'DATE') = @fechaInicial;

	------------------------------

	--Inserta en tabla movimientos
	INSERT INTO [dbo].[MovimientoCA](
		[Descripcion],
		[Fecha],
		[Monto],
		[NuevoSaldo],
		[IdCuentaAhorro],
		[IdTipoMovimientoCA])
	SELECT T.Descripcion,
		@fechaInicial,
		T.Monto,
		C.Saldo,
		C.ID,
		C.IdTipoCuentaAhorro
	FROM @TempMovimientos T, [dbo].[CuentaAhorro] C
	WHERE T.NumeroCuenta = C.NumeroCuenta


	..... Procesar movimientos .. idem (incluye modificar saldos y valores en el estado de cuenta). 
		Para cada movimiento:
	
		Establecer el monto del movimiento dependiendo de la moneda del movimiento respecto de la moneda de la cuenta y aplicando el tipo de cambio mas reciente.
		inserta creditos o debitos
		actualiza saldo de la cuenta que corresponde
		actualizar valores en el estado de cuenta actual (ejemplo: contadores de operaciones en ventana o cajero humano o ATM)
		actualiza el saldo minimo del mes (atributo que esta en el estado de cuenta)
		actualiza contadores (la cantidad de operaciones de atm o operaciones en ventana), necesarias para procesoar comisiones por exceso de cantidad de operaciones en atm o ventana, al cerrar el EC.
		Calcular el nuevo saldo que queda despues de aplicar el movimiento y guardarlo en tabla de movimientos
	
	.... Procesar cierre de Estado de cuenta (aunque en la fecha de operacion talvez no se proceso nada previamente).
	
		 .... cargar en tabla variable las cuentas que fueron creada en dia que corresponde a datepart(@FechaInicio, d)
		 
		Set @DiaCierreEC=datepart(@Fechainicio, d)
		-- considerar hacer ajustes a DiaCierreEC considerando meses de 30 y 31 dias, o annos bisiestos
		insert @CuentasCierran(Id)
		Select C.Id from dbo.Cuentas C where datepart(C.FechaCreacion, d)=DiaCierreEC
		 
		Select @lo1=1, @hi1=max(sec) from @CuentasCierran
		 
		while @lo1<=@hi1
		begin
		
			Select @IdCuentaCierre=C.CodigoCuenta from @CuentasCierran where sec=@lo1
			
			-- procesar cierre de Estado de cuenta de @CuentaCierre
			--- Calcular intereses respecto del saldo minimo durante el mes, agregar credito por interes ganado y afectar saldo
			--- calcular multa por incumplimiento de saldo minimo y agregar movimiento debito y afecta saldo.
			--- cobro de comision por exceso de operaciones en ATM. Debito
			--- cobro de comision por exceso de operaciones en cajero humano. Debito
			--- cobro de cargos por servicio. Debito.
			-- cerrar el estado de cuenta (actualizar valores, como saldo final, y otros)
			-- abrir (insertar) estado de cuenta para nuevo mes (fecha inicio, fecha fin, saldoinicial - igual al saldo final de EC que se cierra, saldo minimo, etc) 
	
			Set @lo1=@lo1+1
		end

	Set @fechaFinal=dateadd(@fechaFinal, d, 1)
END;