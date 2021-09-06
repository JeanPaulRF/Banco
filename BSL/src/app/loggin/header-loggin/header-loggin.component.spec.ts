import { ComponentFixture, TestBed } from '@angular/core/testing';

import { HeaderLogginComponent } from './header-loggin.component';

describe('HeaderLogginComponent', () => {
  let component: HeaderLogginComponent;
  let fixture: ComponentFixture<HeaderLogginComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ HeaderLogginComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(HeaderLogginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
