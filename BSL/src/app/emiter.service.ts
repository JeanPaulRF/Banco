import { Injectable,Output,EventEmitter } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class EmiterService {

  constructor() { }

  @Output() log_Home_Conexion: EventEmitter<any>= new EventEmitter();
}
