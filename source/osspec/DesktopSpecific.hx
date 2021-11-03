package osspec;

import Assertion.*;
import dnaobject.classes.FlxSoundWrapper;
import dnaobject.interfaces.ISoundObject;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import openfl.utils.Assets;
import osspec.OsSpecific;

/**
 * class DesktopSpecific
 * code that is specific to Desktop systems goes into this class
 */
class DesktopSpecific implements OsSpecific
{
	/**
	 * constructor - we dont need to do anything here.
	 */
	public function new() {};

	/**
	 * saveFile. lets the user save a file. (only really used for javascript)
	 * @param content 
	 * @param filename 
	 */
	public function saveFile(content:String, filename:String):Void {}

	/**
	 * public function toLandscapeMode()
	 * this function sets the screen orientation to landscape.
	 */
	public function getOsInfo():String
	{
		return "Desktop";
	}

	/**
	 * this returns the server URL. this will differ for example from web to others.
	 * @return String
	 */
	public function getServerUrl():String
	{
		// return"http://localhost:8000/student_data/api/";
		return "https://dna-backend.casacam.net/student_data/api/";
		//return "https://143.50.35.159/student_data/api/";
	}

	/**
	 * toFullScreen() - activates fullscreen mode.
	 */
	public function toFullscreen():Void {}

	/**
	 * public function toLandscapeMode
	 * this function is not really needed on Desktop Targets so we leave it blank
	 */
	public function toLandscapeMode() {}

	/**
	 * public function getInputPosition() -
	 * this function returns the current mouse or touch position for the specific target.
	 * @return FlxPoint - the position of the mouse or the touch or whatever we have
	 */
	public function getInputPosition():FlxPoint
	{
		return FlxG.mouse.getPosition();
	};

	/**
	 * saveToStorage - this function saves data to storage.
	 * @param data - the data to store
	 * @param filename - the filename to use
	 */
	public function saveToStorage(data:Dynamic, filename:String):Void
	{
		var path = new haxe.io.Path(filename);
		var datastring:String = haxe.Json.stringify(data);
		sys.io.File.saveContent(path.toString(), datastring);
	}

	/**
	 * deleteStorage- this function saves data to storage.
	 * @param data - the data to store
	 * @param filename - the filename to use
	 */
	public function eraseStorage(filename:String):Void
	{
		// we dont actually do anything here atm..
		return;
	}



	/**
	 * returns a howler sound object that will work on every available browser. 
	 * @param path 
	 * @return ISoundObject
	 */
	public function getSoundObject(path:String):ISoundObject
	{
		// for better compatability we will use the ".ogg" files on desktop targets.
		// mp3 does not seem to work..
		var file_ext_index = path.indexOf(".mp3");
		// if we have a mp3 file we need to use the ogg instead
		if (file_ext_index != -1)
		{
			path = path.substring(0, file_ext_index) + ".ogg";
		}

		/*
		var sound:FlxSound = new FlxSound();
		sound.loadEmbedded(Assets.getSound(path));
		*/
		return new FlxSoundWrapper(path);
	}

	/**
	 * read from Storage - this function reads data from storage.
	 * @param filename - the filename where your data is stored.
	 * @return Dynamic - returns the data stored at the specified location.
	 */
	public function readFromStorage(filename:String):Dynamic
	{
		try
		{
			var path = new haxe.io.Path(filename);
			var datastring:String = sys.io.File.getContent(path.toString());
			return haxe.Json.parse(datastring);
		}
		catch (e)
		{
			return null;
		}
	}
}
