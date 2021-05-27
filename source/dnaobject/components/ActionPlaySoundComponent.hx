package dnaobject.components;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnadata.DnaDataManager;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.interfaces.IResourcePath;
import dnaobject.interfaces.ISoundObject;
import dnaobject.interfaces.Slideable;
import dnaobject.objects.NumberlineObject;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;
import flixel.util.FlxDestroyUtil;
import howler.Howl.HowlOptions;
import howler.Howl;
import locale.LocaleManager;
import openfl.utils.Assets;
import osspec.OsManager;

/**
 * class Playsound component
 * it plays sound.
 */
class ActionPlaySoundComponent implements DnaComponent extends DnaActionBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('ActionPlaySoundComponent');
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		// this.sound.destroy();
		super.destroy();
	}

	public var audio_type:String = "audio_volume_master";
	public var path:String;

	// TODO: use this so we can have sound on ios: https://github.com/adireddy/haxe-howler/blob/master/samples/Main.hx
	// howlerjs
	// public var sound:FlxSound;
	public var sound:ISoundObject;
	public var from_locale:Bool = false;

	public function setupSound()
	{
		if (target_resource != "")
		{
			var res:IResourcePath = cast getParent().getParent().getObjectByName(target_resource);
			path = res.getResource();
		}

		if (path == "")
		{
			return;
		}

		if (from_locale)
		{
			path = LocaleManager.getInstance().getAudioPath(path);
		}

		// we use this because the default sound does not work on ios browsers.
		sound = OsManager.get_instance().getSoundObject(path);
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		if (Reflect.hasField(jsonFile, "audio_type"))
		{
			this.audio_type = jsonFile.audio_type;
		}
		if (Reflect.hasField(jsonFile, "from_locale"))
		{
			this.from_locale = jsonFile.from_locale;
		}
		if (Reflect.hasField(jsonFile, "path"))
		{
			this.path = jsonFile.path;
		}
		if (Reflect.hasField(jsonFile, "target_resource"))
		{
			this.target_resource = jsonFile.target_resource;
		}

		// setupSound();
		super.fromFile(jsonFile);
	}

	public var target_resource:String = "";

	/**
	 * @param numline_name - the name of the numberline to check.
	 */
	public function setVolumeToSlider(numline_name:String)
	{
		var numline:Slideable = cast(getParent().getParent().getObjectByName(numline_name));
		numline.setSliderNum(DnaDataManager.instance.retrieveData(audio_type));
	}

	/**
	 * this will be called when the action is started. for the first time
	 */
	override public function onHaveParent()
	{
		super.onHaveParent();
		setupSound();
		sound.play();
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
