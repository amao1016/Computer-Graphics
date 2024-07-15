public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
}
public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height) return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int)y * width + (int)x;
    if (outOfBoundary(x, y)) return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}



boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // HW2
    // To-Do : You need to check the coordinate p(x,v) if inside the vertexes. If yes return true.
    boolean c=false;
    int n = vertexes.length; //n個點，n條線
  
    for (int i = 0,j=n-1; i < n; j=i++)
    {
      if ((y<vertexes[i].y) != (y<vertexes[j].y))//橫向由左向右的 scanline，先把 y 範圍縮小到在兩點之間，也就是不可以皆大於或小於兩點的 y，TF or FT
      {
        if ( x < (vertexes[j].x-vertexes[i].x) * (y-vertexes[i].y) / (vertexes[j].y-vertexes[i].y) +vertexes[i].x)//判斷x在不在線的左邊
        {
          c=!c;
        }
      }
    }
    return c;
}

public Vector3[] findBoundBox(Vector3[] v) {
    Vector3 recordminV=new Vector3(1.0/0.0);
    Vector3 recordmaxV=new Vector3(-1.0/0.0);
    // HW2
    // To-Do : You need to find the bounding box of the vertexes v.

    //     r1 -------
    //       |   /\  |
    //       |  /  \ |
    //       | /____\|
    //        ------- r2
    float min_x = v[0].x, min_y = v[0].y, max_x = v[0].x, max_y = v[0].y;
    for (int i=1; i<v.length; i++)
    {
      if (v[i].x < min_x) min_x = v[i].x;
      if (v[i].y < min_y) min_y = v[i].y;
      if (v[i].x > max_x) max_x = v[i].x;
      if (v[i].y > max_y) max_y = v[i].y;
    }
    recordminV.set(min_x, min_y, 0);
    recordmaxV.set(max_x, max_y, 0);
    Vector3[] result={recordminV, recordmaxV};
    return result;
}

public boolean inside(Vector3 point, Vector3 boundary1, Vector3 boundary2)
{
    //>0 outside,<0 inside
   float p=(boundary2.x-boundary1.x)*(point.y-boundary1.y)-(boundary2.y-boundary1.y)*(point.x-boundary1.x);
    if(p>0)return false;
    else return true;
}
public float crossxy(Vector3 a,Vector3 b)
{
    return a.x*b.y-a.y*b.x;
}
public Vector3 calinter(Vector3 point1, Vector3 point2, Vector3 boundary1,Vector3 boundary2)//找交點
{
    Vector3 a = point2.sub(point1);
    Vector3 b = boundary2.sub(boundary1);
    Vector3 s = boundary1.sub(point1);
    Vector3 result = point1.add(a.mult(crossxy(s,b)/(crossxy(a,b))));
    return result;
    
}
public void clipEdge(ArrayList<Vector3> input,Vector3 boundary1, Vector3 boundary2)
{
    ArrayList<Vector3> output=new ArrayList<Vector3>();
    boolean n_inside,m_inside;   
    for(int m = 0, n = input.size()-1; m < input.size(); n = m++)//對多邊形的n->m判斷是否在邊界內，若一內一外則找交點並加入output，若m在內部則output加入m
    {
       n_inside = inside(input.get(n),boundary1,boundary2);
       m_inside = inside(input.get(m),boundary1,boundary2);
       if(n_inside &&m_inside) output.add(input.get(m));
       else if(n_inside&&!m_inside) output.add(calinter(input.get(n),input.get(m),boundary1,boundary2));
       else if(!n_inside&&m_inside) 
       {
           output.add(calinter(input.get(n),input.get(m),boundary1,boundary2));
           output.add(input.get(m));  
       }     
    }
    input.clear();
    input.addAll(output);

}
public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input=new ArrayList<Vector3>();
    ArrayList<Vector3> output=new ArrayList<Vector3>();
    for (int i=0; i<points.length; i+=1) {
      input.add(points[i]);
    }
    
    // To-Do
    // You need to implement the Sutherland Hodgman Algorithm in this section.
    // The function you pass 2 parameter. One is the vertexes of the shape "points".
    // And the other is the vertexes of the "boundary".
    // The output is the vertexes of the polygon.
    int n = boundary.length;
    for(int i=0, j=n-1; i<n; j=i++)//將邊界的每條邊依序切割多邊形，回傳新的多邊形端點
    {
        clipEdge(input,boundary[j],boundary[i]);
    }
  
    output = input;
  
    Vector3[] result=new Vector3[output.size()];
    for (int i=0; i<result.length; i+=1) {
      result[i]=output.get(i);
    }
    return result;
}

public float getDepth(float x, float y, Vector3[] vertex) {
    //三點決定一平面，求這個平面上一xy座標的z
    //利用重心求
    float a,b,c;
    float abc, pbc, apc;// 沒哪個就對應哪個
    pbc = crossxy(vertex[1].sub(vertex[2]),vertex[1].sub(new Vector3(x,y,0)));
    apc = crossxy(vertex[0].sub(vertex[2]),vertex[0].sub(new Vector3(x,y,0)));
    abc = crossxy(vertex[1].sub(vertex[0]),vertex[2].sub(vertex[0]));
    a = abs(pbc/abc);
    b = abs(apc/abc);
    c = 1-a-b;
    float z = a * vertex[0].z + b * vertex[1].z + c * vertex[2].z;
    return z;

}

float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A=verts[0].homogenized();
    Vector3 B=verts[1].homogenized();
    Vector3 C=verts[2].homogenized();

    float AW = verts[0].w;
    float BW = verts[1].w;
    float CW = verts[2].w;

    float a,b,c;
    float abc, pbc, apc;// 沒哪個就對應哪個
    pbc = crossxy(B.sub(C),B.sub(new Vector3(P.x,P.y,0)));
    apc = crossxy(A.sub(C),A.sub(new Vector3(P.x,P.y,0)));
    abc = crossxy(B.sub(A),C.sub(A));
    a = abs(pbc/abc);
    b = abs(apc/abc);
    c = 1-a-b;
    float s = a/AW + b/BW + c/CW;
    float alpha = a/(AW*s);
    float beta = b/(BW*s);
    float gama = c/(CW*s);

    // To - Do (HW4)
    // Calculate the barycentric coordinates of point P in the triangle verts using the barycentric coordinate system.
    // Please notice that you should use Perspective-Correct Interpolation otherwise you will get wrong answer.
    float[] result = {alpha,beta,gama};
    return result;
}
Vector3 getTexture(PImage img, Vector3 uv) {
    float x=map(uv.x, 0, 1, 0, img.width-1);
    float y=map(uv.y, 0, 1, 0, img.height-1);
    //int index=int(x%img.width)+int(y%img.height)*img.width;
    int index = int(constrain(x, 0, img.width - 1)) + int(constrain(y, 0, img.height - 1)) * img.width;

    color pixel=img.pixels[index];
    float r = red(pixel) / 255.0;
    float g = green(pixel) / 255.0;
    float b = blue(pixel) / 255.0;
    return new Vector3(r,g,b);
    //return new Vector3(r/255.0, g/255.0, b/255.0);
}

Vector3 interpolation(float[] abg, Vector3[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

Vector4 interpolation(float[] abg, Vector4[] v) {
    return v[0].mult(abg[0]).add(v[1].mult(abg[1])).add(v[2].mult(abg[2]));
}

float interpolation(float[] abg, float[] v) {
    return v[0]*abg[0] + v[1]*abg[1] + v[2]*abg[2];
}
