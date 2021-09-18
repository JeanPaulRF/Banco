import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { users } from './components/home/users.module';
import { beneficiarios } from './modules/beneficiarios';
import { cuentas } from './modules/cuentas'; 
import { usuario } from './modules/usuario';
@Injectable({
  providedIn: 'root'
})
export class DataService {

  private API = "http://localhost:3002/api";  
  
  constructor(private response: HttpClient) {}

  ngOnInit() {}


  login_Confirmation(username:string,password:string){
    let data = {username,password};
    return this.response.get(this.API+'/banco/users/' + username+'/'+ password);
  }

    get_beneficiaries(){
      return this.response.get<beneficiarios[]>(this.API+'/banco/beneficiarios');
    }

   
    get_user(identificacion:string){
      return this.response.get<usuario[]>(this.API+'/banco/users/'+identificacion);
    }


    get_beneficiario(identificacion:string){
      return this.response.get<beneficiarios[]>(this.API+'/banco/beneficiario/'+identificacion);
    }

     get_beneficiaries_by_cliente(identificacion:string){
      return this.response.get<beneficiarios[]>(this.API+'/banco/beneficiarios/' + identificacion);
    }


    get_cuentas_cliente(identificacion:string){
      return this.response.get<cuentas[]>(this.API+'/banco/cuentas');
    }


    insertar_beneficiario(
      NumeroCuenta:string, 
      Identificacion: string,
      Parentesco:number, 
      Porcentaje:number
      )
    { 
      let data = {NumeroCuenta,Identificacion,Parentesco,
      Porcentaje};
      return this.response.post(this.API+'/banco/benefs',data);
    }
  

    eliminar_beneficiario(Identificacion:string, value:number){
      let data= {Identificacion,value};
      return this.response.put(this.API+'/banco/' + Identificacion,data);
    }

    modificar_beneficiario(Identificacion1:string,Nombre:string, Identificacion2:string, Parentesco:number,
      Porcentaje:number,Email:string,Telefono1:number,Telefono2:number){
     let data= {
      Identificacion1, 
      Nombre,
      Identificacion2,
      Parentesco,
      Porcentaje,
      Email,
      Telefono1,
      Telefono2};
      return this.response.put(this.API+'/banco/modificar/' + Identificacion1,data);
    }




}
