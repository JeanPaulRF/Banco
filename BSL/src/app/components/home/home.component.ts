import { Component, OnInit} from '@angular/core';
import { DataService } from '../../data.service';
import { users } from './users.module';
import { client_benefits } from 'src/app/modules/client_benefts';
import { EmiterService } from 'src/app/emiter.service';
import { allBenefs } from '../allBenefs';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})


export class HomeComponent implements OnInit {

  listUsers: users[] = [];

  listBeneficiario: client_benefits[] = [];
  listaAllbenefs: allBenefs[] = []; 
  ID:string = '117370445';
  constructor(private dataService: DataService, private EmiterService:EmiterService) { }

  ngOnInit() {
    this.fetchElementos();
    this.LoadBenficiaries();
  }

 

  fetchElementos(){
    this.dataService.get_beneficiaries()
    .subscribe(benefs => {
      this.listaAllbenefs = benefs;
      console.log(this.listaAllbenefs);
    })
  }

  async LoadBenficiaries(){ 
    this.dataService.get_beneficiaries_by_cliente(this.ID).
    subscribe(clientes => {
      this.listBeneficiario = clientes;
      console.log(this.listBeneficiario);
      
  }) 

  this.EmiterService.envioBeneficiarios.emit({data:this.listBeneficiario});
 }

}


