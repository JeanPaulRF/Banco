import { Component, OnInit } from '@angular/core';
import { DataService } from '../../data.service';
import { EmiterService } from 'src/app/emiter.service';
import { Router, ActivatedRoute } from '@angular/router';
import { beneficiarios } from 'src/app/modules/beneficiarios';
import Swal from 'sweetalert2';
import { NgForOf } from '@angular/common';


@Component({
  selector: 'app-beneficiarios',
  templateUrl: './beneficiarios.component.html',
  styleUrls: ['./beneficiarios.component.scss']
})
export class BeneficiariosComponent implements OnInit {

  constructor(private dataService: DataService, private EmiterService: EmiterService, private router: Router,
    private route: ActivatedRoute) { }

  ID: any;
  admin: any;
  listBeneficiario: beneficiarios[] = [];
  suma: number = 0;
  itsAdmin: boolean = false;

  ngOnInit() {
    this.ID = this.route.snapshot.paramMap.get('id');
    this.admin = this.route.snapshot.paramMap.get('admin');
    this.LoadBenficiaries(this.ID);
  }


  goToAdd() {
    if (this.admin == 0) {
      this.dataService.get_beneficiaries_by_cliente(this.ID).
        subscribe(clientes => {
          console.log("two");
          this.listBeneficiario = clientes;
          console.log("BENES: ", this.listBeneficiario);
          if (this.listBeneficiario.length < 3) {
            console.log("TODO OK", this.listBeneficiario.length);
            this.router.navigate(['/add_benef', this.ID])
          }
          else {
            Swal.fire({
              icon: 'error',
              title: 'Oops...',
              text: 'Haz alcanzado el limite de beneficiarios.'
            })
          }
        })
    }
    else {
      Swal.fire('Disponible proximamente!')
    }
  }

  goToModify(id: string) {
    if (this.admin == 0) {
      this.router.navigate(['/modify%benef', id, this.ID]);
    }
    else {
      Swal.fire('Disponible proximamente!')
    }
  }

  goToDelete(idx: string, nombre: string) {
    if (this.admin == 0) {
      Swal.fire({
        title: 'Eliminar al beneficiario: ' + nombre + '?',
        showDenyButton: true,
        denyButtonText: `Eliminar`,
        confirmButtonText: 'Cancelar',
      }).then((result) => {
        if (result.isDenied) {
          console.log(idx);
          this.dataService.eliminar_beneficiario(idx, 0).toPromise().then((res: any) => {
            console.log("res", res);
            if (res) {
              Swal.fire('Eliminado!', '', 'success')
              this.ngOnInit();
            } else {
              Swal.fire('Algo a salido mal', '', 'info')
            }
          }, (error) => {
            Swal.fire('No se ha podido eliminar', '', 'info')
          });
        }
      })
    }
    else {
      Swal.fire('Disponible proximamente!')
    }
  }

  goToCuentas() {
    this.router.navigate(['cuentas', this.ID, this.admin]);
  }

  goToClients() {
    this.router.navigate(['clientes', this.ID]);
  }

  goToHome() {
    this.router.navigate(['/home', this.ID]);
  }

  async LoadBenficiaries(ident: string) {
    if (this.admin == 0) {
      this.dataService.get_beneficiaries_by_cliente(this.ID).
        subscribe(clientes => {
          this.listBeneficiario = clientes;

          for (let beneficiario of this.listBeneficiario) {
            this.suma = this.suma + beneficiario.Porcentaje;
          }

          if (this.suma > 100) {
            Swal.fire({
              icon: 'warning',
              title: 'Revisa el porcentaje repartido',
              showConfirmButton: false,
              timer: 2000
            })

          }
        })

    } else {
      this.itsAdmin = true;
      this.dataService.get_beneficiaries().
        subscribe(clientes => {
          this.listBeneficiario = clientes;
        })
    }
  }

}

