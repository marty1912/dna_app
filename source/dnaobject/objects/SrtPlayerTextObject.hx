package dnaobject.objects;

import constants.DnaConstants;
import dnadata.DnaDataManager;
import dnaobject.interfaces.ITextBox;
import flixel.FlxG;
import flixel.text.FlxText;
import haxe.Json;
import locale.LocaleManager;

class SrtEntry
{
	public var text:String;
	public var t_start:Float;
	public var t_end:Float;
	public var started:Bool = false;
	public var done:Bool = false;

	public function new(t_start:Float, t_end:Float, text:String)
	{
		this.t_start = t_start;
		this.t_end = t_end;
		this.text = text;
	}
}

/**
 * class SrtPlayerTextObject -
 * this class will be used to show text to the user that runs from left to right
 * TODO: fix this class or something. apparently we cannot create a new Textbox at runtime (only in the create function??)
 *
 */
class SrtPlayerTextObject implements DnaObject implements ITextBox extends DnaObjectBase
{
	public static final CODE_NEXT_TRIAL_DESC = "NEXT_TRIAL_DESC";

	public var text_box:FlxText;
	public var autostart:Bool = false;
	public var srt_text:String;
	public var srt_list:Array<SrtEntry> = new Array<SrtEntry>();
	public var cur_time:Float = 0;
	public var running:Bool = false;
	public var text_width:Float = 0.5;
	public var fontsize:Int = 10;

	public var append_before:String = "";
	public var append_after:String = "";

	/**
	 * returns the name of the event that is fired when the whole text has been displayed.
	 * @return String
	 */
	public function getEventFinName():String
	{
		return this.obj_type + "_" + this.obj_name + "_" + this.id + "_done";
	}

	public function reset():Void
	{
		this.running = false;
		this.cur_time = 0;
		this.parseText(this.text_from_file);
	}

	/**
	 * start() - starts displaying the text.
	 */
	public function start():Void
	{
		// trace("started.");
		this.running = true;
	}

	/**
	 * ctor.
	 */
	public function new()
	{
		super("SrtPlayerTextObject");
		text_box = new FlxText();
		this.addChild(text_box);
	}

	/**
	 * in here we will parse our str file.
	 * @param str_key
	 */
	public function parseText(str_key:String)
	{
		while (this.srt_list.length > 0)
		{
			this.srt_list.pop();
		}
		srt_text = LocaleManager.getInstance().getString(str_key);

		var srt_json:Array<Dynamic>;
		try
		{
			srt_json = Json.parse(srt_text);
		}
		catch (e)
		{
			srt_json = [
				{
					t_start: 0,
					t_end: 100,
					text: srt_text
				}
			];
		}
		for (entry in srt_json)
		{
			this.srt_list.push(new SrtEntry(entry.t_start, entry.t_end, append_before + entry.text + append_after));
		}
	}

	/**
	 * sets the text of this textbox
	 * @param value 
	 * @param use_literal_text 
	 */
	public function setText(value:String, ?use_literal_text:Bool = false)
	{
		this.parseText(value);
		this.text_from_file = value;
	}

	public function getText():String
		throw "NOT IMPLEMENTED!";

	/**
	 * setter for text
	 * @param value
	 */
	public function showText(value:String)
	{
		this.setOrigin(0, 0);

		this.text_box.text = value;

		text_box.autoSize = false;
		text_box.fieldWidth = text_width;

		text_box.size = fontsize;
		text_box.alpha = 1;
		text_box.wordWrap = true;
		text_box.alignment = FlxTextAlign.LEFT;
		if (text_box.textField.numLines <= 1)
		{
			text_box.alignment = FlxTextAlign.CENTER;
		}

		this.removeChild(text_box);
		this.addChild(text_box);
	}

	/**
	 * hides the text
	 */
	public function hideText()
	{
		text_box.alpha = 0;
	}

	/**
	 * onTextBoxDone - called whenever the textbox is finished.
	 * in here we check if we still have more text to display on other srt entries.
	 * if not we broadcast the finished event.
	 */
	private function onTextBoxDone()
	{
		var all_done:Bool = true;
		for (entry in srt_list)
		{
			if (!entry.started)
			{
				all_done = false;
				break;
			}
		}

		if (all_done)
		{
			this.getParent().eventManager.broadcastEvent(this.getEventFinName());
			this.running = false;
			this.reset();
		}
	}

	public var text_from_file:String;

	/**
	 * in the fromFile function we simply read the asset path from the file.
	 *
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic):Void
	{
		if (Reflect.hasField(jsonFile, "autostart"))
		{
			this.autostart = jsonFile.autostart;
			this.running = jsonFile.autostart;
		}
		if (Reflect.hasField(jsonFile, "settings"))
		{
			append_before = Reflect.hasField(jsonFile.settings, "append_before") ? jsonFile.settings.append_before : append_before;
			append_after = Reflect.hasField(jsonFile.settings, "append_after") ? jsonFile.settings.append_after : append_after;
			fontsize = jsonFile.settings.fontsize;
			fontsize = cast Math.floor(fontsize * (FlxG.height / DnaConstants.DEFAULT_SCREEN_SIZE.y));
			text_width = jsonFile.settings.width;
			if (text_width > 1)
			{
				text_width = 0.5;
			}
			text_width = cast Math.floor(text_width * (FlxG.width));
		}
		if (Reflect.hasField(jsonFile, "text"))
		{
			if (jsonFile.text == CODE_NEXT_TRIAL_DESC)
			{
				jsonFile.text = DnaDataManager.instance.getNextTrials().desc_head;
			}
			this.parseText(jsonFile.text);
			this.text_from_file = jsonFile.text;
		}

		super.fromFile(jsonFile);
	}

	/**
	 * in here we will update the text and show the next entry if necessary.
	 * @param time
	 */
	private function updateText(time:Float)
	{
		for (entry in srt_list)
		{
			if ((entry.started == false) && time > entry.t_start)
			{
				showText(entry.text);
				entry.started = true;
			}
			else if ((entry.done == false) && (entry.started == true) && time > entry.t_end)
			{
				hideText();
				onTextBoxDone();
				entry.done = true;
			}
		}
	}

	/**
	 * in here we will check the time..
	 * @param elapsed
	 */
	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.running)
		{
			cur_time += elapsed;
			updateText(cur_time);
		}
	}
}
