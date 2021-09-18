import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service'; 
import { beneficiarios } from 'src/app/modules/beneficiarios';
import { Router, ActivatedRoute} from '@angular/router';
import { FormBuilder } from '@angular/forms';
import Swal from 'sweetalert2';
@Component({
  selector: 'app-modify-benef',
  templateUrl: './modify-benef.component.html',
  styleUrls: ['./modify-benef.component.scss']
})
export class ModifyBenefComponent implements OnInit {

  constructor(private dataService: DataService,private router:Router, 
    private route: ActivatedRoute,private formBuilder:FormBuilder) { }

  beneficiario: beneficiarios[] = [];
  cuenta:any;
  Nombre:any;
	NumeroCuenta:any;
	TipoIdentificacion:any;
	Identificacion:any;
	Parentesco:any; 
	Porcentaje:any;
	FechaNacimiento:any;
  Dia:any;
  mes:any;
  año:any;
	Email:any;
	Telefono1:any;
	Telefono2:any;
  id:any;
  
  oldId:any;

  registerForm = this.formBuilder.group({
      
    name: [""],
    porcent: [""],
    id:[""],
    dia:[""],
    mes:[""],
    año:[""],
    correo:[""],
    phone1:[""],
    phone2:[""]
    
  });



  ngOnInit(): void {
    this.id=this.route.snapshot.paramMap.get('id');
    this.load_beneficiario(this.id);
  }

  validation(){

  }

  async load_beneficiario(ident:string){ 

    this.dataService.get_beneficiario(ident).
    subscribe(clientes => {
      this.beneficiario = clientes;
      console.log("Accouts1: ",this.beneficiario[0].Nombre);
      console.log("Accouts: ",this.beneficiario)
   

  this.Nombre=this.beneficiario[0].Nombre;
  this.cuenta=this.beneficiario[0].NumeroCuenta;
  this.FechaNacimiento=this.beneficiario[0].FechaDeNacimiento;
  this.Email=this.beneficiario[0].Email;
  this.Identificacion = this.beneficiario[0].Identificacion;
  this.oldId = this.beneficiario[0].Identificacion;
  this.Parentesco = this.beneficiario[0].Parentesco;
  this.Porcentaje = this.beneficiario[0].Porcentaje;
  this.Telefono1 = this.beneficiario[0].Telefono1;
  this.Telefono2 = this.beneficiario[0].Telefono2;
 
  this.Dia  = this.FechaNacimiento.split("-", 3); 
  this.año= this.Dia[0];
  this.mes = this.Dia[1];
  this.Dia= this.Dia[2];
  console.log(this.Dia,this.mes,this.año);
})
}

 validationBotton(){

  this.Nombre=(this.registerForm.value.name);
  this.Identificacion=(this.registerForm.value.id);
  this.Porcentaje=(this.registerForm.value.porcent);
  this.Dia = (this.registerForm.value.dia);
  this.mes = (this.registerForm.value.mes);
  this.año = (this.registerForm.value.año);
  this.Email=(this.registerForm.value.correo);
  this.Telefono1 = this.registerForm.value.phone1;
  this.Telefono2 = this.registerForm.value.phone2;

  this.FechaNacimiento= this.año+"-"+this.mes+"-"+this.Dia;
  console.log("Nac: ",this.FechaNacimiento);
   if (this.Nombre==""){
     this.Nombre=this.beneficiario[0].Nombre;
   }
  //  if (this.cuenta==null){
  //   this.cuenta=this.beneficiario[0].NumeroCuenta;
  // }
  if (this.Email==""){
    this.Email=this.beneficiario[0].Email;
  }
  if (this.Identificacion==""){
    this.Identificacion=this.beneficiario[0].Identificacion;
  }
  if (this.Parentesco==""){
    this.Parentesco=this.beneficiario[0].Parentesco;
  }
  if (this.Porcentaje==""){
    this.Porcentaje=this.beneficiario[0].Porcentaje;
  }
  if (this.Telefono1==""){
    this.Telefono1=this.beneficiario[0].Telefono1;
  }
  if (this.Telefono2==""){
    this.Telefono2=this.beneficiario[0].Telefono2;
  }

   console.log(  "Datos: ",
    this.Nombre,
    this.cuenta,
    this.FechaNacimiento,
    this.Email,
    this.Identificacion ,
    this.Parentesco ,
    this.Porcentaje ,
    this.Telefono1 ,
    this.Telefono2 
   )
   this.modificar_beneficiaro();
}


modificar_beneficiaro(){
  Swal.fire({
    title: '¿Desea modificar este beneficiario?',
    showDenyButton: true,
   // showCancelButton: true,
    denyButtonText: `Modificar`,
    confirmButtonText: 'Cancelar',
  }).then((result) => {
    /* Read more about isConfirmed, isDenied below */
    if (result.isDenied) {
     // console.log(idx);
      this.dataService.modificar_beneficiario(
        this.oldId,
        this.Nombre,
        this.Identificacion,
        parseInt(this.Parentesco) ,
        this.Porcentaje ,
        this.Email,
        parseInt(this.Telefono1) ,
        parseInt(this.Telefono2)).toPromise().then((res:any)=>{
        console.log("res", res);
        
        if(res==null){
          Swal.fire('Modificado!', '', 'success')
        }else{
          Swal.fire('Algo a salido mal', '', 'info')
        }
      }, (error)=>{
        //alert(error.message);
        Swal.fire('No se ha podido eliminar', '', 'info')
      });
    }
  })
 }




}



