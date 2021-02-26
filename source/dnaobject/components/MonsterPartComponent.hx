package dnaobject.components;

import Assertion.assert;
import dnaobject.DnaComponent;
import dnaobject.DnaComponentBase;
import dnaobject.components.ActionSetSliderPosComponent;
import dnaobject.interfaces.Slideable;
import dnaobject.objects.MonsterObject;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeDoubleCircle;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import openfl.utils.Assets;
import osspec.OsManager;

/**
 *  MonsterPartcomponent. this component will be used to set the body part of the monster.
* **/
class MonsterPartComponent implements DnaComponent extends DnaComponentBase
{
	private var assetMap:Map<String, String> = new Map<String, String>();

	/**
	 * the type of this bodypartComponent.
	 */
	public var part_type:String = "";

	/**
	 * ctor
	 */
	public function new()
	{
		super('MonsterPartComponent');
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		if (Reflect.hasField(jsonFile, "part_type"))
		{
			this.part_type = jsonFile.part_type;
		}
		if (Reflect.hasField(jsonFile, "assets"))
		{
			var assets:Array<Dynamic> = jsonFile.assets;

			for (asset in assets)
			{
				assetMap.set(asset.name, asset.path);
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
		this.m_parent_obj = parent;

		if (this.getParent() == null)
		{
			return;
		}
		var par:MonsterObject = cast this.getParent();
		for (name => path in this.assetMap)
		{
			par.setAsset(name, Assets.getBitmapData(path));
		}
	}
}
