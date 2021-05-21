package dnaobject.classes;

import dnaobject.interfaces.ISoundObject;
import howler.Howl;

class HowlerSoundWrapper implements ISoundObject
{
	public var sound:Howl;

	public function new(snd:Howl)
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
