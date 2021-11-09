import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Add.ObjetivoComponent } from './add.objetivo.component';

describe('Add.ObjetivoComponent', () => {
  let component: Add.ObjetivoComponent;
  let fixture: ComponentFixture<Add.ObjetivoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ Add.ObjetivoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(Add.ObjetivoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
