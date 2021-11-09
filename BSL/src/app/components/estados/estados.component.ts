import { Component, OnInit } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { Router, ActivatedRoute } from '@angular/router';
import { estados } from 'src/app/modules/estados';
import { movimientos } from 'src/app/modules/movimientos';
import { PdfMakeWrapper, Table } from 'pdfmake-wrapper';
import { ITable } from 'pdfmake-wrapper/lib/interfaces';
import * as pdfFonts from "pdfmake/build/vfs_fonts"; // fonts provided for pdfmake


PdfMakeWrapper.setFonts(pdfFonts);

@Component({
  selector: 'app-estados',
  templateUrl: './estados.component.html',
  styleUrls: ['./estados.component.scss']
})
export class EstadosComponent implements OnInit {

  constructor(public dataService: DataService, private router: Router,
    private route: ActivatedRoute) { }
  

  hola=123123;

  listEstados:estados[] = [];
  
  listMovimientos:movimientos[]=[];
  cuenta:any;

  ngOnInit() {

    this.cuenta = this.route.snapshot.paramMap.get('accountNumber');
  //  this.admin = this.route.snapshot.paramMap.get('admin');


    this.LoadEstados();
  }



  async goToMoves(){
  const pdf = new PdfMakeWrapper();
  pdf.add("Movimientos de la cuenta: " + this.JOTA);
  pdf.add(this.createTable("1234"));

  pdf.create().open();

  }
  JOTA= "110010101";
  createTable(hi:string):ITable{
    return new Table([
      ['Fecha','Compra','Venta','Tipo moneda movimiento', "Monto Movimiento", "Tipo Moneda Cuenta", "Monto Cuenta", "Descripcion","Nuevo Saldo"],
      ["null", "null", "null", "null","null","null","null","null","null"]
    ]).layout({
      fillColor:(rowIndex:any, node:any, columnIndex:any)=>{
        return rowIndex === 0 ? '#c6c6c6' : '';
      }
    })
    .end;

  }


  async LoadEstados() {
    //if (this.admin == 0) {
      this.dataService.get_estados(this.cuenta).
        subscribe(states => {
          this.listEstados = states;
          console.log("Estados: ", this.listEstados);
        })
    //}
    // else {
    //   this.itsAdmin = true;
    //   this.dataService.get_cuentas().
    //     subscribe(clientes => {
    //       this.listCuentas = clientes;
    //       console.log("Accouts: ", this.listCuentas);
    //     })

    // }
  }

}



