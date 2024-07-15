1. CGLine
使用 mid-point 直線演算法實現。
2. CGCircle
Bresenham圓演算法。
3. CGEllipse
Bresenham圓演算法的延伸，將橢圓分為兩部分就能用Bresenham實現。
第一部分：以 Y 軸向左右兩側展開 45 度
第二部分：以 X 軸向上下兩側展開 45 度
[參考連結](https://www.geeksforgeeks.org/midpoint-ellipse-drawing-algorithm/)
4. CGCurve
直接將四個控制點 p0, p1, p2, p3帶入公式
$(x,y) = p0*(1-t)^3 + p1*(t-1)^2*t+p2*(1-t)*t^2+p3*t^3$
迴圈的t值變化 : $0.0001$
5. CGEraser
用兩個迴圈把 p1,p2 包住的點設定為背景色。