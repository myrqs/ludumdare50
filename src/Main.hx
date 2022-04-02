import h2d.Tile;
import h2d.Anim;
import h2d.col.Point;
import Npc;
import hxd.snd.Channel;
import hxd.res.Sound;

class Main extends hxd.App {
	
  var font:h2d.Font = null;
	var music:Channel = null;

  var target:Point = new Point(0.0, 0.0);

  var npcs:Array<Npc> = [];

  var tar_anim:Anim = null;

  var tar_anim_tiles:Array<Tile> = [];

  override function init() {
    super.init();

    s2d.scaleMode = Zoom(2.5);

		font = hxd.res.DefaultFont.get();

		var musicResource:Sound = null;
		if (hxd.res.Sound.supportedFormat(Wav)) {
			musicResource = hxd.Res.sound.track1;
		}

		if (musicResource != null) {
			music = musicResource.play(true);
		}
    for(i in 0...10) npcs.push(new Goblin(s2d));
    
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
      
    }
    if( target.x != 0.0 || target.y != 0.0){
      for (npc in npcs) {
        if(target.x-16 != npc.x && target.y-16 != npc.y){
          npc.followBounds(tar_anim.getBounds());
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
