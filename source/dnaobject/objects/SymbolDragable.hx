package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.DragableComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class SymbolDragable implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("SymbolDragable");
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	public var disabled(get, set):Bool;

	public function set_disabled(value:Bool):Bool
	{
		var drag:DragableComponent = cast this.symbol_obj.getComponentByType("DragableComponent");
		drag.disabled = value;
		return value;
	}

	public function get_disabled():Bool
	{
		var drag:DragableComponent = cast this.symbol_obj.getComponentByType("DragableComponent");
		return drag.disabled;
	}

	override public function onHaveParent() {}

	override public function onReady()
	{
		symbol_obj = cast getParent().getObjectByName(getNestedObjectName(symbol));
	}

	public var pattern_area:String;
	public var pattern_assets:Array<String>;

	public var symbol:String;
	public var symbol_obj:SpriteObject;

	public var pattern_area_obj:SpriteObject;
	public var fixed_symbols:Array<SpriteObject>;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "pattern_area"))
		{
			this.pattern_area = cast jsonFile.pattern_area;
		}

		if (Reflect.hasField(jsonFile, "symbol"))
		{
			this.symbol = cast jsonFile.symbol;
		}

		if (Reflect.hasField(jsonFile, "pattern_assets"))
		{
			this.pattern_assets = cast jsonFile.pattern_assets;
		}
	}

	public override function update(elapsed:Float) {}
}
