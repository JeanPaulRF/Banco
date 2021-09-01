USE [Banco]
GO

DECLARE @docXml xml

set @docXml = '<Tipo_Doc>
<TipoDocuIdentidad Id="1" Nombre="Cedula Nacional"/>
<TipoDocuIdentidad Id="2" Nombre="Cedula Residente"/>
<TipoDocuIdentidad Id="3" Nombre="Pasaporte"/>
<TipoDocuIdentidad Id="4" Nombre="Cedula Juridica"/>
<TipoDocuIdentidad Id="5" Nombre="Permiso de Trabajo"/>
<TipoDocuIdentidad Id="6" Nombre="Cedula Extranjera"/>
</Tipo_Doc>
<Tipo_Moneda>
<TipoMoneda Id="1" Nombre="Colones" Simbolo="₡"/>
<TipoMoneda Id="2" Nombre="Dolares" Simbolo="$"/>
<TipoMoneda Id="3" Nombre="Euros" Simbolo="€"/>
</Tipo_Moneda>
<Parentezcos>
<Parentezco Id="1" Nombre="Padre"/>
<Parentezco Id="2" Nombre="Madre"/>
<Parentezco Id="3" Nombre="Hijo"/>
<Parentezco Id="4" Nombre="Hija"/>
<Parentezco Id="5" Nombre="Hermano"/>
<Parentezco Id="6" Nombre="Hermana"/>
<Parentezco Id="7" Nombre="amigo"/>
<Parentezco Id="8" Nombre="amiga"/>
</Parentezcos>
<Tipo_Cuenta_Ahorros>
<TipoCuentaAhorro
Id="1"
Nombre="Proletario"
IdTipoMoneda="1"
SaldoMinimo="25000.00"
MultaSaldoMin="3000.00"
CargoAnual = "5000"
NumRetirosHumano="5"
NumRetirosAutomatico ="8"
comisionHumano="300"
omisionAutomatico="300"
interes ="10" />
<TipoCuentaAhorro
Id="2"
Nombre="Profesional"
IdTipoMoneda="1"
SaldoMinimo="50000.00"
MultaSaldoMin="3000.00"
CargoAnual = "15000"
NumRetirosHumano="5"
NumRetirosAutomatico ="8"
comisionHumano="500"
comisionAutomatico="500"
interes ="15" />
<TipoCuentaAhorro
Id="3"
Nombre="Exclusivo"
IdTipoMoneda="1"
SaldoMinimo="100000.00"
MultaSaldoMin="3000.00"
CargoAnual = "30000"
NumRetirosHumano="5"
NumRetirosAutomatico ="8"
comisionHumano="1000"
comisionAutomatico="1000"
interes ="20" />
</Tipo_Cuenta_Ahorros>
<Personas>
<Persona
TipoDocuIdentidad="1"
Nombre="Juan de la Barca"
ValorDocumentoIdentidad="117370445"
FechaNacimiento="1999-03-20"
Email="aguerojavith@gmail.com"
telefono1="85343403"
telefono2="24197636"/>
<Persona
TipoDocuIdentidad="1"
Nombre="Pedro Camacho Fernandez"
ValorDocumentoIdentidad="12738545"
FechaNacimiento="1994-10-13"
Email="osadage@gmail.com"
telefono1="87541766"
telefono2="24197545"/>
</Personas>
<Cuentas>
<Cuenta ValorDocumentoIdentidadDelCliente="117370445"
TipoCuentaId="1"
NumeroCuenta="11000001"
FechaCreacion="2020-10-13"
Saldo="1000000.00"/>
</Cuentas>
<!-- Entre 20 y 30-->
<Beneficiarios>
<Beneficiario
NumeroCuenta="11000001"
ValorDocumentoIdentidadBeneficiario="117370445"
ParentezcoId="5"
Porcentaje="25" />
</Beneficiarios>
<Usuarios>
<Usuario User="jaguero" Pass="LaFacil" EsAdministrador="0" />
<Usuario User="fquiros" Pass="MyPass123*" EsAdministrador="1" />
</Usuarios>
<Usuarios_Ver>
<UsuarioPuedeVer User="jaguero" NumeroCuenta="11000001" />
</Usuarios_Ver>'

declare @nombre varchar(100)
set @nombre= @docXml.value('(/Personas/Persona/@Nombre)[1]', 'varchar(100)')
Select @nombre