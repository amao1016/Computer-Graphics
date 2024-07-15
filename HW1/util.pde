public void CGLine(float x1,float y1,float x2,float y2)
{
    //To-Do: You need to implement the "line algorithm" in this section. 
    //You can use the function line(x1, y1, x2, y2); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part.
    //Utilize the function drawPoint(x, y, color) to apply color to the pixel at coordinates (x, y).
    //For instance: drawPoint(0, 0, color(255, 0, 0)); signifies drawing a red point at (0, 0).  
    // below is mid-point 參考上課筆記

    float xn = x1<x2? 1:-1,yn = y1<y2? 1:-1;
    float x = x1, y = y1;
    float a = (y2-y1)*yn, b = (x2-x1)*xn; //多乘 yn, xn 就能擴展到 4 個象限
    drawPoint(x,y,color(0));
    boolean slope = a>b? true:false; //以 y 為基準 true,以 x 為基準 false
    if(slope)
    {
        float space = a;
        a = b;
        b = space;
    }
    float d = a-b/2;
    drawPoint(x, y, color(0));
    while(x!=x2 || y!=y2) //&&會無法畫垂直或水平
    {
        if(d<=0)
        {
            if(!slope) x += xn;      
            else y += yn;           
            d += a;
        }
        else
        {
          x+=xn;                  
          y+=yn;                  
          d+=a-b;
        }
        drawPoint(x, y, color(0));
    }

    /*
    stroke(0);
    noFill();
    line(x1,y1,x2,y2);
    */
}


public void CGCircle(float x,float y,float r)
{
    //To-Do: You need to implement the "circle algorithm" in this section. 
    //You can use the function circle(x, y, r); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part.
    
    float xp = 0;
    float yp = r;
    float p = 3 - 2*r;
    while(xp < yp)
    {
        drawPoint(x+xp, y+yp, color(0));
        drawPoint(x+xp, y-yp, color(0));
        drawPoint(x-xp, y+yp, color(0));
        drawPoint(x-xp, y-yp, color(0));

        drawPoint(x+yp, y+xp, color(0));
        drawPoint(x+yp, y-xp, color(0));
        drawPoint(x-yp, y+xp, color(0));
        drawPoint(x-yp, y-xp, color(0));
        if(p<0) p += 4*xp + 6;
        else
        {
            p += 4*(xp-yp) + 10;
            yp--;
        }
        xp++;
    }
    /*
    stroke(0);
    noFill();
    circle(x,y,r*2);
    */  
}

public void CGEllipse(float x,float y,float r1,float r2)
{
    //To-Do: You need to implement the "ellipse algorithm" in this section. 
    //You can use the function ellipse(x, y, r1,r2); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part. 
    
    //將橢圓分為兩部分，第一部分以 Y 軸向左右兩側展開 45 度，第二部分則是以 X 軸向上下兩側展開 45 度
    //兩部分都能以一個點找出其他三個對應位置
    //part 1, 45~135, 225~315
    float xp = 0;
    float yp = r2;
    float p = r2*r2 + 0.25*r1*r1 - r1*r1*r2;
    float dx = 2*r2*r2*xp;
    float dy = 2*r1*r1*yp;
    while(dx<dy)//從 Y 軸下降           
    {
        drawPoint(x+xp, y+yp, color(0));
        drawPoint(x+xp, y-yp, color(0));
        drawPoint(x-xp, y+yp, color(0));
        drawPoint(x-xp, y-yp, color(0));
        xp++;
        dx += 2*r2*r2;
        if(p < 0) 
        {
            p += dx + r2*r2;
        }
        else
        {
            yp--;
            dy -= 2*r1*r1;
            p += dx - dy + r2*r2;
        }
    }
    // part 2, -45~45, 135-225
    p = r1*r1 + 0.25*r2*r2 - r1*r2*r2;
    while(yp >= 0)//延續 part 1的 y 值，直到碰到 X軸  
    {
        drawPoint(x+xp, y+yp, color(0));
        drawPoint(x+xp, y-yp, color(0));
        drawPoint(x-xp, y+yp, color(0));
        drawPoint(x-xp, y-yp, color(0));
        yp--;
        dy -= 2*r1*r1;
        if(p > 0) 
        {
            p += -dy + r1*r1;
        }
        else
        {
            xp++;
            dx += 2*r2*r2;
            p += dx - dy + r1*r1;
        }
    }
    /*
    stroke(0);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    */
      
}

public void CGCurve(Vector3 p0,Vector3 p1,Vector3 p2,Vector3 p3)
{
    //To-Do: You need to implement the "bezier curve algorithm" in this section. 
    //You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y); to verify the correct answer. 
    //However, remember to comment out the function before you submit your homework. 
    //Otherwise, you will receive a score of 0 for this part.
    float x = 0 ,y = 0;
    for(float t=0; t<=1; t+=0.0001)
    {
        x = p0.x*pow((1-t),3) + 3*p1.x*pow((1-t),2)*t + 3*p2.x*pow((1-t),1)*pow(t,2) + p3.x*pow(t,3);
        y = p0.y*pow((1-t),3) + 3*p1.y*pow((1-t),2)*t + 3*p2.y*pow((1-t),1)*pow(t,2) + p3.y*pow(t,3);
        drawPoint(x,y,color(0));
    }//original function

    /*
    stroke(0);
    noFill();
    bezier(p0.x,p0.y,p1.x,p1.y,p2.x,p2.y,p3.x,p3.y);
    */
}

public void CGEraser(Vector3 p1,Vector3 p2)
{
    //To-Do: You need to erase the scene in the area defined by points p1 and p2 in this section.. 
    //   p1  ------
    //      |      |
    //      |      |
    //       ------ p2
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    for (float x = p1.x; x<p2.x; x++)
    {
      for(float y =  p1.y; y<p2.y; y++) drawPoint(x,y,color(250));
    }
    //Utilize the function drawPoint(x, y, color) to apply color to the pixel at coordinates (x, y).
    //For instance: drawPoint(0, 0, color(255, 0, 0)); signifies drawing a red point at (0, 0). 
    //drawPoint(0,0,color(250));

}

public void drawPoint(float x,float y,color c)
{
    stroke(c);
    point(x,y);
}

public float distance(Vector3 a,Vector3 b)
{
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c,c));
}
