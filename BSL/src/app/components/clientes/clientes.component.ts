import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { clientes } from 'src/app/modules/clientes';
@Component({
  selector: 'app-clientes',
  templateUrl: './clientes.component.html',
  styleUrls: ['./clientes.component.scss']
})
export class ClientesComponent implements OnInit {

  constructor(private dataService: DataService) { }

  listClientes: clientes[] = [];
  ngOnInit() {
    this.LoadClientes();
  }


  async LoadClientes() {
    this.dataService.get_clientes().
      subscribe(clients => {
        this.listClientes = clients;
      })
  }
}







