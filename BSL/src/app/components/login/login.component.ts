import { Component, OnInit, Injectable } from '@angular/core';
import { DataService } from 'src/app/data.service';
import { FormBuilder } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { EmiterService } from 'src/app/emiter.service';
import Swal from 'sweetalert2'


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  constructor(public dataService: DataService, private formBuilder: FormBuilder, private router: Router,
    private EmiterService: EmiterService, private route: ActivatedRoute) { }
  username: any;
  password: any;
  identification: any;
  confirmation: any;


  registerForm = this.formBuilder.group({
    username: [""],
    password: [""]
  });


  ngOnInit(): void {

  }



  log() {
    console.log(this.registerForm);
    this.username = (this.registerForm.value.username);
    this.password = (this.registerForm.value.password);

    if (this.username == "" || this.password == "") {
      Swal.fire({
        icon: 'warning',
        text: 'Debes completar ambos campos.',
      })
    }
    else {
      this.dataService.login_Confirmation(
        this.username,
        this.password
      )
        .subscribe(cliente => {
          this.confirmation = cliente;
          if (this.confirmation[0].Resultado == "1") {
            // console.log(this.confirmation)
            this.identification = this.confirmation[0].userId;
            //console.log(this.identification)

            this.router.navigate(['/home', this.identification]);
          } else {
            Swal.fire({
              icon: 'error',
              title: 'Oops...',
              text: 'No estás registrado!',
            })
          }

        })

    }


  }


  async login_Confirmation(user: string, pass: string) {
    this.dataService.login_Confirmation(user, pass).
      toPromise().
      then((res: any) => {
        if (res[0].code == 201) {
          Swal.fire(`Welcome`);
        }
      }, (error) => {
        alert(error.message);
      });
  }



}

