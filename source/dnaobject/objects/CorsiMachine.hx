package dnaobject.objects;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.DnaDataManager;
import dnadata.TrialBlock;
import dnaobject.components.ActionStateSwitchComponent;
import dnaobject.components.TutorialFingerComponent;
import dnaobject.components.UserButtonComponent;
import dnaobject.interfaces.ILevelPreview;
import dnaobject.interfaces.IUnlockableItem;
import dnaobject.interfaces.TaskObject;
import flixel.FlxSprite;
import flixel.addons.plugin.taskManager.FlxTask;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;

class PressSequence
{
	public var sequence:Array<DnaButtonObject>;
	public var finger:TutorialFingerComponent;
	public var onDone:Void->Void;

	public function new(seq:Array<DnaButtonObject>, fing:TutorialFingerComponent, onDone:Void->Void)
	{
		this.sequence = seq.copy();
		this.finger = fing;
		this.onDone = onDone;
	}

	public function present()
	{
		if (sequence.length == 0)
		{
			onDone();
			return;
		}

		var next_btn = sequence[0];
		sequence.remove(next_btn);
		finger.moveToButtonAndPress(next_btn, this.present, 1);
	}
}

/**
 * this is the class that handles giving our trial parameters to the correct objects.
 */
class CorsiMachine implements DnaObject implements DnaEventSubscriber extends DnaObjectBase
{
	/**
	 * overwritten ctor.
	 */
	public function new()
	{
		super("CorsiMachine");
	}

	/**
	 * this is the function that gets called everytime an event we subscribed for is fired
	 * @param event_name
	 */
	public function getNotified(event_name:String, params:Any = null) {}

	override public function onHaveParent() {}

	override public function onReady()
	{
		super.onReady();
		dome_obj = cast this.getParent().getObjectByName(getNestedObjectName(dome));
		front_obj = cast this.getParent().getObjectByName(getNestedObjectName(front));
		finger_obj = cast this.getParent().getObjectByName(getNestedObjectName(finger));
		finger_obj.sprite.alpha = 0;
		front_obj.removeChild(front_obj.sprite);
		front_obj.addChild(front_obj.sprite);

		// very hacky but we need to have the area on the front so no buttons are placed outside the box..
		var buttons_pos_x:Float = front_obj.sprite.x + (front_obj.width * 0.05);
		var buttons_pos_y:Float = front_obj.sprite.y + (front_obj.height * 0.2);
		var button_area_width:Float = front_obj.width * 0.85;
		var button_area_height:Float = front_obj.height * 0.7;
		button_area = FlxRect.get(Std.int(buttons_pos_x), Std.int(buttons_pos_y), Std.int(button_area_width), Std.int(button_area_height));
		/*
				test = new FlxSprite(Std.int(button_area.x), Std.int(button_area.y));
				test.makeGraphic(Std.int(button_area.width), Std.int(button_area.height), FlxColor.WHITE);
				this.addChild(test);
			var test_btn:DnaButtonObject = cast DnaObjectFactory.create("DnaButtonObject");
			var user_btn:UserButtonComponent = cast DnaComponentFactory.create("UserButtonComponent");
			this.getParent().addObject(test_btn);
			test_btn.addComponent(user_btn);
			test_btn.moveTo(0, 0);
			test_btn.onPressCallback = this.createButtons.bind(9);
		 */

		createButtons();
	}

	public var test:FlxSprite;
	public var buttons:Array<DnaButtonObject> = new Array<DnaButtonObject>();

	public var dome:String;
	public var base:String;
	public var front:String;
	public var finger:String;
	public var back:String;

	public var dome_obj:CorsiMachineDome;
	public var front_obj:SpriteObject;
	public var finger_obj:SpriteObject;

	public var button_area:FlxRect;

	public function presentSequence(sequence:Array<DnaButtonObject>, onDoneCallback:Void->Void)
	{
		var tutFinger:TutorialFingerComponent = cast finger_obj.getComponentByType("TutorialFingerComponent");
		var seq = new PressSequence(sequence, tutFinger, onDoneCallback);
		seq.present();
	}

	/**
	 * randomly chooses a Sequence to be pressed.
	 */
	public function generateSequence(len:Int):Array<DnaButtonObject>
	{
		assert(this.buttons != null && this.buttons.length != 0);
		var sequence = buttons.copy();
		sequence = Random.shuffle(sequence);
		sequence = sequence.slice(0, len);
		return sequence;
	}

	/**
	 * rearranges the buttons using FlxTweens to make it look nice.
	 */
	public function rearrangeButtons(duration:Float = 1, doneCallback:Void->Void = null)
	{
		var buttonPoss = getRandomButtonPositions();
		for (i in 0...buttonPoss.length)
		{
			// only add the callback on the last tween.
			if (i == buttonPoss.length - 1)
			{
				FlxTween.tween(this.buttons[i], {pos_x: buttonPoss[i].x, pos_y: buttonPoss[i].y}, duration, {
					onComplete: function(tween:FlxTween)
					{
						if (doneCallback != null)
						{
							doneCallback();
						}
					}
				});
			}
			else
			{
				FlxTween.tween(this.buttons[i], {pos_x: buttonPoss[i].x, pos_y: buttonPoss[i].y}, duration);
			}
		}
	}

	/**
	 * returns non overlapping random button positions for our buttons list.
	 * @return Array<FlxRect>
	 */
	public function getRandomButtonPositions():Array<FlxRect>
	{
		var free_rects = new Array<FlxRect>();
		free_rects.push(this.button_area);
		var used_rects = new Array<FlxRect>();

		for (button in this.buttons)
		{
			var rand_rect = free_rects[Random.int(0, free_rects.length - 1)];
			var pos = getRandomPosOnRect(rand_rect, button.rect);
			// button.moveTo(pos.x, pos.y);
			var currRect = new FlxRect(pos.x, pos.y, button.button.width, button.button.height);
			used_rects.push(currRect);
			var check_for_overlap = free_rects.copy();
			for (rect in check_for_overlap)
			{
				free_rects.remove(rect);
				var split = getFreeRects(rect, currRect);
				free_rects = free_rects.concat(split);
			}
		}
		return used_rects;
	}

	/**
	 * randomly sets up buttons on the box.
	 * @param n_buttons 
	 */
	public function createButtons(n_buttons:Int = 9)
	{
		while (this.buttons.length < n_buttons)
		{
			var button:DnaButtonObject = cast DnaObjectFactory.create("EmptyButtonObject");
			this.getParent().addObject(button);
			button.button.setGraphicSize(Math.floor(button_area.width * 0.1));
			button.button.updateHitbox();
			this.buttons.push(button);
		}
		for (button in this.buttons)
		{
			button.removeChild(button.button);
			button.addChild(button.button);
		}

		var buttonPoss = getRandomButtonPositions();
		for (i in 0...buttonPoss.length)
		{
			this.buttons[i].moveTo(buttonPoss[i].x, buttonPoss[i].y);
		}

		// visualizeRects(free_rects);
	}

	public var visual_list:Array<FlxSprite> = new Array<FlxSprite>();

	public function visualizeRects(rect_list:Array<FlxRect>)
	{
		while (visual_list.length != 0)
		{
			var vis = visual_list.pop();
			this.removeChild(vis);
			vis.destroy();
		}

		var rand = new FlxRandom();

		for (rect in rect_list)
		{
			var test = new FlxSprite(rect.x, rect.y);
			test.makeGraphic(Std.int(rect.width), Std.int(rect.height), rand.color(FlxColor.BLUE, FlxColor.YELLOW, 100));
			this.addChild(test);
			this.visual_list.push(test);
		}
	}

	/**
	 * gets a random position on a given rectangle for a given rectangle.
	 * @param base_area 
	 * @param place_me 
	 * @return FlxPoint
	 */
	public function getRandomPosOnRect(base_area:FlxRect, place_me:FlxRect):FlxPoint
	{
		var pos_x = Random.float(base_area.x, base_area.width + base_area.x - place_me.width);
		var pos_y = Random.float(base_area.y, base_area.height + base_area.y - place_me.height);
		return new FlxPoint(pos_x, pos_y);
	}

	/**
	 * we will  implement the algorithm described in the following stackoverflow post:
	 * https://stackoverflow.com/questions/716558/place-random-non-overlapping-rectangles-on-a-panel
	 * @return /**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	public function getFreeRects(base_rect:FlxRect, placed_rect:FlxRect):Array<FlxRect>
	{
		var free_rects = new Array<FlxRect>();
		if (!base_rect.overlaps(placed_rect))
		{
			free_rects.push(base_rect);
			return free_rects;
		}
		// we will start from the left and then go clockwise to top, right and bottom.
		// left:
		if (base_rect.x < placed_rect.x)
		{
			// we have space to the left
			free_rects.push(new FlxRect(base_rect.x, base_rect.y, placed_rect.x - base_rect.x, base_rect.height));
		}
		// top:
		if (base_rect.y < placed_rect.y)
		{
			// we have space at the top
			free_rects.push(new FlxRect(base_rect.x, base_rect.y, base_rect.width, placed_rect.y - base_rect.y));
		}
		// right:
		if (placed_rect.x + placed_rect.width < base_rect.x + base_rect.width)
		{
			// we have space at the top
			free_rects.push(new FlxRect(placed_rect.x + placed_rect.width, base_rect.y, (base_rect.x + base_rect.width) - (placed_rect.x + placed_rect.width),
				base_rect.height));
		}
		// bottom:
		if (placed_rect.y + placed_rect.height < base_rect.y + base_rect.height)
		{
			// we have space at the top
			free_rects.push(new FlxRect(base_rect.x, placed_rect.y + placed_rect.height, base_rect.width,
				(base_rect.y + base_rect.height) - (placed_rect.y + placed_rect.height)));
		}

		var rand = new FlxRandom();
		var copy_free = free_rects.copy();
		for (rect in copy_free)
		{
			// we remove spaces that are too small for another button
			if (rect.width < placed_rect.width || rect.height < placed_rect.height)
			{
				free_rects.remove(rect);
			}
		}

		return free_rects;
	}

	/**
	 * override so we can have parameters like random order and stuff.
	 * @param jsonFile 
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		super.fromFile(jsonFile);

		if (Reflect.hasField(jsonFile, "dome"))
		{
			this.dome = cast jsonFile.dome;
		}
		if (Reflect.hasField(jsonFile, "back"))
		{
			this.back = cast jsonFile.back;
		}

		if (Reflect.hasField(jsonFile, "base"))
		{
			this.base = cast jsonFile.base;
		}
		if (Reflect.hasField(jsonFile, "front"))
		{
			this.front = cast jsonFile.front;
		}
		if (Reflect.hasField(jsonFile, "finger"))
		{
			this.finger = cast jsonFile.finger;
		}
	}

	var total_time:Float = 0;
	var first = true;

	public override function update(elapsed:Float) {}
}
