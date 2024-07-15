HW3:cameraControl()，實現控制相機位置。在螢幕上拖曳會改變相機的xy座標，滾輪拉近拉遠則會更改相機的z座標。
Camera:setSize()，實現PM
Camera:setPositionOrientation()，實現EM
Obeject:localToWorld()， 將物件位置轉換成世界座標。
util:getDepth()，在一平面上算出一xy座標的z座標。
Object:debugDraw()，實現backface-cull以及用Sutherland_Hodgman_algorithm實現3D clipping
engine，增加path不為空的判斷式，修改如果沒有選擇檔案會出錯的問題。
engine.initCameraBUtton增加一個相機圖案的button，讓cam_pos,lookat回到初始值。
engine.refreshButton在slider上面增加一個refresh圖案，可以初始化當前object的slider。