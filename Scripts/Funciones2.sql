USE BANCO 
GO

CREATE PROCEDURE InsertarCuentaObjetivo(
	@NumeroCuenta varchar(32),
	@FechaInicio varchar(32),
	@FechaFin varchar(32),
	@Costo money,
	@Objetivo varchar(64),
	@Saldo money,
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
				@Saldo,
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
			SELECT CAST(@FechaInicio AS date) AS dataconverted
			SELECT CAST(@FechaFin AS date) AS dataconverted

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



--TRIGGERS

CREATE TRIGGER dbo.ActualizarTipoCambio
ON [dbo].[TipoCambio]
AFTER INSERT
AS
BEGIN
	DECLARE @IdTipoCambio int
	SET @IdTipoCambio = (SELECT ID FROM Inserted)

	UPDATE [dbo].[Moneda]
	SET [IdTipoCambioFinal]=@IdTipoCambio
END;
GO



CREATE TRIGGER dbo.AplicarMovimiento
ON [dbo].[MovimientoCA] AFTER INSERT
AS
BEGIN
	DECLARE
		@Monto money,
		@TipoMovimiento int,
		@NumeroCuenta varchar(32),
		@IdMoneda int,
		@IdCuenta int,
		@IdTipoCuenta int

	SET @IdCuenta = (SELECT IdCuentaAhorro FROM Inserted)
	SET @IdTipoCuenta = (SELECT IdTipoCuentaAhorro FROM [dbo].[CuentaAhorro] C WHERE C.ID=@IdCuenta)
	SET @Monto = (SELECT Monto FROM Inserted)
	SET @TipoMovimiento = (SELECT IdTipoMovimientoCA FROM Inserted)
	SET @NumeroCuenta = (SELECT C.NumeroCuenta FROM [dbo].[CuentaAhorro] C WHERE C.ID=@IdCuenta)
	SET @IdMoneda = (SELECT T.IdMoneda FROM [dbo].[TipoCuentaAhorro] T WHERE T.ID=@IdTipoCuenta)

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

	UPDATE [dbo].[MovimientoCA]
	SET NuevoSaldo=C.Saldo
	FROM [dbo].[CuentaAhorro] C
	WHERE C.ID=@IdCuenta
		
END;
GO


CREATE TRIGGER dbo.CrearEstadoCuenta
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
	SET @FechaFin = dateadd(m, 1, @FechaInicio)
	SET @SaldoInicial = (SELECT [Saldo] FROM Inserted)
	SET @SaldoFinal = @SaldoInicial
	SET @IdCuentaAhorro = (SELECT [ID] FROM Inserted)
	SET @QOperacionesATM = 0
	SET @QOperacionesHumano = 0

	INSERT INTO [dbo].[EstadoCuenta](
		[FechaInicio],
		[FechaFin],
		[SaldoInicial],
		[SaldoFinal],
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


CREATE TRIGGER dbo.ActualizarEstadoCuenta
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

SELECT * FROM Persona WHERE ValorDocumentoIdentidad='117370445'




CREATE PROCEDURE dbo.CerrarEstadosCuenta(@Fecha date)
AS
BEGIN
	UPDATE [dbo].[EstadoCuenta]
	SET Activo=0
	WHERE [FechaFin]<=@Fecha
END;
GO



--PROCEDURES EXTRA

CREATE PROCEDURE dbo.GetCuentasObjetivo(@NumeroCuenta varchar(32))
AS
BEGIN
	DECLARE @IdCuenta int
	SET @IdCuenta = 
		(SELECT ID FROM [dbo].[CuentaAhorro] WHERE [NumeroCuenta]=@NumeroCuenta)

	SELECT
		C.[FechaInicio],
		C.[FechaFin],
		C.[Costo],
		C.[Objetivo],
		C.[Saldo],
		C.[InteresAcumulado],
		C.[Activo]
	FROM [dbo].[CuentaObjetivo] C
	WHERE C.[IdCuentaAhorro]=@IdCuenta
END;
GO


CREATE PROCEDURE dbo.GetEstadosCuenta(@NumeroCuenta varchar(32))
AS
BEGIN
	DECLARE @IdCuenta int
	SET @IdCuenta= (SELECT ID FROM [dbo].[CuentaAhorro] WHERE NumeroCuenta=@NumeroCuenta)

	SELECT * FROM [dbo].[EstadoCuenta] WHERE [IdCuentaAhorro]=@IdCuenta
END;
GO


CREATE PROCEDURE dbo.GetMovimientosDeEstado(@IdEstadoCuenta int)
AS
BEGIN
	SELECT * FROM [dbo].[MovimientoCA] WHERE [IdEstadoCuenta]=@IdEstadoCuenta
END;
GO