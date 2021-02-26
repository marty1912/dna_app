package dnaobject.components;

import constants.DnaConstants;
import dnaEvent.DnaEventManager;
import dnaEvent.DnaEventSubscriber;
import dnaobject.interfaces.ITextBox;

/**
 * class ArithmeticTaskHandlerObject
 * this class represents our ArithmeticTaskHandler.
 * it is used to set and get parameters of the objects used in the arithmetic task
 *
 */
class TextBoxInputComponent implements DnaComponent implements DnaEventSubscriber extends DnaComponentBase
{
	public var max_input_len:Int = 6;

	/**
	 * getNotified() - we will subscribe to all the key events (0-9) and the delete events (backspace and delete)
	 * with that we will write to the answer textbox.
	 * @param event_name
	 */
	public function getNotified(event_name:String)
	{
		if (event_name.indexOf(DnaEventManager.KEY_EVENT_PREFIX) == -1)
		{
			// not a KEY event.
			return;
		}
		var key:String = event_name.substr(DnaEventManager.KEY_EVENT_PREFIX.length);

		if (key == DnaConstants.KEY_BACKSPACE)
		{
			backspaceOnAnswerText();
		}
		else
		{
			addToAnswerText(Std.string(key));
		}
	}

	/**
	 * adds the char given as param to the answer text. also checks for max len constraint.
	 * @param char
	 */
	public function backspaceOnAnswerText()
	{
		var textbox:ITextBox = cast this.getParent();
		var current_text:String = textbox.getText();

		if (current_text.length == 0)
		{
			return;
		}
		var new_text:String = current_text.substr(0, current_text.length - 1);
		textbox.setText(new_text, true);
		if (new_text.length == 0)
		{
			DnaEventManager.instance.broadcastEvent("TEXTINPUT_EMPTY");
		}
	}

	/**
	 * adds the char given as param to the answer text. also checks for max len constraint.
	 * @param char
	 */
	public function addToAnswerText(char:String)
	{
		var textbox:ITextBox = cast this.getParent();
		var current_text:String = textbox.getText();
		if (current_text.length >= this.max_input_len)
		{
			DnaEventManager.instance.broadcastEvent("TEXTINPUT_FULL");
			return;
		}
		var new_text:String = current_text + char;
		textbox.setText(new_text, true);
		DnaEventManager.instance.broadcastEvent("TEXTINPUT_READY");
	}

	/**
	 * ctor - in here we set the members like our type, position etc.
	 */
	public function new()
	{
		super('TextBoxInputComponent');
		for (num in 0...10)
		{
			DnaEventManager.instance.addSubscriberForEvent(this, DnaEventManager.KEY_EVENT_PREFIX + num);
		}
		DnaEventManager.instance.addSubscriberForEvent(this, DnaEventManager.KEY_EVENT_PREFIX + DnaConstants.KEY_BACKSPACE);
	}

	/**
	 * fromFile function. reads from Dynamic field.
	 * @param jsonFile
	 */
	override public function fromFile(jsonFile:Dynamic)
	{
		// assert(jsonFile.type == this.comp_type);

		if (Reflect.hasField(jsonFile, "max_input_len"))
		{
			this.max_input_len = jsonFile.max_input_len;
		}
	}
}
