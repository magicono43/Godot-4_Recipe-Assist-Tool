extends Control
class_name SearchBox2

var line_edit: LineEdit
var dropdown: Panel
var results_container: VBoxContainer

# Example list of items to "autocomplete"
var items = ["Apple", "Apricot", "Banana", "Blackberry", "Blueberry", "Cherry", "Date"]

func _init():
	# Create LineEdit
	line_edit = LineEdit.new()
	line_edit.placeholder_text = "Search..."
	line_edit.text_changed.connect(_on_text_changed)
	line_edit.gui_input.connect(_on_lineedit_gui_input)
	add_child(line_edit)

	# Create dropdown panel (hidden by default)
	dropdown = Panel.new()
	dropdown.visible = false
	add_child(dropdown)

	# Container for results
	results_container = VBoxContainer.new()
	dropdown.add_child(results_container)


func _on_text_changed(new_text: String):
	_update_results(new_text)


func _update_results(query: String):
	for child in results_container.get_children():
		child.queue_free()

	if query == "":
		dropdown.visible = false
		return

	var matches = items.filter(func(item): return query.to_lower() in item.to_lower())

	if matches.size() == 0:
		dropdown.visible = false
		return

	# Build result list
	for match in matches:
		var btn = Button.new()
		btn.text = match
		btn.focus_mode = Control.FOCUS_NONE  # don't steal LineEdit focus
		btn.pressed.connect(func(): _on_result_pressed(match))
		results_container.add_child(btn)

	dropdown.visible = true


func _on_result_pressed(match: String):
	line_edit.text = match
	dropdown.visible = false


func _on_lineedit_gui_input(event):
	# Hide dropdown if Esc is pressed
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		dropdown.visible = false
