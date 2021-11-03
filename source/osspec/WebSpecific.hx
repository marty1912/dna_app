package osspec;

import flixel.system.FlxSound;
import dnaobject.classes.HowlerSoundWrapper;
import dnaobject.interfaces.ISoundObject;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.util.FlxSave;
import howler.Howl.HowlOptions;
import howler.Howl;
import js.FullScreenApi;
import js.html.FileSaver;
import osspec.OsSpecific;
import dnaobject.classes.FlxSoundWrapper;
import openfl.utils.Assets;

/**
 * class WebSpecific
 * any code that is specific to the html target goes into this class
 */
class WebSpecific implements OsSpecific
{
	/**
	 * empty constructor - we just want the functions
	 */
	public function new() {};

	/**
	 * this returns the server URL. this will differ for example from web to others.
	 * @return String
	 */
	public function getServerUrl():String
	{
		// return "http://localhost:8000/student_data/api/";
		return "https://dna-backend.casacam.net/student_data/api/";
		//return "https://143.50.35.159/student_data/api/";
	}

	/**
	 * public function toLandscapeMode()
	 * this function sets the screen orientation to landscape.
	 */
	public function getOsInfo():String
	{
		return "web";
	}

	/**
	 * saveFile. lets the user save a file. (only really used for javascript)
	 * @param content 
	 * @param filename 
	 */
	public function saveFile(content:String, filename:String):Void
	{
		var blob:js.html.Blob = new js.html.Blob([content], {type: "text/plain"});
		FileSaver.saveAs(blob, filename);
	}

	/**
	 * public function toLandscapeMode -
	 * this function changes the screen orientation to landscape mode.
	 * nothing yet done for web target.
	 */
	public function toLandscapeMode()
	{
		// TODO: browsers do not allow for this because a change to fullscreen must only be done on user interaction
		// https://stackoverflow.com/questions/9454125/javascript-request-fullscreen-is-unreliable
		// FlxG.fullscreen = true;
		FlxG.fullscreen = true;
	}

	/**
	 * returns a howler sound object that will work on every available browser. 
	 * @param path 
	 * @return ISoundObject
	 */
	public function getSoundObject(path:String):ISoundObject
	{
		// for better compatability we will use the ".mp3" files on web targets.
		// ogg does not seem to work on ios
		var file_ext_index = path.indexOf(".ogg");
		// if we have a mp3 file we need to use the ogg instead
		if (file_ext_index != -1)
		{
			path = path.substring(0, file_ext_index) + ".mp3";
		}


		// trying to use the default sound for now.
		/*
		var sound:FlxSound = new FlxSound();
		sound.loadEmbedded(Assets.getSound(path));
		*/
		return new FlxSoundWrapper(path);
		// trying to use the default sound for now.

		var options:HowlOptions = {};
		options.src = [path];
		options.autoplay = false;
		options.loop = false;
		var sound = new Howl(options);
		return new HowlerSoundWrapper(sound);
	}

	/**
	 * toFullScreen() - activates fullscreen mode.
	 */
	public function toFullscreen():Void
	{
		FullScreenApi.requestFullScreen(js.Browser.window.document.getElementById("openfl-content"));
		js.Syntax.code("var lockFunction =  window.screen.orientation.lock;
			if (lockFunction.call(window.screen.orientation, 'landscape')) {
           		console.log('Orientation locked')
        	} else {
            	console.error('There was a problem in locking the orientation')
        	}
			");
		FlxG.scaleMode = new RatioScaleMode(false);
	}

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
