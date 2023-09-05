public class Triangle{
  public PVector v0, v1, v2;
  public PVector n0, n1, n2;
  
  public Triangle(int i0, int i1, int i2, int n0, int n1, int n2, ArrayList<PVector> points, ArrayList<PVector> normales){
    this.v0 = points.get(i0);
    this.v1 = points.get(i1);
    this.v2 = points.get(i2);
    
    if(normales != null){
      this.n0 = normales.get(n0);
      this.n1 = normales.get(n1);
      this.n2 = normales.get(n2);
    }
  }
  
  public void vertices(){
     vertex(v0);
     vertex(v1);
     vertex(v2);
  }
  
  public void vertices(float size, PVector position){
     size*=0.5;
     vertex(PVector.add(PVector.mult(v0,size),position));
     vertex(PVector.add(PVector.mult(v1,size),position));
     vertex(PVector.add(PVector.mult(v2,size),position));
  }
  
  public boolean intersect( PVector o, PVector dir, float tmin, float tmax ){
    PVector x = PVector.sub(v1, v0);
    PVector y =  PVector.sub(v2, v0);
    PVector a = dir.cross(y);
    float det = PVector.dot(x, a); 
  
    if(det==0.f) return false;
  
    float invDet = 1./det;
    PVector b = PVector.sub(o,v0);
    float   u = PVector.dot(b,a)*invDet;
    if(u<0.||u>1.) return false;
  
    PVector c = b.cross(x);
    float   v = PVector.dot(dir,c)*invDet;
    if(v<0.||u+v>1.) return false;
  
    float t = PVector.dot(y,c)*invDet;
    return t>tmin && t<tmax;
  } 
}

public class Object {
  private color col;
  
  private ArrayList<PVector> positions;
  private ArrayList<PVector> normales;
  private ArrayList<Triangle> triangles;

  public Object(PVector center, color col, float scale, String path) {
    this.col = col;
 
    this.positions = new ArrayList<>();
    this.triangles = new ArrayList<>();
    this.normales = new ArrayList<>();
    
    String[] lines = loadStrings(path);
    for(String line : lines){
      String datas[] = line.split(" ");
      switch (datas[0]){
        case "v": positions.add(new PVector(Float.parseFloat(datas[1])*scale+center.x,Float.parseFloat(datas[2])*scale+center.y,Float.parseFloat(datas[3])*scale+center.z));break;
        case "vn": normales.add(new PVector(Float.parseFloat(datas[1]),Float.parseFloat(datas[2]),Float.parseFloat(datas[3])));break;
        case "f" : triangles.add(new Triangle(Integer.parseInt(datas[1].split("/")[0])-1,Integer.parseInt(datas[2].split("/")[0])-1,Integer.parseInt(datas[3].split("/")[0])-1,
                                              Integer.parseInt(datas[1].split("/")[2])-1,Integer.parseInt(datas[2].split("/")[2])-1,Integer.parseInt(datas[3].split("/")[2])-1,positions,normales)); break;
        default : break;
      }
    }
  }

  public void vertices() {
    fill(this.col);
    triangles.forEach(t -> t.vertices());
  }
  
  public boolean intersect(PVector a, PVector b){
    PVector vec = PVector.sub(b,a);
    float tMax = vec.mag();
    vec.normalize();
    
    for(Triangle t : triangles)
      if(t.intersect(a,vec,0,tMax)) return true;
    
    return false;
  }
}
