import hxd.snd.Channel;
import hxd.res.Sound;

class Main extends hxd.App {
	
  var font:h2d.Font = null;
	var music:Channel = null;

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
  }

	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}
