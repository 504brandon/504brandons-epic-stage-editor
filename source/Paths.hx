package;

import flixel.graphics.frames.FlxAtlasFrames;

class Paths {
    public static function getSparrowAtlas(name:String = "") {
        return FlxAtlasFrames.fromSparrow('assets/images/$name.png', 'assets/images/$name.xml');
    }
}