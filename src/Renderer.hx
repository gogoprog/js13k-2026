package;

import w.W;

class Renderer {
    inline static public function setCamera(position:math.Vector3, yaw:Float, pitch:Float) {
        W.camera({
            x:position.x,
            y:position.y,
            z:position.z,
            ry:yaw * 180/3.1415,
            rx:pitch * -180/3.1415

        });
    }

}
