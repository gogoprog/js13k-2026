package game;

import ecs.Engine;

class MonsterSystem extends ecs.System {
    private var turnSpeed = 180.0;

    public function new() {
        super();
        requires(Monster);
    }

    override public function updateEntity(e:ecs.Entity, dt:Float) {
        var m = e.get(Monster);
        var move = e.get(Move);

        if(move == null) {
            move = e.add(Move);
            move.time = 0;
            move.duration = 1 + Std.random(5);
            var speed = 2;
            var angle = Math.random() * 3.14 * 2;
            move.velocity = math.Vector3.getRotatedAroundY([1, 0, 0], angle) * speed;
            m.targetYaw = -angle * 180 / 3.14 + 90;
        }

        e.yaw = rotateTowards(e.yaw, m.targetYaw, turnSpeed, dt);
    }

    static inline function rotateTowards(current:Float, target:Float, speed:Float, dt:Float):Float {
        var diff = (target - current + 540) % 360 - 180;
        var maxStep = speed * dt;
        if(diff > maxStep) {
            diff = maxStep;
        } else if(diff < -maxStep) {
            diff = -maxStep;
        }
        return current + diff;
    }
}
