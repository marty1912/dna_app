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

class Zone
{
	public var sprite:FlxSprite = new FlxSprite();
	public var color:FlxColor = FlxColor.WHITE; // FlxColor.fromString('0xffffff');
	public var position:Float = 0;
	public var width:Float = 6;
	public var heigth:Float;
	public var label:FlxText = new FlxText();
	public var alpha:Float = 0.5;
	public var alpha_min:Float = 0.2;
	public var alpha_max:Float = 0.4;

	public function new(position:Float, width:Float, height:Float = 10, color:String = '0x00ff00', alpha:Float = 0.5)
	{
		this.position = position;
		this.alpha = alpha;
		this.color = FlxColor.fromString(color);
		this.heigth = height;
		this.width = width;

		updateGraphic();

		// label.text = Std.string(position);
		// label.size = 32;
	}

	public function updateGraphic()
	{
		sprite.makeGraphic(Std.int(width), Std.int(heigth), color);
		sprite.alpha = alpha;
	}

	public function setWidth(value:Float)
	{
		this.width = value;
		updateGraphic();
	}

	/**
	 * this is a helper function to setup the tick in a correct way on the axis.
	 * @param x
	 * @param y
	 */
	public function setPosition(x:Float, y:Float)
	{
		this.sprite.setPosition(x - width / 2, y - heigth / 2);
		// this.label.setPosition(x - (this.label.width / 2), y - (heigth + (label.size / 2)));
	}
}

/**
 *  NumlineZonecomponent. this component will be used to add ticks to
 * for example a numberline slideable.
* **/
class NumlineZoneComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * in here we will store all of our ticks.
	 */
	private var zone:Zone;

	private var tol:Float;

	private var blinking:Bool = true;

	private var blink_freq:Float = 2;

	/**
	 * ctor
	 */
	public function new()
	{
		super('NumlineZoneComponent');
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		return;

		super.destroy();
		FlxDestroyUtil.destroy(zone.sprite);
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "tol"))
		{
			this.tol = jsonFile.tol;
			this.zone = new Zone(1, 1);
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
			this.getParent().removeChild(zone.sprite);
		}
		this.m_parent_obj = parent;
		// parent must implement slideable interface
		var slide = cast(this.m_parent_obj, Slideable);
		if (this.getParent() == null)
		{
			return;
		}

		this.getParent().addChild(zone.sprite);
	}

	/**
	 * sets up the position of all the ticks on the numline.
	 */
	public function setupPos()
	{
		// trace("setup pos, tol", tol);
		var parent:Slideable = cast(this.getParent());
		var target_num:Float = parent.getNumTarget();
		var max_deviation:Float = (parent.getNumMax() - parent.getNumZero()) * tol;
		var deviation_pix:Float = parent.getPosFromValue(target_num + max_deviation).x - parent.getPosFromValue(target_num).x;
		var pos = parent.getPosFromValue(parent.getNumTarget());
		zone.setWidth(deviation_pix * 2);
		zone.updateGraphic();
		zone.setPosition(pos.x, pos.y);
		// trace("pos:", pos);

		pos.put();
	}

	public var first:Bool = true;

	private var total_time:Float = 0;

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
		total_time += elapsed;
		// blinking zone:
		var alpha_range = this.zone.alpha_max - this.zone.alpha_min;
		this.zone.sprite.alpha = (alpha_range * Math.abs(Math.cos(total_time * blink_freq))) + this.zone.alpha_min;
	}
}
