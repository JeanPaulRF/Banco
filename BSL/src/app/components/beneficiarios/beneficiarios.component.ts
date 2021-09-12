import { Component, OnInit } from '@angular/core';
import { DataService } from '../../data.service';
import { users } from '../home/users.module';

@Component({
  selector: 'app-beneficiarios',
  templateUrl: './beneficiarios.component.html',
  styleUrls: ['./beneficiarios.component.scss']
})
export class BeneficiariosComponent implements OnInit {

  listUsers: users[] = [];


  constructor(private dataService: DataService) { }

  ngOnInit(): void {
    // this.get_users_prueba();

      this.fetchElementos();
  }

  /**
 * @method get that show all Encuestados
 */
//  get_users_prueba(){
//   this.dataService.get_users_prueba().toPromise().then((res:any)=>{
//   this.listUsers= res;
//   }, (error)=>{
//   alert(error.message);
//   })
//   }

  fetchElementos(){
    this.dataService.get_users_prueba()
    .subscribe(clientes => {
      this.listUsers = clientes;
    })
  }


}
