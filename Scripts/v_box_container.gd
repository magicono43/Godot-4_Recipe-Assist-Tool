extends VBoxContainer

signal new_entry_created(newNode: Node)
signal entry_deleted()

func _ready() -> void:
	new_entry_created.connect(_on_new_entry_created)
	entry_deleted.connect(_on_entry_deleted)

func _on_button_pressed() -> void:

	var h_box_container = HBoxContainer.new()
	h_box_container.alignment = BoxContainer.ALIGNMENT_CENTER
	h_box_container.custom_minimum_size = Vector2(550, 35)
	h_box_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	h_box_container.add_theme_constant_override("separation", 10)
	h_box_container.clip_contents = true
	add_child(h_box_container)

	var label_1 = Label.new()
	label_1.text = str(0)
	label_1.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_1.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label_1.custom_minimum_size = Vector2(20, 35)
	label_1.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	label_1.add_theme_font_size_override("font_size", 22)
	h_box_container.add_child(label_1)

	var custom_line_edit = preload("res://Scripts/CustomLineEdit.gd").new()
	#line_edit.gui_input.connect(_on_lineedit_gui_input)
	h_box_container.add_child(custom_line_edit)

	var button_1 = Button.new() # Remove Entry Button
	button_1.text = "X"
	button_1.name = "RemoveButton"
	button_1.custom_minimum_size = Vector2(20, 35)
	button_1.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button_1.add_theme_font_size_override("font_size", 22)
	h_box_container.add_child(button_1)
	button_1.pressed.connect(_on_remove_pressed.bind(button_1))

	emit_signal("new_entry_created", custom_line_edit)

func _on_new_entry_created(newNode: Node):
	await get_tree().process_frame
	_update_label_numbers()

func _on_entry_deleted():
	await get_tree().process_frame
	_update_label_numbers()

func _update_label_numbers():
	var entryNumber: int = 0
	for entry in get_children():
		if entry is HBoxContainer:
			entryNumber += 1
			entry.get_child(0).text = str(entryNumber)

func _on_remove_pressed(button: Button) -> void:
	button.get_parent().queue_free()
	emit_signal("entry_deleted")

#func _on_text_changed(new_text: String):
	#_update_results(new_text)
#
#
#func _update_results(query: String):
	#for child in results_container.get_children():
		#child.queue_free()
#
	#if query == "":
		#dropdown.visible = false
		#return
#
	#var matches = items.filter(func(item): return query.to_lower() in item.to_lower())
#
	#if matches.size() == 0:
		#dropdown.visible = false
		#return
#
	## Build result list
	#for match in matches:
		#var btn = Button.new()
		#btn.text = match
		#btn.focus_mode = Control.FOCUS_NONE  # don't steal LineEdit focus
		#btn.pressed.connect(func(): _on_result_pressed(match))
		#results_container.add_child(btn)
#
	#dropdown.visible = true
#
#
#func _on_result_pressed(match: String):
	#line_edit.text = match
	#dropdown.visible = false
#
#
#func _on_lineedit_gui_input(event):
	## Hide dropdown if Esc is pressed
	#if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		#dropdown.visible = false
#
	#var search_2 = SearchBox2.new()
	#h_box_container.add_child(search_2)
