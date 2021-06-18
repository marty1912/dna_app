package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class LevelSelectPreview implements DnaObject implements DnaEventSubscriber implements ILevelPreview extends DnaObjectBase
{
	public var button(default, set):String = "";
	public var preview(default, set):String = "";

	public var button_obj:DnaButtonObject;
	public var preview_obj:NineSliceSprite;
	public var trial_block:TrialBlock;

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("LevelSelectPreview");
	}

	public function setTrialBlock(trial_block:TrialBlock)
	{
		this.trial_block = trial_block;
		this.preview_obj = cast this.getParent().getObjectByName(getNestedObjectName(preview));
		preview_obj.setAssetPath(trial_block.preview);
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	public function set_preview(value:String):String
	{
		preview = value;
		if (this.getParent() == null)
		{
			return value;
		}
		return preview;
	}

	public function set_button(value:String):String
	{
		button = (value);
		return button;
	}

	override public function onReady()
	{
		// setup our button
		this.button_obj = cast this.getParent().getObjectByName(getNestedObjectName(button));
		button_obj.onPressCallback = startTask;
		this.preview_obj = cast this.getParent().getObjectByName(getNestedObjectName(preview));
	}

	public function startTask():Void
	{
		trial_block.load();

		var action = DnaComponentFactory.create("ActionStateSwitchComponent");
		cast(action, ActionStateSwitchComponent).next_state = "NEXT_TASK";
		this.addComponent(action);
	}

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
	}
}
