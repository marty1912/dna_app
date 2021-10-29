package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class LevelSelectPreview implements DnaObject implements DnaEventSubscriber implements ILevelPreview extends DnaObjectBase
{
	public var button:String = "";
	public var preview:String = "";
	public var preview_area:String = "";
	public var done_overlay:String = "";
	public var lock_overlay:String = "";

	public var button_obj:DnaButtonObject;
	public var preview_obj:SpriteObject;
	public var preview_area_obj:SpriteObject;
	public var done_overlay_obj:SpriteObject;
	public var lock_overlay_obj:SpriteObject;

	public var trial_block(default, set):TrialBlock;

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("LevelSelectPreview");
	}

	public function set_trial_block(value:TrialBlock):TrialBlock
	{
		this.trial_block = value;
		this.preview_obj = cast this.getParent().getObjectByName(getNestedObjectName(preview));
		preview_obj.setAssetPath(trial_block.preview);

		if (trial_block.locked == true)
		{
			trace("locked!");
			lock_overlay_obj.removeChild(lock_overlay_obj.sprite);
			lock_overlay_obj.addChild(lock_overlay_obj.sprite);
			lock_overlay_obj.visible = true;
			lock_overlay_obj.loadAsset();
			// DEBUG comment to disable LOCKED :
			 button_obj.setNextState(new ButtonStateInactive());
		}
		if (trial_block.done == true)
		{
			done_overlay_obj.removeChild(done_overlay_obj.sprite);
			done_overlay_obj.addChild(done_overlay_obj.sprite);
			done_overlay_obj.visible = true;
			done_overlay_obj.loadAsset();
			button_obj.setNextState(new ButtonStateInactive());
		}

		return trial_block;
	}

	public function setTrialBlock(value:TrialBlock)
	{
		set_trial_block(value);
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	public function onButtonPress():Void
	{
		trial_block.load();

		var action = DnaComponentFactory.create("ActionStateSwitchComponent");
		cast(action, ActionStateSwitchComponent).next_state = "NEXT_TASK";
		this.addComponent(action);
	}

	override public function onReady()
	{
		// setup our button
		this.button_obj = cast this.getParent().getObjectByName(getNestedObjectName(button));
		button_obj.onPressCallback = onButtonPress;
		this.preview_obj = cast this.getParent().getObjectByName(getNestedObjectName(preview));
		this.done_overlay_obj = cast this.getParent().getObjectByName(getNestedObjectName(done_overlay));
		this.lock_overlay_obj = cast this.getParent().getObjectByName(getNestedObjectName(lock_overlay));
		this.preview_area_obj = cast this.getParent().getObjectByName(getNestedObjectName(preview_area));
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
			this.button = jsonFile.button;
		}
		if (Reflect.hasField(jsonFile, "preview"))
		{
			this.preview = jsonFile.preview;
		}
		if (Reflect.hasField(jsonFile, "preview_area"))
		{
			this.preview_area = jsonFile.preview_area;
		}
		if (Reflect.hasField(jsonFile, "done_overlay"))
		{
			this.done_overlay = jsonFile.done_overlay;
		}
		if (Reflect.hasField(jsonFile, "lock_overlay"))
		{
			this.lock_overlay = jsonFile.lock_overlay;
		}
	}

	/**
	 * override the function so we can move all the nested objects as well.
	 * and keep the relative positions
	 * @param x 
	 * @param y 
	 */
	override public function moveTo(x:Float, y:Float)
	{
		preview_area_obj.moveTo(x, y);
		/*
			for (obj in this.nested_objects)
			{
				obj.moveTo(this.pos_x - obj.pos_x, this.pos_y - obj.pos_y);
			}
		 */
		super.moveTo(x, y);
	}
}
