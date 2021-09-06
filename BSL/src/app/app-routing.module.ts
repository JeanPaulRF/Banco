import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LogginComponent } from './loggin/loggin.component';
import { HomeComponent } from './home/home.component';

const routes: Routes = [
  {path:'loggin',
  component:LogginComponent
  },
  {
    path:'home',
    component:HomeComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
