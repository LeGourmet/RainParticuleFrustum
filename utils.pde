void translate(PVector p){ translate(p.x,p.y,p.z); }
void line(PVector a, PVector b){line(a.x,a.y,a.z,b.x,b.y,b.z);}
void vertex(PVector p){ vertex(p.x,p.y,p.z); }

float getLambda(){ return 4.1f*pow(RAIN_INTENSITY,-0.21f); }

float getNbDropsNeeded(){
  float lambda = getLambda();
  return (RAIN_INTENSITY < 0.01f) ? 0 : floor(dropsBox.getArea() * 8000.f/lambda * exp(-lambda*DROPS_SIZE_MIN));
}
