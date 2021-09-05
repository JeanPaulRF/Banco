import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BodyLogginComponent } from './body-loggin.component';

describe('BodyLogginComponent', () => {
  let component: BodyLogginComponent;
  let fixture: ComponentFixture<BodyLogginComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ BodyLogginComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(BodyLogginComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
