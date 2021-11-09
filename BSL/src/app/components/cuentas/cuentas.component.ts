import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { cuentas } from 'src/app/modules/cuentas';

@Component({
  selector: 'app-cuentas',
  templateUrl: './cuentas.component.html',
  styleUrls: ['./cuentas.component.scss']
})
export class CuentasComponent implements OnInit {

  constructor(public dataService: DataService, private router: Router,
    private route: ActivatedRoute) { }

  listCuentas: cuentas[] = [];
  userId: any;
  admin: any;
  itsAdmin: boolean = false;

  ngOnInit(): void {

    this.userId = this.route.snapshot.paramMap.get('id');
    this.admin = this.route.snapshot.paramMap.get('admin');
    this.listCuentas = [];
    this.LoadAccounts(this.userId);

  }


  goToBeneficiaries() {
    this.router.navigate(['/beneficiarios', this.userId, this.admin]);
  }
  goToClients() {
    this.router.navigate(['clientes', this.userId]);
  }
  goToHome() {
    this.router.navigate(['/home', this.userId]);
  }

  goToAddObj(account:string){
    this.router.navigate(['/addObj', this.userId,account]);
  }

  goToEstados(account:string){
    this.router.navigate(['/accounts?/3stad0s',account]);
  }

  async LoadAccounts(ident: string) {
    if (this.admin == 0) {
      this.dataService.get_cuentas_cliente(this.userId).
        subscribe(clientes => {
          this.listCuentas = clientes;
          console.log("Accouts: ", this.listCuentas);
        })
    }
    else {
      this.itsAdmin = true;
      this.dataService.get_cuentas().
        subscribe(clientes => {
          this.listCuentas = clientes;
          console.log("Accouts: ", this.listCuentas);
        })

    }
  }

}
