extends VBoxContainer

signal new_entry_created(newNode: Node)
signal entry_deleted()

func _ready() -> void:
	new_entry_created.connect(_on_new_entry_created)
	entry_deleted.connect(_on_entry_deleted)

func _on_button_pressed() -> void:

	var custom_h_box_container = preload("res://Scripts/CustomHBoxContainer.gd").new()
	add_child(custom_h_box_container)

	## Next try to get a small data-base going and accessible for the
	## weight values of items entered and such, also a label for this info.

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
	#line_edit.gui_input.connect(_on_lineedit_gui_input)
	custom_h_box_container.add_child(custom_line_edit)
	custom_h_box_container.textEntryRefs.append(custom_line_edit)

	var custom_line_edit_2 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_2.tag = "Number"
	custom_line_edit_2.placeholder_text = "Amount"
	custom_line_edit_2.custom_minimum_size = Vector2(75, 35)
	custom_h_box_container.add_child(custom_line_edit_2)
	custom_h_box_container.textEntryRefs.append(custom_line_edit_2)

	var custom_line_edit_3 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_3.tag = "Measure Type"
	custom_line_edit_3.placeholder_text = "Measure Type"
	custom_line_edit_3.custom_minimum_size = Vector2(125, 35)
	custom_h_box_container.add_child(custom_line_edit_3)
	custom_h_box_container.textEntryRefs.append(custom_line_edit_3)
	custom_h_box_container.sub_to_text_entry_signals()

	var custom_line_edit_4 = preload("res://Scripts/CustomLineEdit.gd").new()
	custom_line_edit_4.tag = "Result"
	custom_line_edit_4.placeholder_text = "Result"
	custom_line_edit_4.custom_minimum_size = Vector2(75, 35)
	custom_h_box_container.add_child(custom_line_edit_4)
	custom_h_box_container.resultBoxRef = custom_line_edit_4

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
	#print(IngredientDB.volume_to_grams(IngredientDB.get_density("All Purpose Flour"), 1, "cup"))
	#print(IngredientDB.volume_to_grams(IngredientDB.get_density("All Purpose Flour"), 0.5, "cup"))
	#print(IngredientDB.volume_to_grams(IngredientDB.get_density("All Purpose Flour"), 0.25, "cup"))
	#print(IngredientDB.volume_to_grams(IngredientDB.get_density("Butter"), 1, "cup"))
	#print(IngredientDB.volume_to_grams(IngredientDB.get_density("Butter"), 0.5, "cup"))
	#print(IngredientDB.volume_to_grams(IngredientDB.get_density("Butter"), 0.25, "cup"))

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
