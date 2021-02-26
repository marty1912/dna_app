package textparsemacro;

/**
 * copied from this very nice guy on stackoverflow:
 * https://stackoverflow.com/questions/30036069/load-a-json-object-from-a-file
 */
class ConfigFile
{
	// this macro is executed on compile time. so it enables us
	// to include json source files in seperate files and load them
	// also on web targets.
	// path is relative to where haxe is executed
	macro public static function text(path:String)
	{
		var value = sys.io.File.getContent(path);
		return macro $v{value};
	}

	macro public static function json(path:String)
	{
		var value = sys.io.File.getContent(path),
			json = haxe.Json.parse(value);
		return macro $v{json};
	}
}
