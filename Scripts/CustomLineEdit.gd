extends LineEdit

signal text_changed_extended(new_text: String, source: Node)

var _tag: String = ""

var tag: String:
	get:
		return _tag
	set(value):
		_tag = value

var allow_regex: RegEx
var _last_valid_text: String = ""

func _init():
	placeholder_text = "Type Here 1"
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	custom_minimum_size = Vector2(250, 35)
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_theme_font_size_override("font_size", 13)

func _ready():
	text_changed.connect(_on_text_changed)
	_last_valid_text = text

func _on_text_changed(new_text: String):
	if allow_regex:
		# check if whole string matches pattern
		var res = allow_regex.search(new_text)
		# Or use compile + match entirely
		if res == null or res.get_string() != new_text:
			# it's not valid, revert to old text or filter
			text = _last_valid_text
			caret_column = text.length() # keep caret at end
			return
	_last_valid_text = new_text
	emit_signal("text_changed_extended", new_text, self)

## Tomorrow, maybe see if I can have a little popup show up when trying to enter
## invalid characters into a specific text-entry field, just to give some
## indication what is intended to go there, not a big deal though for that
## it would be primarily polish at that point.
##
## If I don't decide to work on that, then maybe see if I can get like a list
## of "alternate names" for various ingredients in my data-base. So like
## if you happen to call powdered sugar, confectioners sugar. Or
## All Purpose Flour, White Flour, or just Flour or something, then the
## auto-complete and data-base would account for that and still hopefully
## give you the result you were looking for or something like that.
## And maybe even something similar to how Interkarma did the location
## searching on the world-map UI for Daggerfall Unity, where entering
## in text gives you the "closest match" sort of thing, instead of having
## to be exact from start to finish, will see.

func set_allow_regex(pattern: String):
	allow_regex = RegEx.new()
	var err = allow_regex.compile(pattern)
	if err != OK:
		printerr("Bad regex pattern: ", pattern)
