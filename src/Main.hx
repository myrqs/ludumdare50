import h2d.Tile;
import h2d.Anim;
import h2d.col.Point;
import h2d.Object;
import Npc;
import Spawner;
import hxd.snd.Channel;
import hxd.res.Sound;

class Main extends hxd.App {
	
  var font:h2d.Font = null;
	var music:Channel = null;

  var target:Point = new Point(0.0, 0.0);

  var npcs:Array<Npc> = [];

  var tar_anim:Anim = null;

  var tar_anim_tiles:Array<Tile> = [];

  var tar_sound:Sound = null;

  var npc_controller:Object = new Object();

  var active_npc:Npc = null;

  override function init() {
    super.init();

    s2d.scaleMode = Zoom(2.5);

		font = hxd.res.DefaultFont.get();

		var musicResource:Sound = null;
		if (hxd.res.Sound.supportedFormat(Wav)) {
			musicResource = hxd.Res.sound.track1;
      tar_sound = hxd.Res.sound.click;
		}

		if (musicResource != null) {
			music = musicResource.play(true);
		}
    

    for(i in 0...1) npc_controller.addChild(new Goblin(s2d));
    npc_controller.addChild(new Knight(s2d, 20, 30));
    
    s2d.addChild(npc_controller);

    var gsp = new GoblinSpawner(s2d, npc_controller);

    
    tar_anim_tiles.push(hxd.Res.target.target_00.toTile());
    tar_anim_tiles.push(hxd.Res.target.target_01.toTile());
    tar_anim_tiles.push(hxd.Res.target.target_02.toTile());
    tar_anim_tiles.push(hxd.Res.target.target_03.toTile());
    tar_anim_tiles.push(hxd.Res.target.target_04.toTile());
    tar_anim_tiles.push(hxd.Res.target.target_05.toTile());
    tar_anim = new Anim(tar_anim_tiles, 10, s2d);
    tar_anim.visible = false;

  }

  override function update(dt:Float) {
    if( hxd.Key.isPressed(hxd.Key.MOUSE_RIGHT)) {
      target.x = s2d.mouseX - 16;
      target.y = s2d.mouseY - 16;
      tar_anim.x = target.x;
      tar_anim.y = target.y;
      tar_anim.loop = false;
      tar_anim.visible = true;
      tar_anim.play(tar_anim_tiles, 0);
      if(tar_sound != null) tar_sound.play();
      tar_anim.onAnimEnd = function () {
        tar_anim.visible = false;
      }
      active_npc.setTarget(new Point(s2d.mouseX, s2d.mouseY));
    }
    if ( hxd.Key.isPressed(hxd.Key.MOUSE_LEFT)) {
      for( i in 0...npc_controller.numChildren){
        var npc:Npc = cast(npc_controller.getChildAt(i), Npc);
        if(npc.getBounds().contains(new Point(s2d.mouseX, s2d.mouseY))){
          npc.activate();
          active_npc = npc;
        }else{
          npc.deactivate();
        }
      }
    }

    for( i in 0...npc_controller.numChildren) {
      var npc:Npc = cast(npc_controller.getChildAt(i), Npc);
      for (j in 0...npc_controller.numChildren) {
        var n:Npc = cast(npc_controller.getChildAt(j), Npc);
        if(n == npc) continue;
        if(npc.getBounds().intersects(n.getBounds())){
          //TODO: fix stuck npcs in top left corner
          var vx:Float = npc.getBounds().intersection(n.getBounds()).xMax - n.getBounds().xMax;
          var vy:Float = npc.getBounds().intersection(n.getBounds()).yMax - n.getBounds().yMax;

          npc.setDir(vx,vy);
          continue;
        }
      }
    }
    super.update(dt);
  }

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
