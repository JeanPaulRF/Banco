import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { beneficiarios } from './modules/beneficiarios';
import { cuentas } from './modules/cuentas';
import { usuario } from './modules/usuario';
import { clientes } from './modules/clientes';
import { estados } from './modules/estados';

@Injectable({
  providedIn: 'root'
})
export class DataService {

  private API = "http://localhost:3002/api";

  constructor(private response: HttpClient) { }

  ngOnInit() { }


  login_Confirmation(username: string, password: string) {
    let data = { username, password };
    return this.response.get(this.API + '/banco/users/' + username + '/' + password);
  }

  get_user(identificacion: string) {
    return this.response.get<usuario[]>(this.API + '/banco/users/' + identificacion);
  }

  get_beneficiaries() {
    return this.response.get<beneficiarios[]>(this.API + '/banco/beneficiarios');
  }

  get_beneficiario(identificacion: string) {
    return this.response.get<beneficiarios[]>(this.API + '/banco/beneficiario/' + identificacion);
  }

  get_beneficiaries_by_cliente(identificacion: string) {
    return this.response.get<beneficiarios[]>(this.API + '/banco/beneficiarios/' + identificacion);
  }

  get_cantidaBeneficiarios(identificacion: string) {
    let data = { identificacion };
    return this.response.get(this.API + '/banco/cantidad');
  }

  get_cuentas() {
    return this.response.get<cuentas[]>(this.API + '/banco/cuentas');
  }

  get_cuentas_cliente(identificacion: string) {
    return this.response.get<cuentas[]>(this.API + '/banco/cuentas/' + identificacion);
  }

  get_clientes() {
    return this.response.get<clientes[]>(this.API + '/banco/clientes');
  }


  insertar_beneficiario(
    NumeroCuenta: string,
    Identificacion: string,
    Parentesco: number,
    Porcentaje: number
  ) {
    let data = {
      NumeroCuenta, Identificacion, Parentesco,
      Porcentaje
    };
    return this.response.post(this.API + '/banco/benefs', data);
  }


  eliminar_beneficiario(Identificacion: string, value: number) {
    let data = { Identificacion, value };
    return this.response.put(this.API + '/banco/' + Identificacion, data);
  }

  modificar_beneficiario(
    Identificacion1: string,
    Nombre: string,
    Identificacion2: string,
    Parentesco: number,
    Porcentaje: number,
    FechaNaci: string,
    Email: string,
    Telefono1: number,
    Telefono2: number) {

    let data2 = {
      Identificacion1,
      Nombre,
      Identificacion2,
      Parentesco,
      Porcentaje,
      FechaNaci,
      Email,
      Telefono1,
      Telefono2
    };
    console.log(data2);
    return this.response.post(this.API + '/banco/' + Identificacion1, data2);
  }

//-----------------------------

insertar_objetivo(
  NumeroCuenta:string,
  FechaInicio:string,
  FechaFin:string,
  Costo:number,
  Objetivo:string,
  Saldo:number,
  Interes:number,
  outCodeResult:number = 201
) {
  let data = {
    NumeroCuenta,
    FechaInicio,
    FechaFin,
    Costo,
    Objetivo,
    Saldo,
    Interes,
    outCodeResult 
  };

  console.log("yeah: ",
  NumeroCuenta,
  FechaInicio,
  FechaFin,
  Costo,
  Objetivo,
  Saldo,
  Interes,
  outCodeResult);

  return this.response.post(this.API + '/banco/addObjetivo', data);
}

get_estados(cuenta:string) {
  return this.response.get<estados[]>(this.API + '/banco/estados/'+cuenta);
}



}
