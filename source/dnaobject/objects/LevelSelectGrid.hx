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
import dnaobject.objects.DnaButtonObject.ButtonStateInactive;
import dnaobject.objects.DnaButtonObject.ButtonStateNormal;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import haxe.Json;
import haxe.Timer;
import lime.utils.PackedAssetLibrary;

/**
 * helper class to make stuff easier to handle.
 */
class Page
{
	public var parent:LevelSelectGrid;
	public var previews:Array<LevelSelectPreview> = new Array<LevelSelectPreview>();

	public final fly_time:Float = 0.5;

	public function new(parent:LevelSelectGrid)
	{
		this.parent = parent;
	}

	public function addPreview(preview:LevelSelectPreview)
	{
		previews.push(preview);
	}

	public var full(get, null):Bool;

	/**
	 * checks if the page is full already.
	 * @return Bool
	 */
	public function get_full():Bool
	{
		if (previews.length >= parent.getPreviewPositions().length)
		{
			return true;
		}
		return false;
	}

	public function appear()
	{
		var preview_index = 0;
		for (location in parent.getPreviewPositions())
		{
			if (preview_index >= previews.length)
			{
				break;
			}
			var preview:LevelSelectPreview = previews[preview_index];
			preview_index++;
			preview.moveTo(location.x, location.y);
			location.put();
		}
	}

	public function flyIn(from:FlxPoint)
	{
		var preview_index = 0;
		for (location in parent.getPreviewPositions())
		{
			if (preview_index >= previews.length)
			{
				break;
			}
			var preview:LevelSelectPreview = previews[preview_index];
			preview.moveTo(from.x, from.y);
			FlxTween.tween(preview, {pos_x: location.x, pos_y: location.y}, fly_time, {startDelay: preview_index * 0.1});
			location.put();
			preview_index++;
		}
	}

	public function flyOut(to:FlxPoint, fly_time = 0.5)
	{
		var preview_index = 0;
		for (preview in this.previews)
		{
			FlxTween.tween(preview, {pos_x: to.x, pos_y: to.y}, fly_time, {startDelay: preview_index * 0.1});
			preview_index++;
		}
	}
}

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class LevelSelectGrid implements DnaObject extends DnaObjectBase
{
	public final n_rows = 2;
	public final n_cols = 3;
	public var grid_area:String;
	public var button_left:String;
	public var button_right:String;
	public var grid_area_obj:SpriteObject;
	public var button_left_obj:DnaButtonObject;
	public var button_right_obj:DnaButtonObject;

	public var previews:Array<LevelSelectPreview> = new Array<LevelSelectPreview>();
	public var pages:Array<Page> = new Array<Page>();
	@:isVar
	public var page_index(get, set):Int = 0;

	public function get_page_index():Int
	{
		return page_index;
	}

	public function set_page_index(value:Int):Int
	{
		button_left_obj.setNextState(new ButtonStateNormal());
		button_right_obj.setNextState(new ButtonStateNormal());
		page_index = value;
		if (page_index <= 0)
		{
			page_index = 0;
			button_left_obj.setNextState(new ButtonStateInactive());
		}
		if (page_index >= pages.length - 1)
		{
			page_index = pages.length - 1;

			button_right_obj.setNextState(new ButtonStateInactive());
		}

		return page_index;
	}

	public final rightBottomCorner:FlxPoint = new FlxPoint(FlxG.width, FlxG.height);
	public final bottom:FlxPoint = new FlxPoint(FlxG.width / 2, FlxG.height);
	public final right:FlxPoint = new FlxPoint(FlxG.width, FlxG.height / 2);
	public final left:FlxPoint = new FlxPoint(-(FlxG.width * 0.2), FlxG.height / 2);

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("LevelSelectGrid");
	}

	/**
	 * this switches the page to the index.
	 * @param add_to_index 
	 */
	public function switchPage(add_to_index:Int)
	{
		var old_page = pages[page_index];
		page_index += add_to_index;
		var to:FlxPoint;
		var from:FlxPoint;
		if (add_to_index > 0)
		{
			to = left;
			from = right;
		}
		else
		{
			to = right;
			from = left;
		}

		var new_page = pages[page_index];
		old_page.flyOut(to);
		new_page.flyIn(from);
	}

	override public function onHaveParent() {}

	public function onBtnLeftPress()
	{
		switchPage(-1);
	}

	public function onBtnRightPress()
	{
		switchPage(1);
	}

	override public function onReady()
	{
		this.grid_area_obj = cast this.getParent().getObjectByName(getNestedObjectName(grid_area));
		this.button_left_obj = cast this.getParent().getObjectByName(getNestedObjectName(button_left));
		this.button_right_obj = cast this.getParent().getObjectByName(getNestedObjectName(button_right));
		// button_left_obj.setNextState(new ButtonStateInactive());
		// button_right_obj.setNextState(new ButtonStateInactive());
		button_left_obj.onPressCallback = onBtnLeftPress;
		button_right_obj.onPressCallback = onBtnRightPress;

		var preview_w = grid_area_obj.width / n_cols;
		var preview_h = grid_area_obj.height / n_rows;
		var trialBlocks = TaskTrials.instance.getTrialBlocks();
		var trial_block_index = 0;
		for (trial_block_index in 0...trialBlocks.length)
		{
			var preview:LevelSelectPreview = cast DnaObjectFactory.create("LevelSelectPreview");
			this.getParent().addObject(preview);
			preview.setupNestedObjects();
			preview.onReady();
			preview.moveTo(FlxG.width * 2, FlxG.height * 2);
			preview.setTrialBlock(trialBlocks[trial_block_index]);

			if (pages.length == 0 || pages[pages.length - 1].full)
			{
				pages.push(new Page(this));
			}
			pages[pages.length - 1].addPreview(preview);
		}

		if (pages.length == 0)
		{
			pages.push(new Page(this));
		}
		page_index = 0;
		/*
			for (page in pages)
			{
				page.flyOut(left);
			}
		 */
		pages[page_index].flyIn(bottom);
	}

	public function getPreviewPositions():Array<FlxPoint>
	{
		var positions = new Array<FlxPoint>();
		var preview_w = grid_area_obj.width / n_cols;
		var preview_h = grid_area_obj.height / n_rows;
		for (row in 0...n_rows)
		{
			for (col in 0...n_cols)
			{
				positions.push(FlxPoint.get(grid_area_obj.pos_x + col * preview_w, grid_area_obj.pos_y + row * preview_h));
			}
		}
		return positions;
	}

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "grid_area"))
		{
			this.grid_area = jsonFile.grid_area;
		}
		if (Reflect.hasField(jsonFile, "button_right"))
		{
			this.button_right = jsonFile.button_right;
		}
		if (Reflect.hasField(jsonFile, "button_left"))
		{
			this.button_left = jsonFile.button_left;
		}
	}
}
