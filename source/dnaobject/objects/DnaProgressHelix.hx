package dnaobject.objects;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.StateMachineComponent;
import dnaobject.components.UserButtonComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import dnaobject.objects.corsi_task_states.CorsiAnswerState;
import dnaobject.objects.corsi_task_states.CorsiFeedbackStateContinue;
import dnaobject.objects.corsi_task_states.CorsiInitialState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import haxe.Json;
import locale.LocaleManager;
import openfl.display.Sprite;

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class DnaProgressHelix implements DnaObject extends DnaObjectBase
{
	public final path_node = "assets/images/progress_helix/progress_helix_endpoint.png";
	public final path_helix = "assets/images/progress_helix/progress_helix.png";
	public final path_end = "assets/images/progress_helix/progress_helix_end.png";

	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("DnaProgressHelix");
		this.setOrigin(0, 0);
	}

	override public function onHaveParent() {}

	override public function onReady()
	{
		super.onReady();

		createHelix();
		createLabels();
		showActiveUntil(this.active_node_index);
	}

	public function showActiveUntil(index:Int, inactive_color:FlxColor = 0xff444444, active_color:FlxColor = 0xffffffff)
	{
		if (index >= node_sprs.length)
		{
			return;
		}

		// set all inactive
		for (node in this.node_sprs)
		{
			node.color = inactive_color;
		}
		for (helix in this.helix_sprs)
		{
			helix.color = inactive_color;
		}

		for (label in this.nodes_text_obj)
		{
			label.color = inactive_color;
		}
		end_right_spr.color = inactive_color;

		// set active where appropriate.
		end_left_spr.color = active_color;

		var idx = 0;
		while (idx <= index)
		{
			node_sprs[idx].color = active_color;
			if (idx < helix_sprs.length && idx > 0)
			{
				helix_sprs[idx - 1].color = active_color;
			}
			idx += 1;
		}

		var flashing_sprs = new Array<FlxSprite>();

		// flashing_sprs.push(node_sprs[idx - 1]);
		// last one active if needed.
		if (idx == node_sprs.length)
		{
			// end_right_spr.color = active_color;
			flashing_sprs.push(end_right_spr);
		}
		else
		{
			flashing_sprs.push(helix_sprs[idx - 1]);
		}

		var activate_helix:FlxSprite;
		var activate_node:FlxSprite;
		activate_node = node_sprs[idx - 1];
		if (idx > 1)
		{
			activate_helix = helix_sprs[idx - 2];
		}
		else
		{
			activate_helix = end_left_spr;
		}
		// make text and left helix and node go into active mode.
		var activate_dur:Float = 2.0;
		FlxTween.color(nodes_text_obj[idx - 1], activate_dur, inactive_color, active_color, {type: FlxTweenType.ONESHOT, ease: FlxEase.cubeInOut});
		// if possible fade the old text from active to inactive
		if (idx > 1)
		{
			FlxTween.color(nodes_text_obj[idx - 2], activate_dur, active_color, inactive_color, {type: FlxTweenType.ONESHOT, ease: FlxEase.cubeInOut});
		}

		FlxTween.color(activate_helix, activate_dur, inactive_color, active_color, {type: FlxTweenType.ONESHOT, ease: FlxEase.cubeInOut});
		FlxTween.color(activate_node, activate_dur, inactive_color, active_color, {
			type: FlxTweenType.ONESHOT,
			ease: FlxEase.cubeInOut,
			onComplete: function(tween:FlxTween)
			{
				var flash_dur:Float = 1;

				for (flash in flashing_sprs)
				{
					FlxTween.color(flash, flash_dur, inactive_color, active_color, {type: FlxTweenType.PINGPONG, ease: FlxEase.linear});
				}
			}
		});
	}

	public function createLabels()
	{
		var size:Int = Std.int((32 / DnaConstants.DEFAULT_SCREEN_SIZE.y) * FlxG.height);
		// we need to get the real text to display..
		for (text in nodes)
		{
			var real_text = LocaleManager.getInstance().getString(text);
			this.nodes_text.push(real_text);
			this.nodes_text_obj.push(new FlxText(0, 0, 0, real_text, size));
		}
		var side = -1;
		for (node_idx in 0...this.node_sprs.length)
		{
			var node = this.node_sprs[node_idx];
			var label = nodes_text_obj[node_idx];
			label.setPosition(node.getMidpoint().x - (label.width / 2), node.getMidpoint().y + (side * (height / 2)));
			side *= -1;
		}
		for (label in this.nodes_text_obj)
		{
			addChild(label);
		}
	}

	public function createHelix()
	{
		this.setOrigin(0, 0);
		// create all the sprites
		this.end_left_spr = new FlxSprite(0, 0, path_end);
		this.end_right_spr = new FlxSprite(0, 0, path_end);

		for (index in 0...nodes.length)
		{
			this.node_sprs.push(new FlxSprite(0, 0, path_node));
			if (index != nodes.length - 1)
			{
				// we want the helix to look like this:
				// end node helix node end
				// so we have to skip the last helix here.
				this.helix_sprs.push(new FlxSprite(0, 0, path_helix));
			}
		}

		// we will create a kind of raster to arrange the dna helix.
		// the helix uses 2 fields, the endpoints 1
		var rasterDim = new FlxPoint(0, 0);
		rasterDim.x = width / nodes.length;
		// we use half of the height for text.
		rasterDim.y = height / 2;
		// we do not want to stretch our images so we have to get the correct width per raster here.
		end_left_spr.setGraphicSize(Std.int(rasterDim.x));
		end_left_spr.updateHitbox();
		// now we check if we exceed our raster height
		if (end_left_spr.height > rasterDim.y)
		{
			end_left_spr.setGraphicSize(0, Std.int(rasterDim.y));
			end_left_spr.updateHitbox();
		}
		rasterDim.x = end_left_spr.width;
		rasterDim.y = end_left_spr.height;

		// now that we have the correct rasterdim we need to calculate our rasterpositions (left top)
		// helix*2+ 2 times endpoint
		var inner_width = (this.helix_sprs.length * 2 + 2) * rasterDim.x;
		var raster_left_top = new FlxPoint(this.getOrigin().x + ((width - inner_width) / 2), this.midpoint.y - (rasterDim.y / 2));

		// arrange the sprites on the raster.
		end_left_spr.setPosition(raster_left_top.x, raster_left_top.y);
		var raster_index = 1;
		for (node_idx in 0...node_sprs.length)
		{
			var node = node_sprs[node_idx];
			node.setGraphicSize(0, Std.int(rasterDim.y));
			node.updateHitbox();
			node.setPosition(raster_left_top.x + ((raster_index * rasterDim.x) - (node.width / 2)), raster_left_top.y);
			if (node_idx < helix_sprs.length)
			{
				var helix = helix_sprs[node_idx];

				helix.setGraphicSize(Std.int(rasterDim.x) * 2);
				helix.updateHitbox();
				helix.setPosition(raster_left_top.x + (raster_index * rasterDim.x), raster_left_top.y);
				raster_index += 2;
			}
		}

		end_right_spr.setGraphicSize(Std.int(rasterDim.x), Std.int(rasterDim.y));
		end_right_spr.updateHitbox();
		end_right_spr.setPosition(raster_left_top.x + (raster_index * rasterDim.x), raster_left_top.y);
		end_right_spr.flipX = true;
		end_right_spr.flipY = true;

		this.addChild(end_left_spr);
		this.addChild(end_right_spr);
		for (sprite in helix_sprs)
		{
			this.addChild(sprite);
		}
		for (sprite in node_sprs)
		{
			this.addChild(sprite);
		}
	}

	public var width(default, set):Float;

	public function set_width(value:Float):Float
	{
		width = value * FlxG.width;
		return width;
	}

	public var height(default, set):Float;

	public function set_height(value:Float):Float
	{
		height = value * FlxG.height;
		return height;
	}

	public var midpoint(get, never):FlxPoint;

	public function get_midpoint():FlxPoint
	{
		var pt = new FlxPoint();
		pt.x = this.getOrigin().x + (width / 2);
		pt.y = this.getOrigin().y + (height / 2);
		return pt;
	}

	public var nodes:Array<String>;

	private var nodes_text:Array<String> = new Array<String>();
	private var nodes_text_obj:Array<FlxText> = new Array<FlxText>();

	private var end_left_spr:FlxSprite;
	private var end_right_spr:FlxSprite;
	private var node_sprs:Array<FlxSprite> = new Array<FlxSprite>();
	private var helix_sprs:Array<FlxSprite> = new Array<FlxSprite>();

	public var active_node_index:Int = 0;

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "nodes"))
		{
			this.nodes = cast jsonFile.nodes;
		}
		if (Reflect.hasField(jsonFile, "active_node_index"))
		{
			this.active_node_index = cast jsonFile.active_node_index;
		}
		if (Reflect.hasField(jsonFile, "width"))
		{
			this.width = cast jsonFile.width;
		}

		if (Reflect.hasField(jsonFile, "height"))
		{
			this.height = cast jsonFile.height;
		}
	}
}
