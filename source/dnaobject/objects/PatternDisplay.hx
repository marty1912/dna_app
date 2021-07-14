package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.SymbolSlotComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.tweens.FlxTween;
import haxe.Json;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class PatternDisplay implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("PatternDisplay");
	}

	override public function onHaveParent() {}

	override public function onReady()
	{
		super.onReady();
		this.getParent().eventManager.addSubscriberForEvent(this, DnaConstants.PATTERN_CHANGE);
		this.pattern_area_obj = cast getParent().getObjectByName(getNestedObjectName(pattern_area));
		setPattern(pattern_assets);
	}

	/**
	 * we will listen for the changed event.
	 * @param event 
	 * @param params 
	 */
	public function getNotified(event:String, ?params:Dynamic)
	{
		if (onPatternChanged != null)
		{
			onPatternChanged();
		}
	}

	/**
	 * returns the pattern that we have in this display.
	 */
	public function getPattern():Array<String>
	{
		var pattern = new Array<String>();
		for (symbol in this.symbols)
		{
			pattern.push(symbol.getAssetPath());
		}
		return pattern;
	}

	public var filled_fields(get, null):Int;

	public function get_filled_fields():Int
	{
		var filled = 0;
		for (sym in this.symbols)
		{
			var slot:SymbolSlotComponent = cast sym.getComponentByType("SymbolSlotComponent");
			if (slot != null && slot.filled)
			{
				filled++;
			}
		}
		return filled;
	}

	public var disabled(get, set):Bool;

	public function set_disabled(value:Bool):Bool
	{
		for (sym in this.symbols)
		{
			var slot:SymbolSlotComponent = cast sym.getComponentByType("SymbolSlotComponent");
			if (slot != null)
			{
				slot.disabled = value;
			}
		}
		return value;
	}

	public function get_disabled():Bool
	{
		for (sym in this.symbols)
		{
			var slot:SymbolSlotComponent = cast sym.getComponentByType("SymbolSlotComponent");
			if (slot != null)
			{
				return slot.disabled;
			}
		}
		return true;
	}

	public var fields_to_fill(get, null):Int;

	public function get_fields_to_fill():Int
	{
		var to_fill = 0;
		for (sym in this.symbols)
		{
			if (sym.getComponentByType("SymbolSlotComponent") != null)
			{
				to_fill++;
			}
		}
		return to_fill;
	}

	/**
	 * in here we setup our pattern
	 * @param asset_list 
	 */
	public function setPattern(asset_list:Array<String>)
	{
		// delete previous pattern:
		for (sym in symbols)
		{
			this.getParent().removeObject(sym.id);
		}
		while (symbols.length > 0)
		{
			symbols.pop();
		}

		// create new one.
		var single_asset_width = pattern_area_obj.width / asset_list.length;
		var single_asset_height = pattern_area_obj.height;
		for (symbol_index in 0...asset_list.length)
		{
			var asset = asset_list[symbol_index];
			var sprite:SpriteObject;
			if (asset == "")
			{
				sprite = cast DnaObjectFactory.create("SymbolSlot");
			}
			else
			{
				sprite = cast DnaObjectFactory.create("SpriteObject");
				sprite.setAssetPath(asset);
				sprite.loadAsset();
			}
			sprite.setMaxDimensions(single_asset_width, single_asset_height);

			this.getParent().addObject(sprite);
			// put in foreground:
			sprite.removeChild(sprite.sprite);
			sprite.addChild(sprite.sprite);

			var rest_width = single_asset_width - sprite.width;
			var rest_height = single_asset_height - sprite.height;
			sprite.moveTo(pattern_area_obj.sprite.x
				+ (rest_width / 2)
				+ symbol_index * single_asset_width, pattern_area_obj.sprite.y
				+ (rest_height / 2));
			symbols.push(sprite);
		}
	}

	public var pattern_area:String;
	public var pattern_assets:Array<String>;

	public var pattern_area_obj:SpriteObject;
	public var symbols:Array<SpriteObject> = new Array<SpriteObject>();

	/**
	 * callback that we will call whenever a symbol changes.
	 */
	public var onPatternChanged:Void->Void = null;

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

		if (Reflect.hasField(jsonFile, "pattern_assets"))
		{
			this.pattern_assets = cast jsonFile.pattern_assets;
		}
	}

	public override function update(elapsed:Float) {}
}
