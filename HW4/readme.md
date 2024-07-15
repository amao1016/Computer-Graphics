util:barycentric() ，沿用上次 getdepth 的一部份，算出每個頂點的權重 abc ，s=sum( 權重 / 齊次座標 ), 最後回傳的 alpha,beta,gama= 權重 /( 齊次 *s)。
Shading 說明：
1. Phong 在 VertexShader 計算 vertex 的 gl_position, w_position,w_normal ， Object 把回傳的 vertex 丟給 barycentric 計算插值得到每個像素的 w_position, w_normal，傳進FragmentShader 計算每個像素的光照。
2. Gaurund 在 VertexShader 計算所有 vertex 光照，Object 把回傳的 color 丟進插值(這一步其實已經計算完畢)，再丟進FragmentShader。
3. Flat 在 VertexShader 計算一個 vertex 的光照。和 Gaurund 在 code 上的差異是，算出來的一個 vertex 的光照會直接套用到所有的 vertex 上。


保留上次作業新增的 refresh button，刪掉HW4:cameraControl()、initCameraBUtton。