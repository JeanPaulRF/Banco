USE [Banco]
GO

DECLARE @CurrentTime DATETIME=GETDATE();
GO


CREATE PROCEDURE dbo.InsertarBeneficiario 
(@NumeroCuenta int, @Identificacion varchar(32), @Parentesco int, @Porcentaje int)
AS
BEGIN
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
		@Porcentaje,
		@Identificacion,
		@Parentesco
	FROM [dbo].[CuentaAhorro] C
	WHERE @NumeroCuenta=C.NumeroCuenta
END;
GO


CREATE PROCEDURE dbo.EditarBeneficiario (
	@IdentificacionAntigua varchar(32),
	@Nombre varchar(64),
	@Identificacion varchar(32), 
	@Parentesco int, 
	@Porcentaje int,
	@FechaNacimiento date,
	@Telefono1 int,
	@Telefono2 int
	)
AS
BEGIN
	UPDATE [dbo].[Beneficiario]
	SET [Porcentaje]=@Porcentaje, 
		[ValorDocumentoIdentidadBeneficiario]=@Identificacion,
		[ValorParentesco]=@Parentesco
	WHERE [ValorDocumentoIdentidadBeneficiario]=@IdentificacionAntigua

	UPDATE [dbo].[Persona]
	SET [Nombre]=@Nombre,
		[ValorDocumentoIdentidad]=@Identificacion,
		[FechaDeNacimiento]=@FechaNacimiento,
		[Telefono1]=@Telefono1,
		[Telefono2]=@Telefono2
	WHERE [ValorDocumentoIdentidad]=@IdentificacionAntigua
END;
GO


CREATE PROCEDURE EliminarBeneficiario (@Identificacion varchar(32))
AS
BEGIN
	DECLARE @CurrentTime DATETIME=GETDATE();

	UPDATE [dbo].[Beneficiario]
	SET [Activo]=0,
		[Porcentaje]=0,
		[FechaDesactivacion]=@CurrentTime
	WHERE [ValorDocumentoIdentidadBeneficiario]=@Identificacion
END;


CREATE Procedure get_users_prueba
AS
BEGIN
SELECT * FROM dbo.Usuario;
END
Go
exec get_users_prueba