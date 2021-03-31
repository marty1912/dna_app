package dnaobject.objects;

import Assertion.assert;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnadata.TaskTrials;
import dnaobject.DnaObject;
import dnaobject.interfaces.Slideable;
import dnaobject.interfaces.TaskObject;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.DynamicAccess;

/**
 * class NumberlineObject
 * this class represents our Numberline. it is a Group of FlxBasic objects
 *
 */
class NumberlineObject implements DnaObject implements Slideable implements TaskObject extends DnaObjectBase
{
	// the horizontal line. (the actual numberline)
	// -------
	public var axis:FlxSprite;

	// the zero indicator line
	// |-----
	public var m_zero_line:FlxSprite;

	// the reference line
	// |--|-----
	public var m_ref_line:FlxSprite;

	// the target line. the line that appears after the user specified where she wants to place the target number
	// -------
	public var slider:FlxSprite;

	/**
	 * checks if the task was answered correctly
	 */
	public function isCorrect():String
		throw "not applicable for Numline!!";

	public function getSliderNum():Float
	{
		return (((slider.getPosition().x - axis.getPosition().x) / axis.width) * (getNumMax() - getNumZero()) + getNumZero());
	}

	/**
	 * this function returns the position for a given point on the numberline
	 * @param value - this is the value on the numberline. so it might for example be
	 *  that we want to know where the value of 1 is located on this numline..
	 * @return FlxPoint - the point in the middle of the axis and at the position of the value.
	 */
	public function getPosFromValue(value:Float):FlxPoint
	{
		// the origin of this thing is
		var rel_offset = value / this.m_num_max;

		var pos = FlxPoint.get(axis.x + (axis.width * rel_offset), axis.y + (axis.height / 2));

		return pos;
	}

	// this is the maximum represented number that we have on the numberline.
	// so the value on the way right of it.
	// |----|-----< max number
	private var m_num_max:Float;

	public function getNumMax():Float
	{
		return m_num_max;
	}

	// this is the number represented by the ref of the numberline.
	// so the value at the ref line.
	// |----|-----
	//     ref num
	private var m_num_ref:Float;

	public function getNumRef():Float
	{
		return m_num_ref;
	}

	// this is the number represented by the zero end of the numberline.
	// so the value at the zero line.
	// |----|-----
	// zero num
	private var m_num_zero:Float;

	public function getNumZero():Float
	{
		return m_num_zero;
	}

	// this is the number target for this numberline task.
	// |----|---t--
	private var m_num_target:Float;

	public function getNumTarget():Float
	{
		return m_num_target;
	}

	/**
	 * getData - this function collects the data we want to have from the numberline object.
	 * @return Dynamic - the
	 */
	public function getData():Dynamic
	{
		var selected:Null<Float> = null;
		if (this.slider.alpha != 0)
		{
			trace("slider alpha is not 0 but:", this.slider.alpha);
			selected = getSliderNum();
		}
		var current_trial:Dynamic = {
			zero: getNumZero(),
			ref: getNumRef(),
			max: getNumMax(),
			target: getNumTarget(),
			selected_num: selected
		};
		return current_trial;
	}

	/**
	 * setParams - this lets us set the parameters for the stimulus
	 * @param params - a dynamic object with fields: zero, ref, max and target
	 */
	public function setParams(params:Dynamic):Void
	{
		this.m_num_zero = params.zero;
		this.m_num_ref = params.ref;
		this.m_num_target = params.target;
		this.m_num_max = params.max;
		this.setupPositions();
		this.updateLabelTexts();
	}

	/**
	 * this function simply sets the zero ref and target text labels to the current values.
	 */
	public function updateLabelTexts():Void
	{
		m_label_zero.text = Std.string(m_num_zero);
		m_label_zero.color = label_zero_color;
		m_label_ref.text = Std.string(m_num_ref);
		m_label_ref.color = label_ref_color;
		m_label_target.text = Std.string(m_num_target);
		m_label_target.color = label_target_color;
	}

	/**
	 * text above the zero line
	 * 0
	 * |---|-----
	 */
	private var m_label_zero:FlxText;

	/**
	 * offset of zero label from line
	 */
	private var m_label_zero_off:FlxPoint = FlxPoint.get();

	/**
	 * text above the ref line
	 *     3
	 * |---|------
	 */
	private var m_label_ref:FlxText;

	/**
	 * offset of ref label from line
	 */
	private var m_label_ref_off:FlxPoint = FlxPoint.get();

	/**
	 * text with target number
	 * 			7?
	 *
	 * |----|-----------
	 *
	 */
	private var m_label_target:FlxText;

	/**
	 * offset of target label from line
	 */
	private var m_label_target_off:FlxPoint = FlxPoint.get();

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('NumberlineObject');
		axis = new FlxSprite();
		m_zero_line = new FlxSprite();
		m_ref_line = new FlxSprite();
		slider = new FlxSprite();
		m_label_ref = new FlxText();
		m_label_target = new FlxText();
		m_label_zero = new FlxText();
		addChild(axis);
		addChild(m_zero_line);
		addChild(m_ref_line);
		addChild(slider);
		addChild(m_label_ref);
		addChild(m_label_target);
		addChild(m_label_zero);
	}

	/**
	 * setup positions - here we set the general positions of our lines so that we get a nice Numberline.
	 * @param ref_offset_rel
	 */
	public function setupPositions()
	{
		// first we save current position so that we can get back to it later.
		var current_pos:FlxPoint = FlxPoint.get();
		current_pos.x = getOrigin().x;
		current_pos.y = getOrigin().y;

		// we start by setting the origin to 0
		setOrigin(0, 0);
		// place this thing in the middle. (so the center of the horizontal line is in the origin)
		axis.setPosition(-axis.width / 2, -axis.height / 2);
		// put this to the left end of the horizontal line.
		m_zero_line.setPosition(axis.x, -m_zero_line.height / 2);
		// this one is put at the ref_offset_rel
		// we calculate the relative position on the number line based on the max, ref and zero value of the numberline
		var ref_offset_rel:Float = (m_num_ref - m_num_zero) / (m_num_max - m_num_zero);
		// m_ref_line.setPosition(axis.x + (axis.width * ref_offset_rel) - (m_ref_line.width / 2), -(m_ref_line.height / 2));
		// we want to have the left side of the lines be the exact measures
		m_ref_line.setPosition(axis.x + (axis.width * ref_offset_rel), -(m_ref_line.height / 2));

		// setup label positions.
		m_label_zero.setPosition(m_zero_line.getPosition().x
			+ (m_zero_line.width / 2)
			- (m_label_zero.width / 2)
			+ m_label_zero_off.x,
			m_zero_line.getPosition().y
			+ m_label_zero_off.y);

		m_label_ref.setPosition(m_ref_line.getPosition().x
			+ (m_ref_line.width / 2)
			- (m_label_ref.width / 2)
			+ m_label_ref_off.x,
			m_ref_line.getPosition().y
			+ m_label_ref_off.y);
		m_label_target.setPosition(axis.getPosition().x
			+ (axis.width / 2)
			- (m_label_target.width / 2)
			+ m_label_target_off.x,
			axis.getPosition().y
			+ m_label_target_off.y);

		moveTo(current_pos.x, current_pos.y);
		current_pos.put();

		// because this causes problems with the position we only use it in the tutorial states for the finger
		if (this.origin_on_target == true)
		{
			setOriginToTarget();
		}
	}

	public var origin_on_target:Bool = false;

	/**
	 * this function is used only for tutorial purposes (so we can easily find the correct pos with our finger.)
	 */
	public function setOriginToTarget()
	{
		// we setup the origin to the target value so we can use it in our tutorial
		var pos_target = this.getPosFromValue(m_num_target);
		this.setOrigin(pos_target.x, pos_target.y);
	}

	/**
	 *  public function updateGraphics -
	 * 	in here we create our graphic elements (the lines)
	 */
	public function updateGraphics()
	{
		axis.makeGraphic(Math.floor(axis.width), Math.floor(axis.height), axis_color);
		m_zero_line.makeGraphic(Math.floor(m_zero_line.width), Math.floor(m_zero_line.height), zero_line_color);
		m_ref_line.makeGraphic(Math.floor(m_ref_line.width), Math.floor(m_ref_line.height), ref_line_color);
		slider.makeGraphic(Math.floor(slider.width), Math.floor(slider.height), slider_color);
		slider.alpha = 0;
	}

	/**
	 * colors for all our stuff.
	 */
	private var axis_color:FlxColor;

	private var zero_line_color:FlxColor;
	private var ref_line_color:FlxColor;
	private var slider_color:FlxColor;
	private var label_zero_color:FlxColor;
	private var label_ref_color:FlxColor;
	private var label_target_color:FlxColor;

	/**
	 * sets the slider num of this slider
	 * @param value
	 */
	public function setSliderNum(value:Float):Void
		throw "Not Implemented!!";

	/**
	 * fromFile()
	 *
	 * @param jsonFile - Dynamic Object with params. for Numberlineobject we have:
	 * horiz_line_w - the width (length) of the numberline
	 * horiz_line_h - the thickness of the numberline
	 * zero_w - the width (thickness) of the zero indicator line
	 * zero_h - the height (length) of the zero indicator line
	 *
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		// not used for now..
		// assert(jsonFile.type == obj_type);

		if (Reflect.hasField(jsonFile, "origin_on_target"))
		{
			origin_on_target = jsonFile.origin_on_target;
		}
		// first we get all the proportions for the numberline:
		if (Reflect.hasField(jsonFile, "horiz_line_w"))
		{
			axis.width = jsonFile.horiz_line_w;
		}
		if (Reflect.hasField(jsonFile, "horiz_line_h"))
		{
			axis.height = jsonFile.horiz_line_h;
		}
		if (Reflect.hasField(jsonFile, "horiz_line_color"))
		{
			axis_color = FlxColor.fromString(jsonFile.horiz_line_color);
		}

		// axis.makeGraphic(Math.floor(axis.width), Math.floor(axis.height));

		if (Reflect.hasField(jsonFile, "zero_line_w"))
		{
			m_zero_line.width = jsonFile.zero_line_w;
		}
		if (Reflect.hasField(jsonFile, "zero_line_h"))
		{
			m_zero_line.height = jsonFile.zero_line_h;
		}
		if (Reflect.hasField(jsonFile, "zero_line_color"))
		{
			zero_line_color = FlxColor.fromString(jsonFile.zero_line_color);
		}

		// m_zero_line.makeGraphic(Math.floor(m_zero_line.width), Math.floor(m_zero_line.height));

		if (Reflect.hasField(jsonFile, "ref_line_w"))
		{
			m_ref_line.width = jsonFile.ref_line_w;
		}
		if (Reflect.hasField(jsonFile, "ref_line_h"))
		{
			m_ref_line.height = jsonFile.ref_line_h;
		}
		if (Reflect.hasField(jsonFile, "ref_line_color"))
		{
			ref_line_color = FlxColor.fromString(jsonFile.ref_line_color);
		}

		// m_ref_line.makeGraphic(Math.floor(m_ref_line.width), Math.floor(m_ref_line.height));

		if (Reflect.hasField(jsonFile, "target_line_w"))
		{
			slider.width = jsonFile.target_line_w;
		}
		if (Reflect.hasField(jsonFile, "target_line_h"))
		{
			slider.height = jsonFile.target_line_h;
		}
		if (Reflect.hasField(jsonFile, "slider_color"))
		{
			slider_color = FlxColor.fromString(jsonFile.slider_color);
		}

		// slider.makeGraphic(Math.floor(slider.width), Math.floor(slider.height));
		// slider.alpha = 0;

		// now the reference values etc.
		if (Reflect.hasField(jsonFile, "num_max"))
		{
			m_num_max = jsonFile.num_max;
		}
		if (Reflect.hasField(jsonFile, "num_ref"))
		{
			m_num_ref = jsonFile.num_ref;
			// m_label_ref.text = Std.string(m_num_ref);
		}
		if (Reflect.hasField(jsonFile, "num_zero"))
		{
			m_num_zero = jsonFile.num_zero;
			// m_label_zero.text = Std.string(m_num_zero);
		}
		if (Reflect.hasField(jsonFile, "num_target"))
		{
			m_num_target = jsonFile.num_target;
			// m_label_target.text = Std.string(m_num_target);
		}

		if (Reflect.hasField(jsonFile, "label_zero_color"))
		{
			label_zero_color = FlxColor.fromString(jsonFile.label_zero_color);
		}
		if (Reflect.hasField(jsonFile, "label_ref_color"))
		{
			label_ref_color = FlxColor.fromString(jsonFile.label_ref_color);
		}
		if (Reflect.hasField(jsonFile, "label_target_color"))
		{
			label_target_color = FlxColor.fromString(jsonFile.label_target_color);
		}

		// sizes of our labels.
		if (Reflect.hasField(jsonFile, "label_size_ref"))
		{
			m_label_ref.setFormat(null, jsonFile.label_size_ref);
		}
		if (Reflect.hasField(jsonFile, "label_size_zero"))
		{
			m_label_zero.setFormat(null, jsonFile.label_size_zero);
		}
		if (Reflect.hasField(jsonFile, "label_size_target"))
		{
			m_label_target.setFormat(null, jsonFile.label_size_target);
		}

		if (Reflect.hasField(jsonFile, "label_zero_off_x"))
		{
			m_label_zero_off.x = jsonFile.label_zero_off_x;
		}
		if (Reflect.hasField(jsonFile, "label_zero_off_y"))
		{
			m_label_zero_off.y = jsonFile.label_zero_off_y;
		}

		if (Reflect.hasField(jsonFile, "label_ref_off_x"))
		{
			m_label_ref_off.x = jsonFile.label_ref_off_x;
		}
		if (Reflect.hasField(jsonFile, "label_ref_off_y"))
		{
			m_label_ref_off.y = jsonFile.label_ref_off_y;
		}

		if (Reflect.hasField(jsonFile, "label_target_off_x"))
		{
			m_label_target_off.x = jsonFile.label_target_off_x;
		}
		if (Reflect.hasField(jsonFile, "label_target_off_y"))
		{
			m_label_target_off.y = jsonFile.label_target_off_y;
		}

		updateLabelTexts();
		updateGraphics();
		setupPositions();
		super.fromFile(jsonFile);

		return;
	}
}
