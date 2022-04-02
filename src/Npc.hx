import h2d.col.Bounds;
import hxd.Res;
import h2d.RenderContext;
import h2d.Scene;
import h2d.Tile;
import h2d.Anim;

class Npc extends Anim {
    var walkanim_tiles:Array<Tile> = [];

    var vx:Float = 0.0;
    var vy:Float = 0.0;

    public function new(s2d:Scene){
        
        vy = Math.random() * 10;
        vx = Math.random() * 10;

        loop = true;
        super(walkanim_tiles, 10, s2d);
        x = 2;
        y = 2;

    }

    override function sync(ctx:RenderContext) {
        if(y + walkanim_tiles[0].height >= 400/2.5 || y < 1 || x + walkanim_tiles[0].height >= 800/2.5 || x < 1){
            vx = -vx;
            vy = -vy;
        }

        x += 0.1 * vx;
        y += 0.1 * vy;
        super.sync(ctx);
    }

    public function followBounds(b:Bounds) {
        var dx:Float = b.getCenter().x - this.getBounds().getCenter().x;
        var dy:Float = b.getCenter().y - this.getBounds().getCenter().y;
        
        dx /= Math.abs(dx);
        dy /= Math.abs(dy);

        vx = dx * 10.0;
        vy = dy * 10.0;


    }
}

class Goblin extends Npc {
    public function new(s2d:Scene) {
        super(s2d);
        walkanim_tiles.push(Res.goblin.goblin_w0.toTile());
        walkanim_tiles.push(Res.goblin.goblin_w1.toTile());
        walkanim_tiles.push(Res.goblin.goblin_w2.toTile());
        walkanim_tiles.push(Res.goblin.goblin_w3.toTile());
    }
}