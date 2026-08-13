package game;

var engine:ecs.Engine;

class Game {
    static public function init() {
        engine = new ecs.Engine();
        engine.enable(ModelSystem);
        engine.enable(MoveSystem);
        engine.enable(MenuSystem);
        engine.enable(ParticleSystem);
    }

    static public function update(dt:Float) {
        engine.update(dt);
    }

    static public function spawnParticles(pos:math.Vector3, count:Int) {
        for(i in 0...count) {
            // spawnParticle(pos);
        }
    }
}
