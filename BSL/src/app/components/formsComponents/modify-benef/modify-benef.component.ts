import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { beneficiarios } from 'src/app/modules/beneficiarios';
import { Router, ActivatedRoute } from '@angular/router';
import { FormBuilder } from '@angular/forms';
import Swal from 'sweetalert2';
@Component({
  selector: 'app-modify-benef',
  templateUrl: './modify-benef.component.html',
  styleUrls: ['./modify-benef.component.scss']
})
export class ModifyBenefComponent implements OnInit {

  constructor(private dataService: DataService, private router: Router,
    private route: ActivatedRoute, private formBuilder: FormBuilder) { }

  IDu: any;

  beneficiario: beneficiarios[] = [];
  cuenta: any;
  Nombre: any;
  NumeroCuenta: any;
  TipoIdentificacion: any;
  Identificacion: any;
  Parentesco: any;
  Porcentaje: any;
  FechaNacimiento: any;
  dia: any;
  mes: any;
  year: any;
  Email: any;
  Telefono1: any;
  Telefono2: any;
  id: any;

  oldId: any;

  registerForm = this.formBuilder.group({
    name: [""],
    porcent: [""],
    id: [""],
    dia: [""],
    mes: [""],
    año: [""],
    correo: [""],
    phone1: [""],
    phone2: [""]

  });



  ngOnInit(): void {
    this.id = this.route.snapshot.paramMap.get('id');
    this.IDu = this.route.snapshot.paramMap.get('user');
    this.load_beneficiario(this.id);
  }

  validation() {

  }

  async load_beneficiario(ident: string) {

    this.dataService.get_beneficiario(ident).
      subscribe(clientes => {
        this.beneficiario = clientes;

        this.Nombre = this.beneficiario[0].Nombre;
        this.cuenta = this.beneficiario[0].NumeroCuenta;
        this.FechaNacimiento = this.beneficiario[0].FechaDeNacimiento;
        this.Email = this.beneficiario[0].Email;
        this.Identificacion = this.beneficiario[0].Identificacion;
        this.oldId = this.beneficiario[0].Identificacion;
        this.Parentesco = this.beneficiario[0].Parentesco;
        this.Porcentaje = this.beneficiario[0].Porcentaje;
        this.Telefono1 = this.beneficiario[0].Telefono1;
        this.Telefono2 = this.beneficiario[0].Telefono2;

        this.dia = this.FechaNacimiento.split("-", 3);
        this.year = this.dia[0];
        this.mes = this.dia[1];
        this.dia = this.dia[2];
        console.log(this.dia, this.mes, this.year);
      })
  }

  validationBotton() {

    this.Nombre = (this.registerForm.value.name);
    this.Identificacion = (this.registerForm.value.id);
    this.Porcentaje = (this.registerForm.value.porcent);
    this.dia = (this.registerForm.value.dia);
    this.mes = (this.registerForm.value.mes);
    this.year = (this.registerForm.value.año);
    this.Email = (this.registerForm.value.correo);
    this.Telefono1 = this.registerForm.value.phone1;
    this.Telefono2 = this.registerForm.value.phone2;

    this.FechaNacimiento = this.year + "-" + this.mes + "-" + this.dia;

    console.log("Nac: ", this.FechaNacimiento);
    if (this.Nombre == "") {
      this.Nombre = this.beneficiario[0].Nombre;
    }
    if (this.FechaNacimiento == null || this.FechaNacimiento == "--") {
      this.FechaNacimiento = this.beneficiario[0].FechaDeNacimiento;
    }
    if (this.Email == "") {
      this.Email = this.beneficiario[0].Email;
    }
    if (this.Identificacion == "") {
      this.Identificacion = this.beneficiario[0].Identificacion;
    }
    if (this.Parentesco == "") {
      this.Parentesco = this.beneficiario[0].Parentesco;
    }
    if (this.Porcentaje == "") {
      this.Porcentaje = this.beneficiario[0].Porcentaje;
    }
    if (this.Telefono1 == "") {
      this.Telefono1 = this.beneficiario[0].Telefono1;
    }
    if (this.Telefono2 == "") {
      this.Telefono2 = this.beneficiario[0].Telefono2;
    }

    console.log("Datos: ",
      this.Nombre,
      this.cuenta,
      this.FechaNacimiento,
      this.Email,
      this.Identificacion,
      this.Parentesco,
      this.Porcentaje,
      this.Telefono1,
      this.Telefono2
    )
    this.modificar_beneficiaro();
  }


  modificar_beneficiaro() {
    Swal.fire({
      title: '¿Desea modificar este beneficiario?',
      showDenyButton: true,
      denyButtonText: `Modificar`,
      confirmButtonText: 'Cancelar',
    }).then((result) => {
      if (result.isDenied) {
        console.log(this.oldId);
        this.dataService.modificar_beneficiario(
          this.oldId,
          this.Nombre,
          this.Identificacion,
          parseInt(this.Parentesco),
          parseInt(this.Porcentaje),
          this.FechaNacimiento,
          this.Email,
          parseInt(this.Telefono1),
          parseInt(this.Telefono2)
        ).toPromise().then((res: any) => {
          console.log("res", res);

          if (res == null) {
            Swal.fire('Modificado!', '', 'success')
            this.router.navigate(['/beneficiarios', this.IDu, 0]);
          } else {
            Swal.fire('Algo a salido mal', '', 'info')
            this.router.navigate(['/beneficiarios', this.IDu, 0]);
          }
        }, (error) => {
          //alert(error.message);
          Swal.fire('No se ha podido modificar', '', 'info')
          this.router.navigate(['/beneficiarios', this.IDu, 0]);
        });
      }
    })
  }




}



