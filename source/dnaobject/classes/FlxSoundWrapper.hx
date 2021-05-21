package dnaobject.classes;

import dnaobject.interfaces.ISoundObject;
import flixel.system.FlxSound;

class FlxSoundWrapper implements ISoundObject
{
	public var sound:FlxSound;

	public function new(snd:FlxSound)
	{
		sound = snd;
	}

	/**
	 * plays the sound
	 */
	public function play():Void
	{
		sound.play();
	}
}
