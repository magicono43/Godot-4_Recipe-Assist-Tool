extends HBoxContainer

signal child_text_changed(new_text: String, parentNode: Node, sourceNode: Node)
signal ready_to_fill_result_box(parentNode: Node, resultBox: Node)

var textEntryRefs: Array[LineEdit] = []
var resultBoxRef: LineEdit = null
var resultBoxReadyToFill: bool = false

func _init():
	alignment = BoxContainer.ALIGNMENT_CENTER
	custom_minimum_size = Vector2(550, 35)
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	add_theme_constant_override("separation", 10)
	clip_contents = true

func sub_to_text_entry_signals():
	textEntryRefs[0].text_changed_extended.connect(_on_child_text_changed)
	textEntryRefs[1].text_changed_extended.connect(_on_child_text_changed)
	textEntryRefs[2].text_changed_extended.connect(_on_child_text_changed)

func _on_child_text_changed(new_text: String, source: Node):
	if textEntryRefs[0].text != "" and textEntryRefs[1].text != "" and textEntryRefs[2].text != "":
		resultBoxReadyToFill = true
	else:
		resultBoxReadyToFill = false
	emit_signal("child_text_changed", new_text, self, source)
	emit_signal("ready_to_fill_result_box", self, resultBoxRef)
