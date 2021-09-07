import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';

import { HeaderLogginComponent } from './loggin/header-loggin/header-loggin.component';
import { LogginComponent } from './loggin/loggin.component';
import { BodyLogginComponent } from './loggin/body-loggin/body-loggin.component';
import { FooterLogginComponent } from './loggin/footer-loggin/footer-loggin.component';

import {MaterialModule} from './material.module';
import { SidebarModule } from './shared/components/sidebar/sidebar.module';

@NgModule({
  declarations: [
    AppComponent,
    HeaderLogginComponent,
    LogginComponent,
    BodyLogginComponent,
    FooterLogginComponent
  
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    BrowserAnimationsModule,
    MaterialModule,
    SidebarModule
   
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
