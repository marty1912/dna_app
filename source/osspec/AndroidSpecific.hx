package osspec;

import dnaobject.classes.FlxSoundWrapper;
import dnaobject.interfaces.ISoundObject;
import extension.eightsines.EsOrientation;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxSave;
import openfl.utils.Assets;
import osspec.OsSpecific;

/**
 * class AndroidSpecific
 * any code that is specific to Android systems goes into this class
 */
class AndroidSpecific implements OsSpecific
{
	/**
	 * constructor - we do not do anything in here. but we need one so here it is.
	 */
	public function new() {};

	/**
	 * public function toLandscapeMode()
	 * this function sets the screen orientation to landscape.
	 */
	public function getOsInfo():String
	{
		return "Android";
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
	 * saveFile. lets the user save a file. (only really used for javascript)
	 * @param content 
	 * @param filename 
	 */
	public function saveFile(content:String, filename:String):Void {}

	/**
	 * this returns the server URL. this will differ for example from web to others.
	 * @return String
	 */
	public function getServerUrl():String
	{
		return "https://dna-backend.casacam.net/student_data/api/";
		//return "https://143.50.35.159/student_data/api/";
		// return "http://192.168.1.241:8000/student_data/api/";
	}

	/**
	 * public function toLandscapeMode -
	 * this function sets the Screen orientation to "Landscape"
	 */
	public function toLandscapeMode()
	{
		EsOrientation.setScreenOrientation(EsOrientation.ORIENTATION_LANDSCAPE);
	}

	/**
	 * toFullScreen() - activates fullscreen mode.
	 */
	public function toFullscreen():Void {}

	/**
	 * public function getInputPosition() -
	 * this function returns the current mouse or touch position for the specific target.
	 * @return FlxPoint - the position of the mouse or the touch or whatever we have
	 */
	public function getInputPosition():FlxPoint
	{
		return FlxG.touches.getFirst().getPosition();
	};

	/**
	 * saveToStorage - this function saves data to storage.
	 * @param data - the data to store
	 * @param filename - the filename to use
	 */
	public function saveToStorage(data:Dynamic, filename:String):Void
	{
		var save_slot:FlxSave = new FlxSave();
		save_slot.bind(filename);
		Reflect.setProperty(save_slot.data, filename, data);
		save_slot.flush();
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
			var save_slot:FlxSave = new FlxSave();
			save_slot.bind(filename);
			return Reflect.getProperty(save_slot.data, filename);
		}
		catch (e)
		{
			return null;
		}
	}
}
