package game;

import ecs.Engine;

class InGameSystem extends ecs.System {
    public function new() {
        super();
    }


    override public function onEnable() {
        var playerEntity:ecs.Entity;
        {
            var e = new ecs.Entity();
            e.add(Player);
            e.position = World.getStartPosition();
            playerEntity = e;
            engine.add(e);
        }

        {
            for(zone in World.getMap().allZones) {
                if(zone.type == First) { continue; }
            }
        }
    }

    override public function update(dt:Float) {
    }
}
