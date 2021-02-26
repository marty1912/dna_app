package dnaobject.components;

import flixel.text.FlxText;

/**
 * class TextComponent.
 * this component is used to di
 */
class TextComponent implements DnaComponent extends DnaComponentBase
{
	/**
	 * ctor
	 */
	public function new()
	{
		super('TextComponent');
		this.text_obj = new FlxText();
	}

	/**
	 * dtor.
	 */
	override public function destroy()
	{
		super.destroy();
	}

	private var text_obj:FlxText;

	public function setText(value:String):Void
	{
		this.text_obj.text = value;
	}

	override public function setParent(parent:DnaObject)
	{
		super.setParent(parent);
		this.text_obj.x = this.getParent().getOrigin().x;
		this.text_obj.y = this.getParent().getOrigin().y;
		// kind of a hack. but we know that each parent will have at least one child..
		this.text_obj.width = this.getParent().getChildren()[0].width;
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		if (Reflect.hasField(jsonFile, "text"))
		{
			// this is the wrong way around i know. but it works like this..
			this.setText(jsonFile.text);
		}
	}

	/**
	 * update - in this function we will put the object back to the screencenter, respecting the childrens offsets.
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		this.text_obj.update(elapsed);
	}
}
