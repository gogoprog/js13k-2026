import js.Browser.document;
import w.W;
import ecs.Engine;

var lastTime = 0.0;
var windowIsVisible = true;

function main() {
    var c:js.html.CanvasElement = cast document.querySelector("canvas");
    untyped window.onfocus = (e) -> { windowIsVisible = true; };
    untyped window.onblur = (e) -> { windowIsVisible = false; };
    // Renderer.init();
    Input.init();
    var buffer = World.load();
    // var worldModel = new ModelData(buffer);
    // var cross = ModelData.createQuad(0.01, 0.01);
    // cross.texture = Renderer.createText("+", 16, 16);
    game.Game.init();

    W.init(c);
    function loop(t:Float) {
        if(!windowIsVisible) {
            js.Browser.window.setTimeout(function() {loop(t+1);}, 1000);
            return;
        }

        t /= 1000;
        var dt = t - lastTime;
        lastTime = t;
        // Renderer.preRender();
        // Renderer.setModelPosition(math.Vector3.zero);
        // Renderer.drawModel(worldModel);
        game.Game.update(dt);
        // Renderer.setModelPosition(new math.Vector3(0, 0, -0.5));
        // Renderer.drawModel(cross, false);
        // Renderer.postRender();
        Input.update();

        W.reset();
        W.camera({x:9, y:8, z:20, rx:-13, ry:15 });
        W.light({x:0.5, y:-1, z:-0.5});
        W.cube({x:5 + 10 * Math.sin(t * 1), w:3, h:.5, d:.5, b:"f44"});
        W.sphere({x:0, size:4, b:"388"});
        W.pyramid({x:-5, size:4, b:"909"});
        W.add("custom_model", {
            vertices: [
                -.5, -.5, .5, .5, -.5, .5,  0, .5, 0,
                .5, -.5, .5, .5, -.5, -.5,  0, .5, 0,
                .5, -.5, -.5, -.5, -.5, -.5,  0, .5, 0,
                -.5, -.5, -.5, -.5, -.5, .5,  0, .5, 0,
            ],
            uv: [
                0, 0, 1, 0, .5, 1,
                0, 0, 1, 0, .5, 1,
                0, 0, 1, 0, .5, 1,
                0, 0, 1, 0, .5, 1,
            ]
        });
        W.custom_model({x:1, y:5, z:-15, size:10});
        W.draw(t);
        js.Browser.window.requestAnimationFrame(loop);
        // untyped W._setTimeout(loop, 1000/60);
    }
    js.Browser.window.requestAnimationFrame(loop);
}
