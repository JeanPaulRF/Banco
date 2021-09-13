import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BenefsClientComponent } from './benefs-client.component';

describe('BenefsClientComponent', () => {
  let component: BenefsClientComponent;
  let fixture: ComponentFixture<BenefsClientComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ BenefsClientComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(BenefsClientComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
