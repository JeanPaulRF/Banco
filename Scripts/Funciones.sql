USE [Banco]
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
GO



CREATE PROCEDURE GetTotalBeneficiarios (@Identificacion varchar(32))
AS
BEGIN
	DECLARE @IdCliente int;
	SELECT @IdCliente = P.IdPersona
	FROM [dbo].[Persona] P
	WHERE P.ValorDocumentoIdentidad=@Identificacion;
	SELECT COUNT(*) FROM [dbo].[Beneficiario] WHERE [IdentificacionCliente]=@IdCliente
END;
GO


CREATE PROCEDURE GetBeneficiariosDeCliente (@Identificacion varchar(32))
AS
BEGIN
	DECLARE @IdCliente int;
	SELECT @IdCliente = P.IdPersona
	FROM [dbo].[Persona] P
	WHERE P.ValorDocumentoIdentidad=@Identificacion;
	
	DECLARE @TempBeneficiario TABLE(
		NumeroCuenta varchar(32),
		Nombre varchar(64),
		Identificacion varchar(32), 
		Parentesco int, 
		Porcentaje int,
		FechaNacimiento date,
		Telefono1 int,
		Telefono2 int
	)

	INSERT INTO @TempBeneficiario(
		Identificacion,
		NumeroCuenta,
		Parentesco, 
		Porcentaje
	)
	SELECT
		B.ValorDocumentoIdentidadBeneficiario,
		B.NumeroCuenta,
		B.ValorParentesco,
		B.Porcentaje
	FROM [dbo].[Beneficiario] B
	WHERE B.IdentificacionCliente=@IdCliente

	--SELECT * FROM @TempBeneficiario
	
	SELECT
		T.Identificacion,
		T.NumeroCuenta,
		T.Parentesco, 
		T.Porcentaje,
		P.[Nombre],
		P.[FechaDeNacimiento],
		P.[Telefono1],
		P.[Telefono2]
	FROM @TempBeneficiario T INNER JOIN [dbo].[Persona] P ON T.Identificacion=P.[ValorDocumentoIdentidad]

END;
GO	


CREATE Procedure get_users_prueba
AS
BEGIN
SELECT * FROM dbo.Usuario;
END
Go
