import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import {MatCardModule} from '@angular/material/card';
import {MatTabsModule} from '@angular/material/tabs';
import {MatInputModule} from '@angular/material/input';
import {MatToolbarModule} from '@angular/material/toolbar';

import { HeaderLogginComponent } from './loggin/header-loggin/header-loggin.component';
import { LogginComponent } from './loggin/loggin.component';
import { BodyLogginComponent } from './loggin/body-loggin/body-loggin.component';
import { FooterLogginComponent } from './loggin/footer-loggin/footer-loggin.component';
import { from } from 'rxjs';

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
    MatCardModule,
    MatTabsModule,
    MatInputModule,
    MatToolbarModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
