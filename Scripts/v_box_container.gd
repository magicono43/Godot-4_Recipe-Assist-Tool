extends VBoxContainer

signal new_entry_created(newNode: Node)
signal entry_deleted()

func _ready() -> void:
	new_entry_created.connect(_on_new_entry_created)
	entry_deleted.connect(_on_entry_deleted)

func _on_button_pressed() -> void:

	var custom_h_box_container = preload("res://Scripts/CustomHBoxContainer.gd").new()
	add_child(custom_h_box_container)

	var label_1 = Label.new()
	label_1.text = str(0)
	label_1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_1.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label_1.custom_minimum_size = Vector2(20, 35)
	label_1.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label_1.add_theme_font_size_override("font_size", 22)
	custom_h_box_container.add_child(label_1)

	var custom_line_edit = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit.tag = "Item Name"
	custom_line_edit.placeholder_text = "Item Name"
	custom_line_edit.custom_minimum_size = Vector2(250, 35)
	custom_line_edit.set_allow_regex("^[A-Za-z]*$")
	#line_edit.gui_input.connect(_on_lineedit_gui_input)
	custom_h_box_container.add_child(custom_line_edit)
	custom_h_box_container.textEntryRefs.append(custom_line_edit)

	var custom_line_edit_2 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_2.tag = "Number"
	custom_line_edit_2.placeholder_text = "Amount"
	custom_line_edit_2.custom_minimum_size = Vector2(75, 35)
	custom_line_edit_2.set_allow_regex("^[0-9]*\\.?[0-9]*$")
	custom_h_box_container.add_child(custom_line_edit_2)
	custom_h_box_container.textEntryRefs.append(custom_line_edit_2)

	var custom_line_edit_3 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_3.tag = "Measure Type"
	custom_line_edit_3.placeholder_text = "Measure Type"
	custom_line_edit_3.custom_minimum_size = Vector2(125, 35)
	custom_line_edit_3.set_allow_regex("^[A-Za-z]*$")
	custom_h_box_container.add_child(custom_line_edit_3)
	custom_h_box_container.textEntryRefs.append(custom_line_edit_3)
	custom_h_box_container.sub_to_text_entry_signals()

	var custom_line_edit_4 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_4.tag = "Result"
	custom_line_edit_4.placeholder_text = "Result"
	custom_line_edit_4.custom_minimum_size = Vector2(75, 35)
	custom_line_edit_4.set_allow_regex("^[0-9]*$")
	custom_h_box_container.add_child(custom_line_edit_4)
	custom_h_box_container.resultBoxRef = custom_line_edit_4

	var arrow_buttons_container = VBoxContainer.new()
	arrow_buttons_container.custom_minimum_size = Vector2(20, 35)
	arrow_buttons_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	arrow_buttons_container.add_theme_constant_override("separation", 3)
	arrow_buttons_container.clip_contents = true
	custom_h_box_container.add_child(arrow_buttons_container)
	var move_up_button = TextureButton.new()
	move_up_button.texture_normal = load("res://Textures/Up_Arrow_Normal.png")
	move_up_button.texture_hover = load("res://Textures/Up_Arrow_Hover.png")
	move_up_button.texture_pressed = load("res://Textures/Up_Arrow_Pressed.png")
	move_up_button.custom_minimum_size = Vector2(20, 16)
	move_up_button.stretch_mode = TextureButton.STRETCH_KEEP
	arrow_buttons_container.add_child(move_up_button)
	move_up_button.pressed.connect(_on_change_order_pressed.bind(move_up_button, true))
	var move_down_button = TextureButton.new()
	move_down_button.texture_normal = load("res://Textures/Down_Arrow_Normal.png")
	move_down_button.texture_hover = load("res://Textures/Down_Arrow_Hover.png")
	move_down_button.texture_pressed = load("res://Textures/Down_Arrow_Pressed.png")
	move_down_button.custom_minimum_size = Vector2(20, 16)
	move_down_button.stretch_mode = TextureButton.STRETCH_KEEP
	arrow_buttons_container.add_child(move_down_button)
	move_down_button.pressed.connect(_on_change_order_pressed.bind(move_down_button, false))

	var button_1 = Button.new() # Remove Entry Button
	button_1.text = "X"
	button_1.name = "RemoveButton"
	button_1.custom_minimum_size = Vector2(20, 35)
	button_1.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button_1.add_theme_font_size_override("font_size", 22)
	custom_h_box_container.add_child(button_1)
	button_1.pressed.connect(_on_remove_pressed.bind(button_1))

	emit_signal("new_entry_created", custom_h_box_container)

func _on_new_entry_created(newNode: Node):
	await get_tree().process_frame
	_update_label_numbers()

func _on_entry_deleted():
	await get_tree().process_frame
	_update_label_numbers()

func _update_label_numbers():
	if get_parent().get_v_scroll_bar().visible == false:
		# Get total height of all children
		var total_height := 0.0
		for child in get_children():
			if child.visible:
				total_height += child.size.y + get_theme_constant("separation")  # account for spacing
		# Subtract the last separation added
		if total_height > 0:
			total_height -= get_theme_constant("separation")
		# Get the visible area of the ScrollContainer
		var visible_height: float = get_parent().size.y
		# Calculate offset to center VBox within the visible area
		var offset: float = max((visible_height - total_height) / 2.0, 0.0)
		position.y = offset

	var entryNumber: int = 0
	for entry in get_children():
		if entry is HBoxContainer:
			entryNumber += 1
			entry.get_child(0).text = str(entryNumber)

func _on_change_order_pressed(button: TextureButton, upOrDown: bool) -> void:
	var totalEntries: int = 0
	var currentEntryNum: int = 0
	for entry in get_children():
		if entry is HBoxContainer:
			totalEntries += 1
			if button.get_parent().get_parent() == entry:
				currentEntryNum = totalEntries
	if totalEntries <= 1: return
	if upOrDown: if currentEntryNum == 1: return
	if !upOrDown: if currentEntryNum == totalEntries: return

	var childEntry: Node = button.get_parent().get_parent()
	if upOrDown: move_child(childEntry, currentEntryNum - 2)
	else: move_child(childEntry, currentEntryNum)

	await get_tree().process_frame
	_update_label_numbers()
	emit_signal("entry_deleted") # Just to hide auto-complete box if visible.

func _on_remove_pressed(button: Button) -> void:
	button.get_parent().queue_free()
	emit_signal("entry_deleted")
