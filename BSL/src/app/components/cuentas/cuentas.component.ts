import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { Router, ActivatedRoute} from '@angular/router';
import { cuentas } from 'src/app/modules/cuentas';

@Component({
  selector: 'app-cuentas',
  templateUrl: './cuentas.component.html',
  styleUrls: ['./cuentas.component.scss']
})
export class CuentasComponent implements OnInit {

  constructor(public dataService: DataService, private router:Router, 
    private route: ActivatedRoute){}

  listCuentas: cuentas[] = [];
  userId: any;


  ngOnInit(): void {

    this.userId=this.route.snapshot.paramMap.get('id');
    this.listCuentas=[];
    console.log("ESTOS: ", this.userId, this.listCuentas);
    this.LoadAccounts(this.userId);

  }


  async LoadAccounts(ident:string){ 

    this.dataService.get_cuentas_cliente(this.userId).
    subscribe(clientes => {
      this.listCuentas = clientes;
      console.log("Accouts: ",this.listCuentas);
  }) 
}

}
