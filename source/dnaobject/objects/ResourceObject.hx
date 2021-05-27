package dnaobject.objects;

import dnaobject.interfaces.IResourcePath;
import dnaobject.interfaces.Scrollable;
import flixel.addons.display.FlxBackdrop;

/**
 * class BackgroundObject
 * this class represents our Numberline. it is a Group of FlxBasic objects
 *
 */
class ResourceObject implements DnaObject implements IResourcePath extends DnaObjectBase
{
	/**
	 * we basically only store a string in here. 
	 */
	public var path:String = "";

	/**
	 * sets the path
	 */
	public function setResource(value:String):Void
	{
		path = value;
	}

	/**
	 * returns the path
	 */
	public function getResource():String
	{
		return path;
	}

	/**
	 * constructor.
	 */
	public function new()
	{
		super('ResourceObject');
	}

	/**
	 * backdrop can read every constant it uses from a file..
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "path"))
		{
			this.path = jsonFile.path;
		}
		super.fromFile(jsonFile);
	}
}
