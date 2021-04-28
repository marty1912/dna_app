package dnaobject.components;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnadata.DnaDataManager;
import dnanetwork.DnaNetworkManager;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.Slideable;
import dnaobject.objects.NumberlineObject;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import haxe.CallStack.StackItem;
import haxe.Http;
import haxe.Json;
import haxe.Serializer;
import haxe.crypto.Hmac;
import haxe.io.Bytes;
import lime.net.HTTPRequest;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.SecurityErrorEvent;
import openfl.net.URLLoader;
import openfl.net.URLLoaderDataFormat;
import openfl.net.URLRequest;
import openfl.net.URLRequestHeader;
import openfl.net.URLRequestMethod;
import osspec.OsManager;

/**
 * class PositionComponent.
 * this component keeps its parent in the center of the screen.
 */
class ActionSaveDataComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('ActionSaveDataComponent');
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);
	}

	/**
	 * override because of the first parameter..
	 */
	override public function finishAction()
	{
		first = true;
		super.finishAction();
	}

	/**
	 * uploadData - uploads data to the server.
	 */
	public function saveData():Void
	{
		// trace("now saving data.");

		var body:String = Json.stringify(DnaDataManager.instance.getAllData());
		OsManager.get_instance().saveFile(body, "data_" + DnaDataManager.instance.retrieveData('participant_uuid') + ".json");
	}

	public var first:Bool = true;

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		if (first)
		{
			saveData();
			first = false;
		}
		// //trace("loader bytes:", loader.bytesLoaded, "/", loader.bytesTotal);
	}
}
