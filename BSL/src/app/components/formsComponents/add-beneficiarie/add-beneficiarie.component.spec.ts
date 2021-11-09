import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AddBeneficiarieComponent } from './add-beneficiarie.component';

describe('AddBeneficiarieComponent', () => {
  let component: AddBeneficiarieComponent;
  let fixture: ComponentFixture<AddBeneficiarieComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AddBeneficiarieComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AddBeneficiarieComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
