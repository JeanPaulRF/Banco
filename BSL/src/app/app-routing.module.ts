import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { ClientesComponent } from './components/clientes/clientes.component';
import { CuentasComponent } from './components/cuentas/cuentas.component';
import { HomeComponent } from './components/home/home.component';
import { BeneficiariosComponent } from './components/beneficiarios/beneficiarios.component';
import { AddBeneficiarieComponent } from 'src/app/components/formsComponents/add-beneficiarie/add-beneficiarie.component';
import { ModifyBenefComponent } from './components/formsComponents/modify-benef/modify-benef.component';
import { AddObjetivoComponent } from './components/formsComponents/add.objetivo/add.objetivo.component';
import { EstadosComponent } from './components/estados/estados.component';
const routes: Routes = [

  {

    path: '',

    component: LoginComponent
  },
  {
    path: 'login',
    component: LoginComponent
  },
  {
    path: 'clientes/:id',
    component: ClientesComponent
  },
  {
    path: 'cuentas/:id/:admin',
    component: CuentasComponent
  },
  {
    path: 'home',
    component: HomeComponent
  },
  {
    path: 'home/:id',
    component: HomeComponent
  },
  {
    path: 'beneficiarios/:id/:admin',
    component: BeneficiariosComponent
  },
  {
    path: 'add_benef/:id',
    component: AddBeneficiarieComponent
  },
  {
    path: 'modify%benef/:id/:user',
    component: ModifyBenefComponent
  },

  {
    path:'addObj/:id/:account',
    component:AddObjetivoComponent
  },
  
  {
    path: 'accounts?/3stad0s/:accountNumber',
    component:EstadosComponent
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
