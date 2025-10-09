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
	placeholder_text = "Multiply"
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_theme_font_size_override("font_size", 13)

func _ready():
	tag = "Multiplier"
	text_changed.connect(_on_text_changed)
	_last_valid_text = text
	set_allow_regex("^[0-9]*\\.?[0-9]*$")

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

func set_allow_regex(pattern: String):
	allow_regex = RegEx.new()
	var err = allow_regex.compile(pattern)
	if err != OK:
		printerr("Bad regex pattern: ", pattern)
