import h2d.col.Circle;
import h2d.col.Point;
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
    var active:Bool = false;
    var target:Point = null;
    var targetcircle:Circle = null;

    public function new(s2d:Scene){
        
        vy = Math.random() * 10;
        vx = Math.random() * 10;

        loop = true;
        super(walkanim_tiles, 10, s2d);
        x = Math.random() * 400;
        y = Math.random() * 100;

    }

    public function changeDirection(){
        //vx = -vx;
        //vy = -vy;
        vy = Math.random() * 10 - 5;
        vx = Math.random() * 10 - 5;
    }

    public function activate(){
        if(!active){
            this.color.b += 10.0;
            active = true;
        }
    }

    public function deactivate(){
        if(active){
            this.color.b -= 10.0;
            active = false;
        }
    }

    override function sync(ctx:RenderContext) {
        if(target != null){
            if(!targetcircle.contains(this.getBounds().getCenter())){

                followPoint(target);
            }else{
                stay();
                target = null;
            }
        }

        if(y + walkanim_tiles[0].height + (0.1*vy) >= 400/2.5 || (y+0.1*vy) < 1 ) {
            vy = -vy;
        }
        if(x + walkanim_tiles[0].height + (0.1*vx) >= 800/2.5 || (x+0.1*vx) < 1){
            vx = -vx;
        }else{
            for(i in 0...parent.numChildren){
                var npc:Npc = cast(parent.getChildAt(i), Npc);
                
            }
            x += 0.1 * vx;
            y += 0.1 * vy;
        }
        super.sync(ctx);
    }
    
    public function followPoint(p:Point){

        var dx:Float = p.x - this.getBounds().getCenter().x; 
        var dy:Float = p.y - this.getBounds().getCenter().y;

        dx /= Math.abs(dx);
        dy /= Math.abs(dy);

        vx = dx * 10.0;
        vy = dy * 10.0;
        pause = false;
    }

    public function followBounds(b:Bounds) {
        var dx:Float = b.getCenter().x - this.getBounds().getCenter().x;
        var dy:Float = b.getCenter().y - this.getBounds().getCenter().y;
        
        followPoint(new Point(dx,dy));
    }
    public function stay(){
        vx = 0.0;
        vy = 0.0;
        pause = true;
    }

    public function setTarget(p:Point){
        this.target = p;
        this.targetcircle = new Circle(p.x, p.y, 6.0);
    }

    public function setDir(vx:Float, vy:Float){
        this.vx = vx;
        this.vy = vy;
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