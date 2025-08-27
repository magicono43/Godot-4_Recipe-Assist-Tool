extends VBoxContainer

var options = ["Flour", "White Sugar", "Brown Sugar", "Salt", "Butter", "Baking Soda"]

func _ready() -> void:
	var parent = get_parent()
	parent.text_changed_extended_forwarded.connect(_on_text_changed_extended_forwarded)

func _on_text_changed_extended_forwarded(new_text: String, source: Node):
	get_parent().visible = false

	for child in get_children():
		child.queue_free()  # schedules each child for removal

	if new_text.is_empty():
		get_parent().visible = false
		return

	var validItems: Array[String] = []
	# Add items that match text
	for opt in options:
		if opt.to_lower().begins_with(new_text.to_lower()):
			validItems.append(opt)

	if validItems.size() > 0:
		for item in validItems:
			var newButton = Button.new()
			newButton.text = item
			newButton.pressed.connect(_on_search_result_pressed.bind(newButton))
			add_child(newButton)

	var childrenLeft: int = 0
	for child in get_children():
		if child.is_queued_for_deletion() == false:
			childrenLeft += 1

	if childrenLeft > 0:
		#print("There are children")
		get_parent().visible = true
	else:
		#print("No children exist")
		get_parent().visible = false

func _on_search_result_pressed(button: Button) -> void:
	var resultName: String = button.text

	var lineEdit: LineEdit = get_parent().focusedLine
	if lineEdit == null:
		return

	lineEdit.text = resultName
	get_parent().visible = false
	for child in get_children():
		child.queue_free()  # schedules each child for removal
