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
class ActionUploadDataComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('ActionUploadDataComponent');
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
	 * this will be registered as a listener on ONCOMPLETE for the URL loader.
	 * @param Event
	 */
	public function onUploadComplete(event:Event):Void
	{
		trace("upload complete!!! event:", event);
		trace("loader data:", loader.data);
		DnaEventManager.instance.broadcastEvent("UPLOAD_COMPLETE");
		this.finishAction();
	}

	public function IOEErrorHandler(e:IOErrorEvent)
	{
		trace("event ioerror");
		trace("e: ", e);
		DnaEventManager.instance.broadcastEvent("UPLOAD_ERROR");
		this.finishAction();
	}

	public function SecEvHandler(e:SecurityErrorEvent)
	{
		trace("event secerror");
		trace("e: ", e);
		DnaEventManager.instance.broadcastEvent("UPLOAD_ERROR");
		this.finishAction();
	}

	public var loader:URLLoader;

	/**
	 * uploadData - uploads data to the server.
	 */
	public function uploadData():Void
	{
		trace("now uploading data.");
		var body:String = Json.stringify(DnaDataManager.instance.getAllData());
		loader = new URLLoader();

		loader.addEventListener(Event.COMPLETE, onUploadComplete);
		loader.addEventListener(IOErrorEvent.IO_ERROR, IOEErrorHandler);
		loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, SecEvHandler);
		var request:URLRequest = DnaNetworkManager.getSignedRequest(body);
		request.data = body.toString();
		request.method = URLRequestMethod.POST;
		loader.dataFormat = URLLoaderDataFormat.TEXT;
		loader.load(request);
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
			uploadData();
			first = false;
		}
		// trace("loader bytes:", loader.bytesLoaded, "/", loader.bytesTotal);
	}
}
