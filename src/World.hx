package;

import w.W;
import js.Browser.document;

var mapGen:map.Generator = new map.Generator();
var map:map.Map;
var triangles = new Array<math.Triangle>();

class World {
    inline static var scale = 10;
    inline static public function load():DataBuffer {
        var buffer = new DataBuffer(2048);
        var size = 1000;
        var tsize = 100;

        var n = new math.Vector3(0, 1, 0);

        buffer.add(new math.Vector3(-size, 0, -size), n, new math.Vector2(0, 0));
        buffer.add(new math.Vector3(size, 0, -size), n, new math.Vector2(tsize, 0));
        buffer.add(new math.Vector3(size, 0, size), n, new math.Vector2(tsize, tsize));
        buffer.add(new math.Vector3(size, 0, size), n, new math.Vector2(tsize, tsize));
        buffer.add(new math.Vector3(-size, 0, size), n, new math.Vector2(0, tsize));
        buffer.add(new math.Vector3(-size, 0, -size), n, new math.Vector2(0, 0));

        map = mapGen.generate();

        for(w in map.walls) {
            var h = 1;
            var v1 = new math.Vector3(w.x1, 0, w.y1);
            var v2 = new math.Vector3(w.x2, 0, w.y2);
            var v3 = new math.Vector3(w.x2, h, w.y2);
            var v4 = new math.Vector3(w.x1, h, w.y1);
            var n = new math.Vector3(0, 1, 0);
            buffer.add(v1, n, new math.Vector2(0, h));
            buffer.add(v2, n, new math.Vector2(1 * w.getLength(), h));
            buffer.add(v3, n, new math.Vector2(1 * w.getLength(), 0));
            buffer.add(v3, n, new math.Vector2(1 * w.getLength(), 0));
            buffer.add(v4, n, new math.Vector2(0, 0));
            buffer.add(v1, n, new math.Vector2(0, h));
            var tri1 = new math.Triangle(v1, v2, v3);
            var tri2 = new math.Triangle(v3, v4, v1);
            triangles.push(tri1);
            triangles.push(tri2);
        }

        return buffer;
    }

    inline static public function getVertexCount() {
        return 6 + map.walls.length * 6;
    }

    inline static public function collides(p:math.Vector3) {
        var result = false;

        for(tri in triangles) {
            if(tri.distanceToPoint(p) < 0.2) {
                result = true;
                break;
            }
        }

        return result;
    }

    inline static public function getStartPosition():math.Vector3 {
        var pos = map.allZones[0].getCenter();
        return [pos.x, 0, pos.y];
    }

    inline static public function getCenter():math.Vector3 {
        return [map.width*0.5, 0, map.height*0.5];
    }

    inline static public function getMap() {
        return map;
    }

    inline static public function render() {
        W.plane({size:10000, b:"3d2", y:0, rx:-90});

        for(wi in map.walls) {
            var a = new math.Vector2(wi.x1, wi.y1) * scale;
            var b = new math.Vector2(wi.x2, wi.y2) * scale;
            var p = (a + b) * 0.5;
            var angle = (b-a).getAngle() * 180/Math.PI;
            W.cube({w:wi.getLength() * scale, d:0.1* scale, h:2 * scale, x:p.x, z:p.y, ry:angle, t:untyped walloo});
        }
    }

    inline static public function setCamera(position:math.Vector3, yaw:Float, pitch:Float) {
        var p = position * scale;
        W.camera({
            x:p.x,
            y:p.y,
            z:p.z,
            ry:yaw * 180/3.1415,
            rx:pitch * -180/3.1415

        });
        W.shotgun({
            x:p.x,
            y:p.y - 1.2,
            z:p.z,
            ry:yaw * 180/3.1415,
            rx:pitch * -180/3.1415,
            size:5
        });
    }

    static public function makeParticleMesh():Array<Float> {
        var verts:Array<Float> = [];
        var latSteps = 9;
        var lonSteps = 12;

        function point(i:Int, j:Int):math.Vector3 {
            var lat = Math.PI * i / latSteps;
            var lon = Math.PI * 2 * j / lonSteps;
            var nx = Math.sin(lat) * Math.cos(lon);
            var ny = Math.cos(lat);
            var nz = Math.sin(lat) * Math.sin(lon);
            var r = 1
                + 0.22 * Math.sin(lat * 3 + lon * 2) * Math.cos(lon * 2 - lat)
                + 0.14 * Math.sin(lon * 4) * Math.sin(lat * 3 + 1)
                + 0.10 * Math.cos(lat * 5 + lon);
            return new math.Vector3(nx * r, ny * r, nz * r);
        }

        function addTri(a:math.Vector3, b:math.Vector3, c:math.Vector3) {
            verts[verts.length] = a.x;
            verts[verts.length] = a.y;
            verts[verts.length] = a.z;
            verts[verts.length] = b.x;
            verts[verts.length] = b.y;
            verts[verts.length] = b.z;
            verts[verts.length] = c.x;
            verts[verts.length] = c.y;
            verts[verts.length] = c.z;
        }

        for(i in 0...latSteps) {
            for(j in 0...lonSteps) {
                var p00 = point(i, j);
                var p01 = point(i, j + 1);
                var p10 = point(i + 1, j);
                var p11 = point(i + 1, j + 1);
                addTri(p00, p10, p01);
                addTri(p01, p10, p11);
            }
        }

        return verts;
    }

    inline static public function renderModel(e:ecs.Entity, model:game.Model) {
        var p = e.position;
        p = p * scale;
        var s:Dynamic = {
            x:p.x,
            y:p.y,
            z:p.z,
            ry: e.yaw,
            size:model.size
        };
        if(model.color != null) {
            s.b = model.color;
        }
        untyped W[model.mesh](s);
    }
}
