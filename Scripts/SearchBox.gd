extends Control
class_name SearchBox

var line_edit: LineEdit
var popup: PopupMenu

var options = ["Flour", "White Sugar", "Brown Sugar", "Salt", "Butter", "Baking Soda"]

func _init() -> void:
	# Configure container
	custom_minimum_size = Vector2(250, 35)
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER

	# Create LineEdit (the input box)
	line_edit = LineEdit.new()
	line_edit.placeholder_text = "Type Here Bitch 1"
	line_edit.alignment = HORIZONTAL_ALIGNMENT_CENTER
	line_edit.custom_minimum_size = Vector2(250, 35)
	line_edit.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	line_edit.add_theme_font_size_override("font_size", 13)
	add_child(line_edit)

	# Create PopupMenu (the dropdown list)
	popup = PopupMenu.new()
	add_child(popup)

	# Connect signals
	line_edit.text_changed.connect(_on_text_changed)
	popup.id_pressed.connect(_on_item_selected)


func _on_text_changed(new_text: String) -> void:
	popup.clear()
	if new_text.strip_edges() == "":
		popup.hide()
		return

	# Add items that match text
	for opt in options:
		if opt.to_lower().begins_with(new_text.to_lower()):
			popup.add_item(opt)

	if popup.item_count > 0:
		show_popup()
		line_edit.grab_focus()
	else:
		popup.hide()


func show_popup():
	# Get global position of LineEdit
	var pos = line_edit.get_global_position()
	# Place popup just below the LineEdit
	pos.y += line_edit.size.y

	popup.set_position(pos)
	popup.reset_size()
	#popup.popup()
	popup.show()


func _on_item_selected(id: int) -> void:
	line_edit.text = popup.get_item_text(id)
	popup.hide()
	line_edit.grab_focus()
