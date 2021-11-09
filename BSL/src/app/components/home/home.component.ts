import { Component, OnInit } from '@angular/core';
import { DataService } from '../../data.service';
import { usuario } from 'src/app/modules/usuario';
import { EmiterService } from 'src/app/emiter.service';
import { Router, ActivatedRoute } from '@angular/router';


@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})


export class HomeComponent implements OnInit {

  listUser: usuario[] = [];
  ID: any;

  nombre: any;
  Identificacion: any;

  admin: any;
  itsAdmin: boolean = false;

  constructor(public dataService: DataService, private EmiterService: EmiterService, private router: Router,
    private route: ActivatedRoute) { }



  ngOnInit() {
    this.ID = this.route.snapshot.paramMap.get('id');
    this.get_user();
  }


  get_user() {
    this.dataService.get_user(this.ID).subscribe(user => {
      // console.log(user);
      this.listUser = user;
      this.nombre = this.listUser[0].Nombre;
      this.Identificacion = this.ID;
      if (this.listUser[0].Administrador == true) {
        this.admin = 1;
        this.itsAdmin = true;
      } else {
        this.admin = 0;
      }
    })
  }


  goToBeneficiaries() {
    this.router.navigate(['/beneficiarios', this.ID, this.admin]);
  }
  goToCuentas() {
    this.router.navigate(['cuentas', this.ID, this.admin]);
  }
  goToClients() {
    this.router.navigate(['/clientes', this.ID]);
  }

}





