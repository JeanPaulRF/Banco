import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ModifyBenefComponent } from './modify-benef.component';

describe('ModifyBenefComponent', () => {
  let component: ModifyBenefComponent;
  let fixture: ComponentFixture<ModifyBenefComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ ModifyBenefComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(ModifyBenefComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
