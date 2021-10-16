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

DECLARE @fechaInicial DATE, @fechaFinal DATE, 
DECLARE @DiaCierreEC DATE
DECLARE @CuentasCierran TABLE( sec int identity(1,1), Id Int)

SELECT @fechaInicial=MIN(Fecha), @fechaFinal=MAX(Fecha),  FROM @FechasProcesar

WHILE @fechaInicial<=@fechaFinal
BEGIN
	
	..... Procesar insercion de clientes en fecha de operacion igual a @FechaInicial (si es que hay)
	..... Procesan cuentas ... idem
	..... Procesar beneficiarios ... idem
	..... Procesar Tipo de cambio del dolar 
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