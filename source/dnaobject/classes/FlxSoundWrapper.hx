package dnaobject.classes;


import flixel.FlxG;
import dnaobject.interfaces.ISoundObject;
import flixel.system.FlxSound;

class FlxSoundWrapper implements ISoundObject
{
	public var soundPath:String;

	public function new(snd:String)
	{
		soundPath = snd;
	}

	/**
	 * plays the sound
	 */
	public function play():Void
	{
		//sound.play();
		try{
			FlxG.sound.play(soundPath);
		}
	}
}
