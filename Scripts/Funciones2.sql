USE BANCO 
GO

CREATE PROCEDURE InsertarCuentaObjetivo(
	@NumeroCuenta varchar(32),
	@FechaInicio varchar(32),
	@FechaFin varchar(32),
	@Costo money,
	@Objetivo varchar(64),
	@Interes int,
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @IdCuenta int
		SELECT @IdCuenta=C.ID
		FROM [dbo].[CuentaAhorro] C
		WHERE C.NumeroCuenta=@NumeroCuenta

		BEGIN TRANSACTION T1
			SELECT CAST(@FechaInicio AS date) AS dataconverted;
			SELECT CAST(@FechaFin AS date) AS dataconverted;

			INSERT INTO [dbo].[CuentaObjetivo](
				[FechaInicio],
				[FechaFin],
				[Costo],
				[Objetivo],
				[Saldo],
				[InteresAcumulado],
				[IdCuentaAhorro])
			SELECT
				@FechaInicio,
				@FechaFin,
				@Costo,
				@Objetivo,
				@Interes,
				@IdCuenta
		COMMIT TRANSACTION T1
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T1;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


CREATE PROCEDURE ActualizarCuentaObjetivo(
	@NumeroCuenta varchar(32),
	@FechaInicio varchar(32),
	@FechaFin varchar(32),
	@Objetivo varchar(64),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @IdCuenta int
		SELECT @IdCuenta=C.ID
		FROM [dbo].[CuentaAhorro] C
		WHERE C.NumeroCuenta=@NumeroCuenta

		BEGIN TRANSACTION T2
			SELECT CAST(@FechaInicio AS date) AS dataconverted;
			SELECT CAST(@FechaFin AS date) AS dataconverted;

			UPDATE [dbo].[CuentaObjetivo]
			SET
				[FechaInicio]=@FechaInicio,
				[FechaFin]=@FechaFin,
				[Objetivo]=@Objetivo
			WHERE [IdCuentaAhorro]=@IdCuenta
		COMMIT TRANSACTION T2
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T2;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


CREATE PROCEDURE ActivacionCuentaObjetivo(
	@NumeroCuenta varchar(32),
	@outCodeResult int OUTPUT)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @IdCuenta int
		SELECT @IdCuenta=C.ID
		FROM [dbo].[CuentaAhorro] C
		WHERE C.NumeroCuenta=@NumeroCuenta

		DECLARE @Valor bit
		SELECT @Valor=C.Activo
		FROM [dbo].[CuentaObjetivo] C
		WHERE C.IdCuentaAhorro=@IdCuenta

		IF  @Valor=1
		BEGIN
			SET @Valor=0
		END ELSE
		BEGIN
			SET @Valor=1
		END

		BEGIN TRANSACTION T3
			UPDATE [dbo].[CuentaObjetivo]
			SET [Activo]=@Valor
			WHERE [IdCuentaAhorro]=@IdCuenta
		COMMIT TRANSACTION T3
	 END TRY
	 BEGIN CATCH
		IF @@tRANCOUNT>0
			ROLLBACK TRAN T2;
		--INSERT EN TABLA DE ERRORES;
		SET @outCodeResult=50005;
	 END CATCH
	 SET NOCOUNT OFF
END;
GO


CREATE PROCEDURE dbo.AplicarMovimiento(
	@Monto money,
	@TipoMovimiento int,
	@NumeroCuenta varchar(32),
	@IdMoneda int)
AS
BEGIN
	--Si es el mismo tipo de moneda
	UPDATE [dbo].[CuentaAhorro]
	SET
		Saldo=Saldo+(@Monto*(-1^@TipoMovimiento)*-1) --realiza el movimiento
	FROM [dbo].[TipoCuentaAhorro] C
	WHERE @NumeroCuenta=[NumeroCuenta] 
		AND [IdTipoCuentaAhorro]=C.ID --busca el tipo de cuenta ahorro
			AND  C.[IdMoneda]=@IdMoneda --si es el mismo tipo de moneda

	--Si la cuenta es en Dolares y el movimiento es el Colones
	UPDATE [dbo].[CuentaAhorro]
	SET
		Saldo=Saldo+ ( (@Monto/M.VentaTC) * (-1^@TipoMovimiento) * -1 )  --realiza el movimiento
	FROM [dbo].[TipoCuentaAhorro] C, 
		[dbo].[TipoCambio] M, [dbo].[Moneda] M2
	WHERE @NumeroCuenta=[NumeroCuenta] 
		AND [IdTipoCuentaAhorro]=C.ID --busca el tipo de cuenta ahorro
			AND  C.[IdMoneda]= 2 --Si la cuenta es en dolares
				AND @IdMoneda = 1 --Si el movimiento es en colones
					AND M.ID = M2.[IdTipoCambioFinal]

	--Si la cuenta es en Colones y el movimiento es el Dolares
	UPDATE [dbo].[CuentaAhorro]
	SET
		Saldo=Saldo+ ( (@Monto/M.CompraTC) * (-1^@TipoMovimiento) * -1 )  --realiza el movimiento
	FROM [dbo].[TipoCuentaAhorro] C, 
		[dbo].[TipoCambio] M, [dbo].[Moneda] M2
	WHERE @NumeroCuenta=[NumeroCuenta] 
		AND [IdTipoCuentaAhorro]=C.ID --busca el tipo de cuenta ahorro
			AND  C.[IdMoneda]= 2 --Si la cuenta es en colones
				AND @IdMoneda = 1 --Si el movimiento es en dolares
					AND M.ID = M2.[IdTipoCambioFinal]

END;
GO


CREATE TRIGGER CrearEstadoCuenta
ON [dbo].[CuentaAhorro]
AFTER INSERT
AS
BEGIN
	DECLARE 
		@FechaInicio date, @FechaFin date,
		@SaldoInicial money, @SaldoFinal money,
		@IdCuentaAhorro int, @QOperacionesATM int,
		@QOperacionesHumano int

	SET @FechaInicio = (SELECT [FechaConstitucion] FROM Inserted)
	SET @FechaFin = dateadd(@FechaInicio, m, 1)
	SET @SaldoInicial = (SELECT [Saldo] FROM Inserted)
	SET @SaldoFinal = @SaldoInicial
	SET @IdCuentaAhorro = (SELECT [ID] FROM Inserted)
	SET @QOperacionesATM = 0
	SET @QOperacionesHumano = 0

	INSERT INTO [dbo].[EstadoCuenta](
		[FechaInicio],
		[FechaFin],
		[SaldoInicial],
		[IdCuentaAhorro],
		[QOperacionesATM],
		[QOperacionesHumano])
	SELECT
		@FechaInicio,
		@FechaFin,
		@SaldoInicial,
		@SaldoFinal,
		@IdCuentaAhorro,
		@QOperacionesATM,
		@QOperacionesHumano
END;
GO


CREATE TRIGGER ActualizarEstadoCuenta
ON [dbo].[MovimientoCA]
AFTER INSERT
AS
BEGIN
	DECLARE 
		@IdTipoMovimiento int, @IdMovimiento int

	SET @IdTipoMovimiento = (SELECT [IdTipoMovimientoCA] FROM Inserted)
	SET @IdMovimiento = (SELECT [ID] FROM Inserted)

	IF @IdTipoMovimiento=1 OR @IdTipoMovimiento=7
	BEGIN
		UPDATE [dbo].[EstadoCuenta]
		SET QOperacionesHumano = QOperacionesHumano+1
		WHERE ID=@IdMovimiento
	END ELSE 
	BEGIN
		IF @IdTipoMovimiento=2 OR @IdTipoMovimiento=6
		BEGIN
			UPDATE [dbo].[EstadoCuenta]
			SET QOperacionesATM = QOperacionesATM+1
			WHERE ID=@IdMovimiento
		END
	END
END;
GO