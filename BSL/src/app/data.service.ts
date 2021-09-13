import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { users } from './components/home/users.module';
import { client_benefits } from 'src/app/modules/client_benefts';
import { allBenefs } from './components/allBenefs';
@Injectable({
  providedIn: 'root'
})
export class DataService {

  private API = "http://localhost:3002/api";  
  
  constructor(private response: HttpClient) {}

  ngOnInit() {}


  get_beneficiaries(){
    return this.response.get<allBenefs[]>(this.API+'/banco/beneficiarios');
  }

   
     get_beneficiaries_by_cliente(identificacion:string){
      return this.response.get<client_benefits[]>(this.API+'/banco/beneficiarios/' + identificacion);
    }

    // get_ModsAuditorias(idAuditoria:number){
    //   return this.response.get<VerModAuditoria[]>(environment.url_api + '/auditoria/' + idAuditoria);
    // }
  

}
