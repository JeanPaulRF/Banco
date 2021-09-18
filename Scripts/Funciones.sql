USE [Banco]
GO

--FUNCIONES BASICAS DE BENEFICIARIO

CREATE PROCEDURE InsertarBeneficiario (
	@NumeroCuenta varchar(32),
	@Identificacion varchar(32),
	@Parentesco int, 
	@Porcentaje int
	)
AS
BEGIN
	IF EXISTS (SELECT * FROM [dbo].[Persona] WHERE [ValorDocumentoIdentidad]=@Identificacion)
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

		SELECT * FROM [dbo].[Beneficiario] WHERE [ValorDocumentoIdentidadBeneficiario]='777777'

		SELECT * FROM [dbo].[Persona] WHERE	[ValorDocumentoIdentidad]=@Identificacion

		END

	ELSE 
		BEGIN

		INSERT INTO [dbo].[Persona](
			[Nombre],
			[ValorDocumentoIdentidad],
			[TipoIdentidad],
			[FechaDeNacimiento],
			[Email],
			[Telefono1],
			[Telefono2])
		SELECT 
			'No conocido',					
			@Identificacion,								
			1,		
			'na@na.com',					
			'1901-01-01',				
			'00000000',					
			'00000000'

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

		END
END;
GO

CREATE PROCEDURE EditarBeneficiario (
	@IdentificacionAntigua varchar(32),
	@Nombre varchar(64),
	@Identificacion varchar(32),
	@Parentesco int, 
	@Porcentaje int,
	@FechaNacimiento varchar(32),
	@Email varchar(32),
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
		[Email]=@Email,
		[Telefono1]=@Telefono1,
		[Telefono2]=@Telefono2
	WHERE [ValorDocumentoIdentidad]=@IdentificacionAntigua
END;
GO


CREATE PROCEDURE EliminarBeneficiario (@Identificacion varchar(32), @value int)
AS
BEGIN
	DECLARE @CurrentTime DATE=GETDATE();

	UPDATE [dbo].[Beneficiario]
	SET [Activo]=@value,
		[Porcentaje]=@value,
		[FechaDesactivacion]=@CurrentTime
	WHERE [ValorDocumentoIdentidadBeneficiario]=@Identificacion

	SELECT * FROM Beneficiario
END;
GO

-- TOTALES

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


CREATE PROCEDURE GetTotalPorcentajes (@Identificacion varchar(32))
AS
BEGIN
	DECLARE @IdCliente int;
	SELECT @IdCliente = P.IdPersona
	FROM [dbo].[Persona] P
	WHERE P.ValorDocumentoIdentidad=@Identificacion;

	SELECT SUM ([Porcentaje]) FROM [dbo].[Beneficiario] WHERE [IdentificacionCliente]=@IdCliente
END;
GO

--CONSULTAS ESPECIFICAS

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
		FechaNacimiento varchar(32),
		Email varchar(32),
		Telefono1 int,
		Telefono2 int,
		Activo bit
	)
	INSERT INTO @TempBeneficiario(
		Identificacion,
		NumeroCuenta,
		Parentesco, 
		Porcentaje,
		Activo
	)
	SELECT
		B.ValorDocumentoIdentidadBeneficiario,
		B.NumeroCuenta,
		B.ValorParentesco,
		B.Porcentaje,
		B.Activo
	FROM [dbo].[Beneficiario] B
	WHERE B.IdentificacionCliente=@IdCliente
	
	SELECT
		T.Identificacion,
		T.NumeroCuenta,
		T.Parentesco, 
		T.Porcentaje,
		P.[Nombre],
		P.[FechaDeNacimiento],
		P.[Email],
		P.[Telefono1],
		P.[Telefono2],
		T.Activo
	FROM @TempBeneficiario T INNER JOIN [dbo].[Persona] P ON T.Identificacion=P.[ValorDocumentoIdentidad]
END;
GO	


CREATE PROCEDURE GetBeneficiariosActivosDeCliente (@Identificacion varchar(32))
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
		FechaNacimiento varchar(32),
		Email varchar(32),
		Telefono1 int,
		Telefono2 int,
		Activo bit
	)
	INSERT INTO @TempBeneficiario(
		Identificacion,
		NumeroCuenta,
		Parentesco, 
		Porcentaje,
		Activo
	)
	SELECT
		B.ValorDocumentoIdentidadBeneficiario,
		B.NumeroCuenta,
		B.ValorParentesco,
		B.Porcentaje,
		B.Activo
	FROM [dbo].[Beneficiario] B
	WHERE B.IdentificacionCliente=@IdCliente AND Activo=1
	
	SELECT
		T.Identificacion,
		T.NumeroCuenta,
		T.Parentesco, 
		T.Porcentaje,
		P.[Nombre],
		P.[FechaDeNacimiento],
		P.[Email],
		P.[Telefono1],
		P.[Telefono2],
		T.Activo
	FROM @TempBeneficiario T INNER JOIN [dbo].[Persona] P ON T.Identificacion=P.[ValorDocumentoIdentidad]
END;
GO	


CREATE PROCEDURE GetUsuariosPuedeVer(@Usuario varchar(16))
AS
BEGIN
	SELECT [NumeroCuenta] FROM [dbo].[UsuarioPuedeVer]
END;
GO


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


CREATE PROCEDURE GetBeneficiario (@Identificacion varchar(32))
AS
BEGIN
	DECLARE @TempBeneficiario TABLE(
		NumeroCuenta varchar(32),
		Nombre varchar(64),
		Identificacion varchar(32), 
		Parentesco int, 
		Porcentaje int,
		FechaNacimiento varchar(32),
		Email varchar(32),
		Telefono1 int,
		Telefono2 int,
		Activo bit
	)
	INSERT INTO @TempBeneficiario(
		Identificacion,
		NumeroCuenta,
		Parentesco, 
		Porcentaje,
		Activo
	)
	SELECT
		@Identificacion,
		B.NumeroCuenta,
		B.ValorParentesco,
		B.Porcentaje,
		B.Activo
	FROM [dbo].[Beneficiario] B
	WHERE B.ValorDocumentoIdentidadBeneficiario=@Identificacion
	
	SELECT
		T.Identificacion,
		T.NumeroCuenta,
		T.Parentesco, 
		T.Porcentaje,
		P.[Nombre],
		P.[FechaDeNacimiento],
		P.[Email],
		P.[Telefono1],
		P.[Telefono2],
		T.Activo
	FROM @TempBeneficiario T INNER JOIN [dbo].[Persona] P ON T.Identificacion=P.[ValorDocumentoIdentidad]
END;
GO	


CREATE PROCEDURE GetCuentasDeCliente(@Identificacion varchar(32))
AS
BEGIN
	DECLARE @IdCliente int;
	SELECT @IdCliente = P.IdPersona
	FROM [dbo].[Persona] P
	WHERE P.ValorDocumentoIdentidad=@Identificacion;
	
	SELECT * FROM [dbo].[CuentaAhorro] WHERE [IdentificacionCliente]=@IdCliente
END;
GO

--VALIDACION

CREATE PROCEDURE ValidarUsuarioContrasena(@Usuario varchar(16), @Pass varchar(32))
AS
BEGIN
	DECLARE @Tabla TABLE (Resultado int)

	IF EXISTS (SELECT * FROM [dbo].[Usuario] WHERE @Usuario=Nombre)
		IF EXISTS (SELECT * FROM [dbo].[Usuario] WHERE @Pass=Contrasena)
			INSERT INTO @Tabla(Resultado) SELECT 1
		ELSE
			INSERT INTO @Tabla(Resultado) SELECT 0
	ELSE
		INSERT INTO @Tabla(Resultado) SELECT 0
	
	SELECT * FROM @Tabla
END;
GO

--PARA ADMIN

CREATE PROCEDURE GetTodosClientes
AS
BEGIN
	SELECT * FROM [dbo].[Persona]
END;
GO


CREATE PROCEDURE GetTodosParentescos
AS
BEGIN
	SELECT * FROM [dbo].[Parentesco]
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
	DECLARE @TempBeneficiario TABLE(
		NumeroCuenta varchar(32),
		Nombre varchar(64),
		Identificacion varchar(32), 
		Parentesco int, 
		Porcentaje int,
		FechaNacimiento varchar(32),
		Email varchar(32),
		Telefono1 int,
		Telefono2 int,
		Activo bit
	)
	INSERT INTO @TempBeneficiario(
		Identificacion,
		NumeroCuenta,
		Parentesco, 
		Porcentaje,
		Activo
	)
	SELECT
		B.ValorDocumentoIdentidadBeneficiario,
		B.NumeroCuenta,
		B.ValorParentesco,
		B.Porcentaje,
		B.Activo
	FROM [dbo].[Beneficiario] B
	
	SELECT
		T.Identificacion,
		T.NumeroCuenta,
		T.Parentesco, 
		T.Porcentaje,
		P.[Nombre],
		P.[FechaDeNacimiento],
		P.[Email],
		P.[Telefono1],
		P.[Telefono2],
		T.Activo
	FROM @TempBeneficiario T INNER JOIN [dbo].[Persona] P ON T.Identificacion=P.[ValorDocumentoIdentidad]
END;
GO

--PRUEBA

CREATE PROCEDURE GetTodosUsuarios
AS
BEGIN
	SELECT * FROM dbo.Usuario;
END;
GO

CREATE PROCEDURE GetUser (@Identificacion varchar(32))
AS
BEGIN 
	SELECT * FROM [dbo].[Usuario] WHERE [ValorDocumentoIdentidad] =	@Identificacion
END;
GO

--PRUEBA




