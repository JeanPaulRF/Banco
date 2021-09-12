import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { users } from './components/home/users.module';

@Injectable({
  providedIn: 'root'
})
export class DataService {

  private API = "http://localhost:3002/api";  
  
  constructor(private response: HttpClient) {}

  ngOnInit() {}

  /**
   * @method get all users
   */
  get_users_prueba(){
    return this.response.get<users[]>(this.API+'/banco');
  }
  
}
