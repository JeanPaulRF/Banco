import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { ClientesComponent } from './components/clientes/clientes.component';
import { CuentasComponent } from './components/cuentas/cuentas.component';
import { HomeComponent} from './components/home/home.component';
import { BeneficiariosComponent } from './components/beneficiarios/beneficiarios.component';

const routes: Routes = [
  {
    path:'login',
    component:LoginComponent
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
  },
  {
    path:  'beneficiarios',
    component:BeneficiariosComponent
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
