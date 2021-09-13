import { Component, OnInit} from '@angular/core';
import { DataService } from '../../data.service';
import { client_benefits } from 'src/app/modules/client_benefts';
import { EmiterService } from 'src/app/emiter.service';
import { HomeComponent } from '../home/home.component';
//import Swal from 'sweetalert2'


@Component({
  selector: 'app-beneficiarios',
  templateUrl: './beneficiarios.component.html',
  styleUrls: ['./beneficiarios.component.scss']
})
export class BeneficiariosComponent extends HomeComponent {

  // listBenets: client_benefits[] = [];

  // constructor(private dataService: DataService,private EmiterService:EmiterService) { }

  // ngOnInit(): void {
  //   this.EmiterService.envioBeneficiarios.subscribe(data => {
  //     this.listBenets.push(data);
  //   })
  //   console.log(this.listBenets);
  // }

}


