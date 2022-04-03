import h2d.Object;
import Npc.Goblin;
import h2d.RenderContext;
import h2d.Scene;
import h2d.Tile;
import h2d.Anim;
import h2d.Bitmap;

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

class Tower extends Spawner {
    var recruitbutton:Bitmap = null;
    var active:Bool = false;
    public function new(s2d:Scene) {
        super(s2d);
        tiles.push(hxd.Res.tower.tower_0.toTile());
        tiles.push(hxd.Res.tower.tower_1.toTile());
        tiles.push(hxd.Res.tower.tower_2.toTile());
        tiles.push(hxd.Res.tower.tower_3.toTile());
        tiles.push(hxd.Res.tower.tower_4.toTile());
        tiles.push(hxd.Res.tower.tower_5.toTile());
        tiles.push(hxd.Res.tower.tower_4.toTile());
        tiles.push(hxd.Res.tower.tower_3.toTile());
        tiles.push(hxd.Res.tower.tower_2.toTile());
        tiles.push(hxd.Res.tower.tower_1.toTile());
        x = 400;
        y = 200;
        recruitbutton = new Bitmap(hxd.Res.tower.recruitbutton.toTile(), s2d );
        recruitbutton.visible = false;
        recruitbutton.x = x;
        recruitbutton.y = y - 48;
    }

    public function activate(){
        active = recruitbutton.visible = true;
        color.b += 0.5;
    }
    public function deactivate() {
        if(active){
            active = recruitbutton.visible = false;   
            color.b -= 0.5;
        }
    }
    public function isActive():Bool {
        return recruitbutton.visible;
    }
}