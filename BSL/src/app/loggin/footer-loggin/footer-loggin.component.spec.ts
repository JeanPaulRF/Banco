import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FooterLogginComponent } from './footer-loggin.component';

describe('FooterLogginComponent', () => {
  let component: FooterLogginComponent;
  let fixture: ComponentFixture<FooterLogginComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ FooterLogginComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(FooterLogginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
