import h2d.Text;
import h2d.Font;
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
    var attackanim_tiles:Array<Tile> = [];
    var deathanim_tiles:Array<Tile> = [];

    var hitpoints:Float = 10.0;
    var power:Float = 0;
    var dying:Bool = false;

    var vx:Float = 0.0;
    var vy:Float = 0.0;
    var active:Bool = false;
    var target:Point = null;
    var targetcircle:Circle = null;
    var attacking:Bool = false;

    var goldtext:Text = null;
    var font:h2d.Font = null;

    public function new(s2d:Scene){
        
        vy = Math.random() * 10;
        vx = Math.random() * 10;

        loop = true;
        super(walkanim_tiles, 10, s2d);
        x = Math.random() * 400;
        y = Math.random() * 100;
        onAnimEnd = function() {
            if(attacking){
                play(walkanim_tiles, 0);
                attacking = false;
                changeDirection();
            }
        }

        deathanim_tiles.push(Res.death1.toTile());
        deathanim_tiles.push(Res.death2.toTile());
        deathanim_tiles.push(Res.death3.toTile());
        deathanim_tiles.push(Res.death4.toTile());
        deathanim_tiles.push(Res.death5.toTile());
        deathanim_tiles.push(Res.death6.toTile());
        deathanim_tiles.push(Res.death7.toTile());
        font = hxd.res.DefaultFont.get();
        goldtext = new Text(font);

    }

    public function changeDirection(){
        //vx = -vx;
        //vy = -vy;
        vy = Math.random() * 10 - 5;
        vx = Math.random() * 10 - 5;
    }

    public function activate(){
        if(!active){
            this.color.b += 0.5;
            active = true;
        }
    }

    public function deactivate(){
        if(active){
            this.color.b -= 0.5;
            active = false;
        }
    }

    override function sync(ctx:RenderContext) {
        if(hitpoints <= 0){
            if(!dying){
                play(deathanim_tiles, 0);
                hitpoints = 1000;
                addChild(goldtext);
                goldtext.textColor = 0xFFFFF00;

                onAnimEnd  = function() {
                    remove();
                }
                dying = true;
            }
            
        }
        if(target != null){
            if(!targetcircle.contains(this.getBounds().getCenter())){

                followPoint(target);
            }else{
                stay();
                target = null;
            }
        }

        if(y + walkanim_tiles[0].height + (0.1*vy) >= getScene().height || (y+0.1*vy) < 1 ) {
            vy = -vy;
        }
        if(x + walkanim_tiles[0].height + (0.1*vx) >= getScene().width || (x+0.1*vx) < 1){
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
    
    public function hasTarget():Bool{
        if(target != null) return true;
        else return false;
    }

    public function attack(target:Npc):Bool{
        if(!attacking){
            if(attackanim_tiles.length > 0) play(attackanim_tiles, 0);
            attacking = true;
            vx = 0;
            vy = 0;
            return target.hit(power);
        }
        return false;
    }
    public function hit(damage:Float):Bool{
        hitpoints -= damage;
        if(hitpoints <= 0) return true;
        return false;
    }
}

class Goblin extends Npc {
    public function new(s2d:Scene, x:Float, y:Float) {
        super(s2d);
        this.x = x;
        this.y = y;
        walkanim_tiles.push(Res.goblin.goblin_w0.toTile());
        walkanim_tiles.push(Res.goblin.goblin_w1.toTile());
        walkanim_tiles.push(Res.goblin.goblin_w2.toTile());
        walkanim_tiles.push(Res.goblin.goblin_w3.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a0.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a1.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a2.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a3.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a4.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a5.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a6.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a7.toTile());
        attackanim_tiles.push(Res.goblin.goblin_a8.toTile());
        hitpoints = 5.5;
        power = 1;
        goldtext.text = "+1g";
    }
}

class Knight extends Npc {
    public function new(s2d:Scene, x:Float, y:Float) {
        super(s2d);
        this.x = x;
        this.y = y;
        walkanim_tiles.push(Res.knight.knight_w0.toTile());
        walkanim_tiles.push(Res.knight.knight_w1.toTile());
        walkanim_tiles.push(Res.knight.knight_w2.toTile());
        walkanim_tiles.push(Res.knight.knight_w3.toTile());
        walkanim_tiles.push(Res.knight.knight_w4.toTile());
        hitpoints = 15.5;
        power = 5;
        goldtext.text = "";
    }
}