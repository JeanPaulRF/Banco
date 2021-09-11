import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { HeaderLogginComponent } from './loggin/header-loggin/header-loggin.component';
import { LogginComponent } from './loggin/loggin.component';
import { BodyLogginComponent } from './loggin/body-loggin/body-loggin.component';
import { FooterLogginComponent } from './loggin/footer-loggin/footer-loggin.component';
import { from } from 'rxjs';
import { ClientesComponent } from './clientes/clientes.component';
import { CuentasComponent } from './cuentas/cuentas.component';

import {MaterialModule} from './material.module';
import { SidebarModule } from './shared/components/sidebar/sidebar.module';
import { HomeComponent } from './home/home.component';
import { NoopAnimationsModule } from '@angular/platform-browser/animations';

import { HttpClientModule } from '@angular/common/http';
import {HttpClient } from '@angular/common/http';


@NgModule({
  declarations: [
    AppComponent,
    HeaderLogginComponent,
    LogginComponent,
    BodyLogginComponent,
    FooterLogginComponent,
    ClientesComponent,
    CuentasComponent,
    FooterLogginComponent,
    HomeComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MaterialModule,
    SidebarModule, 
    HttpClientModule
   
  ],
  providers: [HttpClient],
  bootstrap: [AppComponent]
})
export class AppModule { }
