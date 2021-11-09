import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcObjetivoComponent } from './ac-objetivo.component';

describe('AcObjetivoComponent', () => {
  let component: AcObjetivoComponent;
  let fixture: ComponentFixture<AcObjetivoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcObjetivoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcObjetivoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
