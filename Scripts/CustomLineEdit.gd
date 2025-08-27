extends LineEdit

signal text_changed_extended(new_text: String, source: Node)

func _init():
	placeholder_text = "Type Here Bitch 1"
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	custom_minimum_size = Vector2(250, 35)
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_theme_font_size_override("font_size", 13)

func _ready():
	text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String):
	emit_signal("text_changed_extended", new_text, self)
