import { Injectable,EventEmitter,Output } from '@angular/core';

@Injectable({
    providedIn: 'root'
  })

  export class EmiterService{
     @Output() envioBeneficiarios:EventEmitter<any> = new EventEmitter();
      constructor(){}
  }