extends VBoxContainer

func _ready() -> void:
	_populate_children_nodes()

func _populate_children_nodes() -> void:
	var h_box_container_1 = HBoxContainer.new()
	h_box_container_1.alignment = BoxContainer.ALIGNMENT_CENTER
	h_box_container_1.custom_minimum_size = Vector2(550, 35)
	h_box_container_1.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	h_box_container_1.add_theme_constant_override("separation", 10)
	h_box_container_1.clip_contents = true
	add_child(h_box_container_1)

	var custom_line_edit_1 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_1.tag = "Ingredient Name"
	custom_line_edit_1.placeholder_text = "Ingredient Name"
	custom_line_edit_1.custom_minimum_size = Vector2(300, 35)
	custom_line_edit_1.set_allow_regex("^[A-Za-z]*$")
	h_box_container_1.add_child(custom_line_edit_1)

	var h_box_container_2 = HBoxContainer.new()
	h_box_container_2.alignment = BoxContainer.ALIGNMENT_CENTER
	h_box_container_2.custom_minimum_size = Vector2(550, 35)
	h_box_container_2.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	h_box_container_2.add_theme_constant_override("separation", 10)
	h_box_container_2.clip_contents = true
	add_child(h_box_container_2)

	var custom_line_edit_2 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_2.tag = "Density Value"
	custom_line_edit_2.placeholder_text = "Density Value"
	custom_line_edit_2.custom_minimum_size = Vector2(300, 35)
	custom_line_edit_2.set_allow_regex("^[0-9]*\\.?[0-9]*$")
	h_box_container_2.add_child(custom_line_edit_2)

	var h_box_container_3 = HBoxContainer.new()
	h_box_container_3.alignment = BoxContainer.ALIGNMENT_CENTER
	h_box_container_3.custom_minimum_size = Vector2(550, 35)
	h_box_container_3.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	h_box_container_3.add_theme_constant_override("separation", 10)
	h_box_container_3.clip_contents = true
	add_child(h_box_container_3)

	var custom_line_edit_3 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_3.tag = "Ingredient Category"
	custom_line_edit_3.placeholder_text = "Ingredient Category"
	custom_line_edit_3.custom_minimum_size = Vector2(300, 35)
	custom_line_edit_3.set_allow_regex("^[A-Za-z]*$")
	h_box_container_3.add_child(custom_line_edit_3)

	var h_box_container_4 = HBoxContainer.new()
	h_box_container_4.alignment = BoxContainer.ALIGNMENT_CENTER
	h_box_container_4.custom_minimum_size = Vector2(550, 35)
	h_box_container_4.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	h_box_container_4.add_theme_constant_override("separation", 10)
	h_box_container_4.clip_contents = true
	add_child(h_box_container_4)

	var custom_line_edit_4 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_4.tag = "Alias 1"
	custom_line_edit_4.placeholder_text = "Alias 1"
	custom_line_edit_4.custom_minimum_size = Vector2(145, 35)
	custom_line_edit_4.set_allow_regex("^[A-Za-z]*$")
	h_box_container_4.add_child(custom_line_edit_4)

	var custom_line_edit_5 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_5.tag = "Alias 2"
	custom_line_edit_5.placeholder_text = "Alias 2"
	custom_line_edit_5.custom_minimum_size = Vector2(145, 35)
	custom_line_edit_5.set_allow_regex("^[A-Za-z]*$")
	h_box_container_4.add_child(custom_line_edit_5)

	await get_tree().process_frame

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
