package dnaobject.objects;

import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TaskTrials;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
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

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	override public function onReady()
	{
		this.pattern_area_obj = cast getParent().getObjectByName(getNestedObjectName(pattern_area));
		trace("width:", pattern_area_obj.width, "height:", pattern_area_obj.width);
		setPattern(pattern_assets);
	}

	/**
	 * in here we setup our pattern
	 * @param asset_list 
	 */
	public function setPattern(asset_list:Array<String>)
	{
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
			sprite.setMaxDimensions(single_asset_width, single_asset_width);

			this.getParent().addObject(sprite);
			sprite.moveTo(pattern_area_obj.sprite.x + symbol_index * single_asset_width, pattern_area_obj.sprite.getMidpoint().y - (sprite.height / 2));
		}
	}

	public var pattern_area:String;
	public var pattern_assets:Array<String>;

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

		if (Reflect.hasField(jsonFile, "pattern_assets"))
		{
			this.pattern_assets = cast jsonFile.pattern_assets;
		}
	}

	public override function update(elapsed:Float) {}
}
