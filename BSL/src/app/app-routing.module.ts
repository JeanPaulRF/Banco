import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LogginComponent } from './loggin/loggin.component';
import { ClientesComponent } from './clientes/clientes.component';
import { CuentasComponent } from './cuentas/cuentas.component';
import { HomeComponent} from './home/home.component';

const routes: Routes = [
  {
    path:'login',
    component:LogginComponent
  },
  {
    path:'clientes',
    component:ClientesComponent
  },
  {
    path:'cuentas',
    component:CuentasComponent
  },
  {
    path:'home',
    component:HomeComponent
  }


  // { path: 'admin', loadChildren: () => import('./pages/admin/admin.module').then(m => m.AdminModule) },
  // { path: 'home', loadChildren: () => import('./pages/home/home.module').then(m => m.HomeModule) },
  // { path: 'notFound', loadChildren: () => import('./pages/not-found/not-found.module').then(m => m.NotFoundModule) }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
