import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder } from '@angular/forms';
import { cuentas } from 'src/app/modules/cuentas';

import Swal from 'sweetalert2'



@Component({
  selector: 'app-add.objetivo',
  templateUrl: './add.objetivo.component.html',
  styleUrls: ['./add.objetivo.component.scss']
})
export class AddObjetivoComponent implements OnInit {
  constructor(public dataService: DataService, private router: Router,
    private route: ActivatedRoute, private formBuilder: FormBuilder
  ) { }



  account: any;
  userId: any;

  //-------------- Endings vars -----------
  
  dia:any;
  mes:any;
  año: any;
  dia2:any;
  mes2:any;
  año2:any;
  costo:any;
  interes:any;
  saldo: any;
  description: any;

  fechaInicial: any;
  fechaFinal: any;

  
  registerForm = this.formBuilder.group({

   // @NumeroCuenta varchar(32),
    dia: [""],
    mes: [""],
    año: [""],
    dia2: [""],
    mes2: [""],
    año2: [""],
    costo: [""],
    interes: [""],
    saldo: [""],
    description: [""]
  });



  ngOnInit() {
    this.userId = this.route.snapshot.paramMap.get('id');
    this.account = this.route.snapshot.paramMap.get('account');

    console.log("DATOS: ", this.userId, this.account);
   

  }


  validationBotton(){

    this.dia = (this.registerForm.value.dia);
    this.mes = (this.registerForm.value.mes);
    this.año = (this.registerForm.value.año);

    this.dia2 = (this.registerForm.value.dia2);
    this.mes2= (this.registerForm.value.mes2);
    this.año2 = (this.registerForm.value.año2);

    this.interes = (this.registerForm.value.interes);
    this.costo = (this.registerForm.value.costo);
    this.saldo = (this.registerForm.value.saldo);

    this.fechaInicial = this.año + "-" + this.mes + "-" + this.dia;
    this.fechaFinal = this.año2 + "-" + this.mes2 + "-" + this.dia2;

    this.description =(this.registerForm.value.description);


    this.insertarAcObj();
  }



  async insertarAcObj() {


    console.log(
      "data: ",
      this.account, 
      this.fechaInicial,
      this.fechaFinal,
      this.interes,
      this.costo,
      this.saldo,
      this.description
    );


    this.dataService.insertar_objetivo(
      this.account,
      this.fechaInicial,
      this.fechaFinal,
      this.costo,
      this.description,
      this.saldo,
      this.interes,
      
      ).toPromise().
      then((res: any) => {
       console.log("res: ", res);
        if (res != null) {
          Swal.fire('¡Objetivo agregado!', '', 'success')
          this.router.navigate(['/beneficiarios', this.userId, 0]);
        }
      }, (error) => {
        Swal.fire('No se ha podido agregar', '', 'info')
        this.router.navigate(['/beneficiarios', this.userId, 0]);
      });
  }


}
