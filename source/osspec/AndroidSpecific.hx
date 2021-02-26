package osspec;

import extension.eightsines.EsOrientation;
import flixel.FlxG;
import flixel.math.FlxPoint;
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
	 * this returns the server URL. this will differ for example from web to others.
	 * @return String
	 */
	public function getServerUrl():String
	{
		// local ip so we can test over wifi
		return "http://192.168.1.241:8000/student_data/api/";
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
		var path = new haxe.io.Path(filename);
		var datastring:String = haxe.Json.stringify(data);
		sys.io.File.saveContent(path.toString(), datastring);
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
