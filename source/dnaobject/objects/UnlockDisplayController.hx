package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxColor;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class UnlockDisplayController implements DnaObject implements DnaEventSubscriber implements IUnlockableItem extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("UnlockDisplayController");
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	/**
	 * sets the unlockable to the monster and we also remember it for the button press.
	 * @param value 
	 */
	public function setUnlockable(value:Dynamic)
	{
		this.unlockable = value;
		preview_obj.setAssetPath(unlockable.preview);
	}

	public var button(default, set):String = "";
	public var background(default, set):String = "";
	public var preview(default, set):String = "";

	public function set_preview(value:String):String
	{
		preview = value;
		if (this.getParent() == null)
		{
			return value;
		}
		this.preview_obj = cast this.getParent().getObjectByName(preview);
		return preview;
	}

	public function set_button(value:String):String
	{
		button = value;
		if (this.getParent() == null)
		{
			return value;
		}
		this.button_obj = cast this.getParent().getObjectByName(button);
		button_obj.onPressCallback = unlockMe;
		return button;
	}

	public function set_background(value:String):String
	{
		background = value;

		if (this.getParent() == null)
		{
			return value;
		}
		this.background_obj = cast this.getParent().getObjectByName(background);
		return background;
	}

	public var button_obj:DnaButtonObject;
	public var background_obj:NineSliceSprite;
	public var preview_obj:SpriteObject;

	public var unlockable:Dynamic;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// //trace("trialhabdler from file:", jsonFile);
		if (Reflect.hasField(jsonFile, "button"))
		{
			set_button(cast jsonFile.button);
		}
		if (Reflect.hasField(jsonFile, "preview"))
		{
			set_preview(cast jsonFile.preview);
		}
		if (Reflect.hasField(jsonFile, "background"))
		{
			set_background(cast jsonFile.background);
		}

		super.fromFile(jsonFile);
	}

	public var choosen(never, set):Bool;

	public function set_choosen(value:Bool):Bool
	{
		if (value)
		{
			FlxTween.color(preview_obj.sprite, 0.5, FlxColor.GRAY, FlxColor.WHITE, {type: PINGPONG, ease: FlxEase.cubeInOut});
		}
		else
		{
			FlxTween.color(preview_obj.sprite, 0.5, FlxColor.WHITE, FlxColor.BLACK, {type: ONESHOT, ease: FlxEase.cubeInOut});
		}
		return value;
	}

	/**
	 * this unlocks the montipart
	 * [Description]
	 */
	public function unlockMe()
	{
		trace("now unlocking montipart:", unlockable);
		var unlocked = DnaDataManager.instance.unlockMontyPart(this.unlockable);
		for (unlock in getParent().getObjectsByType("UnlockDisplayController"))
		{
			if (unlock != this)
			{
				var ul:UnlockDisplayController = cast unlock;
				ul.choosen = false;
			}
		}
		this.choosen = true;

		trace("unlocked montipart:", unlocked);
	}
}
