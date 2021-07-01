package dnaobject.objects;

import flash.geom.Matrix;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShape;
import flixel.addons.display.shapes.FlxShapeSquareDonut;
import flixel.addons.display.shapes.FlxShapeType;
import flixel.math.FlxPoint;
import flixel.system.debug.Window;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil.LineStyle;
import flixel.util.FlxSpriteUtil;

/**
 * a rounded rect shape
 */
class RoundedRectShape extends FlxShape
{
	public var radius(default, set):Float;

	inline function set_radius(r:Float):Float
	{
		radius = r;
		shapeDirty = true;
		return radius;
	}

	public function new(X:Float, Y:Float, Width:Float, Heigth:Float, Radius:Float, LineStyle_:LineStyle, FillColor:FlxColor)
	{
		super(X, Y, 0, 0, LineStyle_, FillColor, Width, Heigth);
		radius = Radius;
		shape_id = FlxShapeType.SQUARE_DONUT;
	}

	/**
	 * drawSpecificShape
	 * @param matrix 
	 */
	override public function drawSpecificShape(?matrix:Matrix):Void
	{
		FlxSpriteUtil.drawRect(this, 0, radius, width, height - (2 * radius), fillColor, lineStyle, {matrix: matrix});
		FlxSpriteUtil.drawRect(this, radius, 0, width - (2 * radius), height, fillColor, lineStyle, {matrix: matrix});
		FlxSpriteUtil.drawCircle(this, width - radius, height - radius, radius, fillColor, lineStyle, {matrix: matrix});
		FlxSpriteUtil.drawCircle(this, radius, radius, radius, fillColor, lineStyle, {matrix: matrix});
		FlxSpriteUtil.drawCircle(this, radius, height - radius, radius, fillColor, lineStyle, {matrix: matrix});
		FlxSpriteUtil.drawCircle(this, width - radius, radius, radius, fillColor, lineStyle, {matrix: matrix});
	}
}

/**
 * class RoundedRectangleObject -
 *
 */
class RoundedRectangleObject implements DnaObject extends DnaObjectBase
{
	private var width:Float = 0;
	private var height:Float = 0;
	var shape:RoundedRectShape;
	private var radius:Float = 0;
	private var color:String = "0xFFFF00";

	/**
	 * ctor.
	 */
	public function new()
	{
		super("RoundedRectangleObject");
		shape = new RoundedRectShape(0, 0, FlxG.width, FlxG.height, 10, {thickness: 0, color: FlxColor.TRANSPARENT}, FlxColor.WHITE);
		this.addChild(shape);
	}

	private var m_scale_from_screen_width:Bool = false;
	private var m_scale_from_screen_height:Bool = false;

	public function setupShape()
	{
		this.removeChild(shape);
		shape = new RoundedRectShape(0, 0, this.width, this.height, this.radius, {thickness: 0, color: FlxColor.TRANSPARENT}, FlxColor.WHITE);
		// shape = new RoundedRectShape(0, 0, this.width, this.height, this.radius, {thickness: 0, color: FlxColor.TRANSPARENT}, FlxColor.fromString("0xFF00FFFF"));
		shape.shapeDirty = true;
		this.addChild(shape);
	}

	/**
	 * in the fromFile function we simply read the asset path from the file.
	 *
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "scale_from_screen_width"))
		{
			this.m_scale_from_screen_width = jsonFile.scale_from_screen_width;
		}
		if (Reflect.hasField(jsonFile, "width"))
		{
			if (m_scale_from_screen_width)
			{
				this.width = FlxG.width * jsonFile.width;
			}
			else
			{
				this.width = jsonFile.width;
			}
			this.shape.width = this.width;
		}
		if (Reflect.hasField(jsonFile, "scale_from_screen_height"))
		{
			this.m_scale_from_screen_height = jsonFile.scale_from_screen_height;
		}
		if (Reflect.hasField(jsonFile, "height"))
		{
			if (m_scale_from_screen_height)
			{
				this.height = FlxG.height * jsonFile.height;
			}
			else
			{
				this.height = jsonFile.height;
			}
			this.shape.height = this.height;
		}
		if (Reflect.hasField(jsonFile, "radius"))
		{
			this.shape.radius = jsonFile.radius;
		}

		if (Reflect.hasField(jsonFile, "color"))
		{
			this.color = jsonFile.color;
			this.shape.fillColor = FlxColor.fromString(this.color);
		}

		super.fromFile(jsonFile);
	}
}
