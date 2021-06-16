package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class LevelSelectPreview implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("LevelSelectPreview");
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
	public var preview(default, set):String = "";

	public function set_preview(value:String):String
	{
		preview = value;
		if (this.getParent() == null)
		{
			return value;
		}
		this.preview_obj = cast this.getParent().getObjectByName(getNestedObjectName(preview));
		return preview;
	}

	public function set_button(value:String):String
	{
		button = (value);
		if (this.getParent() == null)
		{
			return value;
		}
		trace("button:", button);
		this.button_obj = cast this.getParent().getObjectByName(getNestedObjectName(button));

		if (this.button_obj == null)
		{
			return value;
		}
		button_obj.onPressCallback = startTask;
		return button;
	}

	public function startTask():Void
	{
		trace(this.obj_name, "starting task now..");
	}

	public var button_obj:DnaButtonObject;
	public var preview_obj:NineSliceSprite;

	public var unlockable:Dynamic;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "button"))
		{
			set_button(cast jsonFile.button);
		}
		if (Reflect.hasField(jsonFile, "preview"))
		{
			set_preview(cast jsonFile.preview);
		}
		this.set_button(this.button);
		this.set_preview(this.preview);
	}
}
