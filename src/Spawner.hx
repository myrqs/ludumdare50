import h2d.Object;
import Npc.Goblin;
import h2d.RenderContext;
import h2d.Scene;
import h2d.Tile;
import h2d.Anim;

class Spawner extends Anim{

    var tiles:Array<Tile> = [];

    public function new(s2d:Scene) {
        super(tiles, 10, s2d);
    }
}

class GoblinSpawner extends Spawner {
    var npccontroller:Object = null;
    public function new(s2d:Scene, npccontroller:Object) {
        super(s2d);
        tiles.push(hxd.Res.goblinhole.goblinhole_0.toTile());
        tiles.push(hxd.Res.goblinhole.goblinhole_1.toTile());
        tiles.push(hxd.Res.goblinhole.goblinhole_2.toTile());
        tiles.push(hxd.Res.goblinhole.goblinhole_3.toTile());
        tiles.push(hxd.Res.goblinhole.goblinhole_4.toTile());
        tiles.push(hxd.Res.goblinhole.goblinhole_5.toTile());
        tiles.push(hxd.Res.goblinhole.goblinhole_6.toTile());
        tiles.push(hxd.Res.goblinhole.goblinhole_7.toTile());
        x = 50;
        y = 50;
        this.npccontroller = npccontroller;
    }

    override function sync(ctx:RenderContext) {
        super.sync(ctx);
        color.g += 0.001;
        if(color.g >= 2.0){
            npccontroller.addChild(new Goblin(getScene()));
            color.g = 1.0;
        }
    }
}