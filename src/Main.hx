import hxd.snd.Manager;
import h2d.Text;
import h2d.Font;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Anim;
import h2d.col.Point;
import h2d.Object;
import Npc;
import Building;
import hxd.snd.Channel;
import hxd.res.Sound;

class Main extends hxd.App {
	var font:Font = null;
	var tf:Text = null;
	var music:Channel = null;

	var target:Point = new Point(0.0, 0.0);

	var npcs:Array<Npc> = [];

	var tar_anim:Anim = null;

	var tar_anim_tiles:Array<Tile> = [];

	var tar_sound:Sound = null;

	var npc_controller:Object = null;
	var friendly_npc_controller:Object = null;

	var active_npc:Npc = null;
	var tower:Tower = null;
	var mine:GoldMine = null;

	var gold:Int = 0;
	var score:Int = 0;

  var started:Bool = false;

	function start() {
		s2d.scaleMode = Zoom(1.5);
    s2d.camera.follow = null;
    s2d.camera.x = 0;
    s2d.camera.y = 0;
		s2d.camera.anchorX = 0;
		s2d.camera.anchorY = 0;

		var bg:Bitmap = new Bitmap(Tile.fromColor(0x3a1c3e, s2d.width, s2d.height, 1), s2d);
		s2d.addChild(bg);

    gold = 0;
    
    npc_controller = new Object();
    friendly_npc_controller = new Object();

		for (i in 0...1)
			npc_controller.addChild(new Goblin(s2d, 10, 10));
		friendly_npc_controller.addChild(new Knight(s2d, 20, 30));

		s2d.addChild(npc_controller);
		s2d.addChild(friendly_npc_controller);

		var gsp = new GoblinSpawner(s2d, npc_controller);
		tower = new Tower(s2d);
		mine = new GoldMine(s2d);
		mine.x = 600;
		mine.y = 200;

		tar_anim_tiles.push(hxd.Res.target.target_00.toTile());
		tar_anim_tiles.push(hxd.Res.target.target_01.toTile());
		tar_anim_tiles.push(hxd.Res.target.target_02.toTile());
		tar_anim_tiles.push(hxd.Res.target.target_03.toTile());
		tar_anim_tiles.push(hxd.Res.target.target_04.toTile());
		tar_anim_tiles.push(hxd.Res.target.target_05.toTile());
		tar_anim = new Anim(tar_anim_tiles, 10, s2d);
		tar_anim.visible = false;
	}

	override function init() {
		super.init();
		font = hxd.res.DefaultFont.get();

		var musicResource:Sound = null;
		if (hxd.res.Sound.supportedFormat(Wav)) {
			musicResource = hxd.Res.sound.track1;
			tar_sound = hxd.Res.sound.click;
		}

		if (musicResource != null) {
			music = musicResource.play(true);
		}
	}

	override function update(dt:Float) {
		if (started) {
			if (tf == null) {
				tf = new Text(font);
				s2d.addChild(tf);
			}

			if (npc_controller.numChildren >= 10) {
				tf.setPosition(-1000.0, -1000.0);
				s2d.camera.anchorX = 0.5;
				s2d.camera.anchorY = 0.25;
				s2d.camera.follow = tf;
				s2d.scaleMode = Zoom(3.5);
				tf.text = "Game Over!\n\nyou got: " + score + " points\n\nSPACE - to try again";
				tf.textColor = 0x185825;
				tf.textAlign = Center;

				if (hxd.Key.isPressed(hxd.Key.SPACE)) {
					s2d.removeChildren();
          npc_controller.remove();
          friendly_npc_controller.remove();
					tf = null;
          started = false;
				}

				super.update(dt);
				return;
			}

			tf.setPosition(300.0, 10.0);
			tf.textAlign = Center;
			tf.textColor = 0xFFFF00;
			tf.text = "gold: " + gold;

			if (Math.random() * 100 < 1 && !mine.isBroken()) {
				gold += 1;
				mine.mine();
			}
			if (tower.isActive()) {
				tower.checkPrice(gold);
			}
			if (hxd.Key.isPressed(hxd.Key.MOUSE_RIGHT)) {
				if (active_npc != null) {
					target.x = s2d.mouseX - 16;
					target.y = s2d.mouseY - 16;
					tar_anim.x = target.x;
					tar_anim.y = target.y;
					tar_anim.loop = false;
					tar_anim.visible = true;
					tar_anim.play(tar_anim_tiles, 0);
					if (tar_sound != null)
						tar_sound.play();
					tar_anim.onAnimEnd = function() {
						tar_anim.visible = false;
					}
					active_npc.setTarget(new Point(s2d.mouseX, s2d.mouseY));
				}
			}
			if (hxd.Key.isPressed(hxd.Key.MOUSE_LEFT)) {
				if (active_npc != null) {
					active_npc.deactivate();
					active_npc = null;
				}
				if (tower.isActive()) {
					if (tower.getRecruitbuttonBounds().contains(new Point(s2d.mouseX, s2d.mouseY))) {
						if (gold >= 10) {
							friendly_npc_controller.addChild(new Knight(s2d, tower.x, tower.y + 32));
							gold -= 10;
						}
					} else {
						tower.deactivate();
					}
				}
				if (tower.getBounds().contains(new Point(s2d.mouseX, s2d.mouseY))) {
					if (!tower.isActive())
						tower.activate();
				}

				for (i in 0...friendly_npc_controller.numChildren) {
					var npc:Npc = cast(friendly_npc_controller.getChildAt(i), Npc);
					if (npc.getBounds().contains(new Point(s2d.mouseX, s2d.mouseY))) {
						npc.activate();

						active_npc = npc;
						continue;
					}
				}
			}
			if (hxd.Key.isPressed(hxd.Key.M)) {
				if (Manager.get().masterVolume >= 1.0)
					Manager.get().masterVolume = 0.0;
				else
					Manager.get().masterVolume = 1.0;
			}

			for (i in 0...npc_controller.numChildren) {
				var npc:Npc = cast(npc_controller.getChildAt(i), Npc);
				for (j in 0...friendly_npc_controller.numChildren) {
					var n:Npc = cast(friendly_npc_controller.getChildAt(j), Npc);
					if (n == npc)
						continue;
					if (npc.getBounds().intersects(n.getBounds())) {
						var vx:Float = npc.getBounds().intersection(n.getBounds()).xMax - n.getBounds().xMax;
						var vy:Float = npc.getBounds().intersection(n.getBounds()).yMax - n.getBounds().yMax;

						npc.attack(n);
						if (n.attack(npc)) {
							gold += 1;
							score += 1;
						}
						continue;
					}
				}
			}
		} else {
      if(tf == null) {
        tf = new Text(font);
        s2d.addChild(tf);
      }
      tf.setPosition(-1000.0, -1000.0);
      s2d.scaleMode = Zoom(2.5);
			s2d.camera.anchorX = 0.5;
			s2d.camera.anchorY = 0.25;
      tf.text = "Welcome to Goblona! \n\nSPACE -to Start\nM - to mute sound";
      tf.textColor = 0x185825;
      tf.textAlign = Center;
      s2d.camera.follow = tf;
      if(hxd.Key.isPressed(hxd.Key.SPACE)){
        start();
        started = true;
        s2d.removeChild(tf);
        tf = null;
      }
    }
		super.update(dt);
	}

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
