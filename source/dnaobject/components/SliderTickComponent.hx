package dnaobject.components;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.components.ActionSetSliderPosComponent;
import dnaobject.interfaces.Slideable;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeDoubleCircle;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import osspec.OsManager;

class Tick
{
	public var sprite:FlxSprite = new FlxSprite();
	public var color:FlxColor = FlxColor.WHITE; // FlxColor.fromString('0xffffff');
	public var position:Float = 0;
	public var width:Float = 6;
	public var heigth:Float = 64;
	public var label:FlxText = new FlxText();

	public function new(position:Float, color:String = '0xffffff', alpha:Float)
	{
		this.position = position;
		sprite.makeGraphic(Std.int(width), Std.int(heigth), FlxColor.fromString(color));
		sprite.alpha = alpha;
		label.text = Std.string(position);
		label.size = 32;
	}

	/**
	 * this is a helper function to setup the tick in a correct way on the axis.
	 * @param x
	 * @param y
	 */
	public function setPosition(x:Float, y:Float)
	{
		this.sprite.setPosition(x - width / 2, y - heigth / 2);
		this.label.setPosition(x - (this.label.width / 2), y - (heigth + (label.size / 2)));
	}
}

/**
 *  SliderTickcomponent. this component will be used to add ticks to
 * for example a numberline slideable.
* **/
class SliderTickComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * in here we will store all of our ticks.
	 */
	private var ticks:Array<Tick> = new Array<Tick>();

	/**
	 * ctor
	 */
	public function new()
	{
		super('SliderTickComponent');
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
		for (tick in this.ticks)
		{
			FlxDestroyUtil.destroy(tick.sprite);
		}

		while (ticks.length > 0)
		{
			ticks.pop();
		}
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "ticks"))
		{
			var ticks:Array<Dynamic> = jsonFile.ticks;

			for (t in ticks)
			{
				this.ticks.push(new Tick(t.position, t.color, t.alpha));
			}
		}
	}

	/**
	 * setParent - we override the setParent function so we can cast and make sure that the
	 * parent implements slideable.
	 * @param parent
	 */
	override public function setParent(parent:DnaObject)
	{
		if (this.getParent() != null)
		{
			for (tick in this.ticks)
			{
				this.getParent().removeChild(tick.sprite);
				this.getParent().removeChild(tick.label);
			}
		}
		this.m_parent_obj = parent;
		// parent must implement slideable interface
		var slide = cast(this.m_parent_obj, Slideable);
		if (this.getParent() == null)
		{
			return;
		}
		for (tick in this.ticks)
		{
			this.getParent().addChild(tick.sprite);
			this.getParent().addChild(tick.label);
		}
	}

	/**
	 * sets up the position of all the ticks on the numline.
	 */
	public function setupPos()
	{
		var parent:Slideable = cast(this.getParent());
		for (tick in this.ticks)
		{
			var pos = parent.getPosFromValue(tick.position);
			tick.setPosition(pos.x, pos.y);
			pos.put();
		}
	}

	public var first:Bool = true;

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		if (first)
		{
			first = false;
			setupPos();
		}
	}
}
