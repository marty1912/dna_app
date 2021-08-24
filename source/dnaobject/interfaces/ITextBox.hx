package dnaobject.interfaces;

interface ITextBox
{
	/**
	 * returns the name of the event that is fired when the whole text has been displayed.
	 * @return String
	 */
	public function getEventFinName():String;

	public var onFinCallback:Void->Void;

	/**
	 * start() - starts displaying the text.
	 */
	public function start():Void;

	public function setText(value:String, ?use_literal_text:Bool = false):Void;
	public function getText():String;
}
