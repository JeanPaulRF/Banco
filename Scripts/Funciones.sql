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
	
	SELECT * FROM [dbo].[Beneficiario] WHERE [IdentificacionCliente]=@IdCliente
/*
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
*/
END;
GO	

/*
CREATE PROCEDURE ValidarUsuarioContrasena(@Usuario varchar(16), @Pass varchar(32))
AS
BEGIN
	DECLARE @Usuario varchar(16)
	SET @Usuario = 'jaguero'
	DECLARE @Pass varchar(32)
	SET @Pass = 'LaFacil'

	DECLARE @Name varchar(16)
	SET @Name = (SELECT Nombre FROM [dbo].[Usuario] WHERE @Usuario=Nombre)
	DECLARE @Contra varchar(32)
	SET @Contra = (SELECT Contrasena FROM [dbo].[Usuario] WHERE @Pass=Contrasena)

	IF @Name!=NULL
		SELECT 1
	ELSE
		SELECT 0

	USE Banco
	GO
	SELECT * FROM Usuario
END;
GO
*/

CREATE PROCEDURE GetCliente(@Identificacion varchar(32))
AS
BEGIN
	SELECT * FROM [dbo].[Persona] WHERE [ValorDocumentoIdentidad]=@Identificacion
END;
GO


CREATE PROCEDURE GetCuenta(@NumeroCuenta varchar(32))
AS
BEGIN
	SELECT * FROM [dbo].[CuentaAhorro] WHERE [NumeroCuenta]=@NumeroCuenta
END;
GO


CREATE PROCEDURE GetTodosClientes
AS
BEGIN
	SELECT * FROM [dbo].[Persona]
END;
GO


CREATE PROCEDURE GetTodasCuentas
AS
BEGIN
	SELECT * FROM [dbo].[CuentaAhorro]
END;
GO

CREATE PROCEDURE GetTodosBeneficiarios
AS
BEGIN
	SELECT * FROM [dbo].[Beneficiario]
END;
GO


CREATE PROCEDURE get_users_prueba
AS
BEGIN
	SELECT * FROM dbo.Usuario;
END;
GO
