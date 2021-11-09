import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { clientes } from 'src/app/modules/clientes';
@Component({
  selector: 'app-clientes',
  templateUrl: './clientes.component.html',
  styleUrls: ['./clientes.component.scss']
})
export class ClientesComponent implements OnInit {

  constructor(private dataService: DataService, private router: Router,
    private route: ActivatedRoute) { }

  listClientes: clientes[] = [];
  id: any;
  ngOnInit() {
    this.id = this.route.snapshot.paramMap.get('id');
    this.LoadClientes();
  }


  goToBeneficiaries() {
    this.router.navigate(['/beneficiarios', this.id, 1]);
  }

  goToCuentas() {
    this.router.navigate(['cuentas', this.id, 1]);
  }

  goToHome() {
    this.router.navigate(['/home', this.id]);
  }

  async LoadClientes() {
    this.dataService.get_clientes().
      subscribe(clients => {
        this.listClientes = clients;
      })
  }
}







