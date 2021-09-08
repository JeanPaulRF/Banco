import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LogginComponent } from './loggin/loggin.component';
import { HomeComponent } from './home/home.component';
import { ClientesComponent } from './clientes/clientes.component';
import { CuentasComponent } from './cuentas/cuentas.component';

const routes: Routes = [
  {
    path:'loggin',
    component:LogginComponent
  },
  {
    path:'home',
    component:HomeComponent
  },
  {
    path:'clientes',
    component:ClientesComponent
  },
  {
    path:'cuentas',
    component:CuentasComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
