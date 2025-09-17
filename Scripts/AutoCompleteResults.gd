extends VBoxContainer

var itemNames: Array[String] = []
var measureTypes: Array[String] = ["Milliliters", "Teaspoons", "Tablespoons", "Cups"]
var itemDensities: Array[float] = []

func _ready() -> void:
	var parent = get_parent()
	parent.child_text_changed_forwarded.connect(_on_child_text_changed_forwarded)
	parent.ready_to_fill_result_box_forwarded.connect(_on_ready_to_fill_result_box_forwarded)
	itemNames = IngredientDB.get_all_ingred_names()

func _on_child_text_changed_forwarded(new_text: String, parentNode: Node, source: Node):
	get_parent().visible = false

	for child in get_children():
		child.queue_free()  # schedules each child for removal

	if new_text.is_empty():
		get_parent().visible = false
		return

	var validItems: Array[String] = []
	var options: Array[String] = []
	if source.tag == "Item Name":
		options = itemNames
	elif source.tag == "Measure Type":
		options = measureTypes
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
	lineEdit.emit_signal("text_changed_extended", resultName, lineEdit)
	get_parent().visible = false
	for child in get_children():
		child.queue_free()  # schedules each child for removal

func _on_ready_to_fill_result_box_forwarded(parentNode: Node, resultBox: Node):
	resultBox.text = ""
	if parentNode.resultBoxReadyToFill:
		var itemName: String = parentNode.textEntryRefs[0].text
		var itemQuantity: float = float(parentNode.textEntryRefs[1].text)
		var measureType: String = parentNode.textEntryRefs[2].text
		if resultBox != null:
			resultBox.text = str(IngredientDB.volume_to_grams(IngredientDB.get_density(itemName), itemQuantity, measureType))
