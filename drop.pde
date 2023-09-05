public class Drop{
  private PVector _positionOld;
  private PVector _position;
  private float   _size;
  private int     _state;      // -1 dead   ;   1 alive   ;   0 dead but should be diplay during this frame
  
  public Drop(){
    this._positionOld = new PVector(0.f,0.f,0.f);
    this._position    = new PVector(0.f,0.f,0.f);
    this._size        = 0.f;
    this._state       = -1;
  }
  
  public void display(){
    if(_state<0) return;
    if(_state==0) _state = -1;
    
     strokeWeight(_size);
     line(_position,_positionOld);
  }
  
  public void recycle(PVector p_cameraMovement){
    if(_state==0 || _state==1) return;
    
    _state = 1;
    _size = DROPS_SIZE_MIN - max(DROPS_SIZE_MIN-DROPS_SIZE_MAX, log(random(0,1))/getLambda());
    
    PVector V0_sq     = PVector.add(PVector.mult(GRAVITY,(_size)/(0.9195*DROPS_CX)),PVector.mult(WIND,WIND.mag()));
    PVector V0        = PVector.div(V0_sq,sqrt(V0_sq.mag()));
    PVector V0_cam_sq = PVector.add(V0_sq,PVector.mult(p_cameraMovement,100.f));
    PVector V0_cam    = PVector.div(V0_cam_sq,sqrt(V0_cam_sq.mag()));
    
    _position = dropsBox.sampleSurface(V0_cam);
    _positionOld = PVector.sub(_position,PVector.mult(V0,DELTA_TIME));
    
    for(Object o : obstacles)
      if(o.intersect(_position,PVector.mult(V0.normalize(),-1000.f))){
         _state = -1;
        return;
      }
    
    updateIntersection();
  }
  
  public void updatePosition(){
    if(_state==0 || _state==-1) return;
    
    PVector velOld = PVector.div(PVector.sub(_position,_positionOld),DELTA_TIME);
      
    PVector wind_directional = WIND;
    PVector wind_local = new PVector(0,0,0);
    //PVector wind_local = PVector.mult(_position,90.*cos(sqrt(_position.mag()))/_position.mag());
    //PVector wind_local = new PVector(0.f,1.f,0.f).cross(_position).mult(sqrt(2.5*abs(_position.y+50.f))).add(new PVector(0.,10.,0.)); // tornade
    PVector wind_total = PVector.add(PVector.mult(wind_directional,wind_directional.mag()),PVector.mult(wind_local,wind_local.mag()));
      
    PVector a = PVector.add(GRAVITY,PVector.mult(PVector.sub(wind_total,PVector.mult(velOld,velOld.mag())),0.9195*DROPS_CX/_size));
    PVector vel = PVector.add(velOld,PVector.mult(a,DELTA_TIME));
    PVector positionNext = PVector.add(_position,PVector.mult(vel,DELTA_TIME)); 
      
    _positionOld = _position;
    _position = positionNext;
  }

  public void updateIntersection(){
    for(Object o : obstacles) 
        if(o.intersect(_position,_positionOld)) {
          _state = -1;
          return;
        }
        
    if(dropsBox.isOutside(_position)) _state = -1;
  }
}
