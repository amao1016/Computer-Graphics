## 3D Graphics Lab2
1. makeTrans,makeRotz,makeScale
$$
makeTrans = 
  \begin{bmatrix}
    1 & 0 & 0 & t.x \\
    0 & 1 & 0 & t.y \\
    0 & 0 & 1 & t.z \\
    0 & 0 & 0 & 1
  \end{bmatrix}
makeRotz = 
  \begin{bmatrix}
    cos(a) & -sin(a) & 0 & 0 \\
    sin(a) & cos(a) & 0 & 0 \\
    0 & 0 & 1 & 0 \\
    0 & 0 & 0 & 1
  \end{bmatrix}
makeScale = 
  \begin{bmatrix}
    s.x & 0 & 0 & 0 \\
    0 & s.y & 0 & 0 \\
    0 & 0 & s.z & 0 \\
    0 & 0 & 0 & 1
  \end{bmatrix}
$$
3. pnpoly(float x, float y, Vector3[] vertexes)
判斷點(x,y)是否在vertexes圖形內部，return boolean。
從(x,y)向右發射射線，如果和圖形相交次數為奇數，則點在內部。
所以先對圖形每條邊的兩個點判斷(x,y)的 y 座標是否在兩點的 y 中間。
接著將 y 帶入線的方程式算出 x，判斷(x,y)是否在線的右邊。
5. public Vector3[] findBoundBox(Vector3[] v)
找到v陣列中的 min_x, min_y, max_x, max_y
6. Sutherland_Hodgman_algorithm
將超出邊界的多邊形裁切，回傳在邊界內的vertex。
依序將邊界的每條邊對多邊形裁切(clipEdge)，找出兩個點nm和邊界的交點(calinter)，加入新vertex。
兩線段交點參考：https://web.ntnu.edu.tw/~algo/Point.html
