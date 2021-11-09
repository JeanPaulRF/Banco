import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder } from '@angular/forms';
import { cuentas } from 'src/app/modules/cuentas';

import Swal from 'sweetalert2'


@Component({
  selector: 'app-add-beneficiarie',
  templateUrl: './add-beneficiarie.component.html',
  styleUrls: ['./add-beneficiarie.component.scss']
})
export class AddBeneficiarieComponent implements OnInit {

  constructor(public dataService: DataService, private router: Router,
    private route: ActivatedRoute, private formBuilder: FormBuilder
  ) { }

  account: any;
  porcentaje: any;
  parent: any;
  idBenef: any;


  userId: any;
  listCuentas: cuentas[] = [];

  registerForm = this.formBuilder.group({

    identificacion: [""],
    porcent: [""],
  });




  ngOnInit() {

    this.userId = this.route.snapshot.paramMap.get('id');
    this.listCuentas = [];
    console.log("ESTOS: ", this.userId, this.listCuentas);
    this.LoadAccounts(this.userId);
  }






  async validacionBotton() {
    this.idBenef = (this.registerForm.value.identificacion);
    this.porcentaje = (this.registerForm.value.porcent);
    console.log(
      this.idBenef, this.account, this.parent, this.porcentaje);
    //  console.log(this.registerForm);
    this.insertar_beneficiario();
  }



  async LoadAccounts(ident: string) {

    this.dataService.get_cuentas_cliente(this.userId).
      subscribe(clientes => {
        this.listCuentas = clientes;
        console.log("Accouts: ", this.listCuentas);
      })
  }


  async insertar_beneficiario() {
    this.dataService.insertar_beneficiario(
      this.account,
      this.idBenef,
      parseInt(this.parent),
      this.porcentaje).toPromise().
      then((res: any) => {
       
        if (res != null) {
          Swal.fire('¡Beneficiario agregado!', '', 'success')
          this.router.navigate(['/beneficiarios', this.userId, 0]);
        }
      }, (error) => {
        Swal.fire('No se ha podido agregar', '', 'info')
        this.router.navigate(['/beneficiarios', this.userId, 0]);
      });
  }


}
