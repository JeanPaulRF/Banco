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


CREATE PROCEDURE CambiarEstadoCuentaObjetivo(
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