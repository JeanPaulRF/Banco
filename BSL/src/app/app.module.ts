import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';


import { ClientesComponent } from './components/clientes/clientes.component';
import { CuentasComponent } from './components/cuentas/cuentas.component';

import {MaterialModule} from './material.module';

import { HomeComponent } from './components/home/home.component';
//import { NoopAnimationsModule } from '@angular/platform-browser/animations';

import { HttpClientModule } from '@angular/common/http';
import {HttpClient } from '@angular/common/http';
import { LoginComponent } from './components/login/login.component';
import { BeneficiariosComponent } from './components/beneficiarios/beneficiarios.component';
import { AddBeneficiarieComponent } from 'src/app/components/formsComponents/add-beneficiarie/add-beneficiarie.component';
import { ModifyBenefComponent } from './components/formsComponents/modify-benef/modify-benef.component';

@NgModule({
  declarations: [
    AppComponent,
    ClientesComponent,
    CuentasComponent,
    HomeComponent,
    LoginComponent,
    BeneficiariosComponent,
    AddBeneficiarieComponent,
    ModifyBenefComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MaterialModule,
    HttpClientModule
   
  ],
  providers: [HttpClient],
  bootstrap: [AppComponent]
})
export class AppModule { }
