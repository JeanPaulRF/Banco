import { Component, OnInit} from '@angular/core';
import { DataService } from '../../data.service';
import { EmiterService } from 'src/app/emiter.service';
import { Router, ActivatedRoute} from '@angular/router';
import { beneficiarios } from 'src/app/modules/beneficiarios';
import Swal from 'sweetalert2';


@Component({
  selector: 'app-beneficiarios',
  templateUrl: './beneficiarios.component.html',
  styleUrls: ['./beneficiarios.component.scss']
})
export class BeneficiariosComponent implements OnInit {

  constructor(private dataService: DataService, private EmiterService:EmiterService, private router:Router, 
    private route: ActivatedRoute){}

    ID:any;
    listBeneficiario: beneficiarios[] = [];

    ngOnInit(){
      this.ID=this.route.snapshot.paramMap.get('id');
      console.log("esta: ", this.ID);
  
   
      this.LoadBenficiaries(this.ID);
    }

  
   goToAdd(){
    this.router.navigate(['/add_benef',this.ID]);
   }

   goToModify(id:string){
    this.router.navigate(['/modify%benef',id]);
   }

   goToDelete(idx:string, nombre:string){
    Swal.fire({
      title: 'Eliminar al beneficiario: '+ nombre +'?',
      showDenyButton: true,
     // showCancelButton: true,
      denyButtonText: `Eliminar`,
      confirmButtonText: 'Cancelar',
    }).then((result) => {
      /* Read more about isConfirmed, isDenied below */
      if (result.isDenied) {
        console.log(idx);
        this.dataService.eliminar_beneficiario(idx,0).toPromise().then((res:any)=>{
          console.log("res", res);
          if(res){
            Swal.fire('Eliminado!', '', 'success')
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


  async LoadBenficiaries(ident:string){ 
    this.dataService.get_beneficiaries_by_cliente(this.ID).
    subscribe(clientes => {
      console.log("two");
      this.listBeneficiario = clientes;
      console.log("BENES: ",this.listBeneficiario);
  }) 
}





}

