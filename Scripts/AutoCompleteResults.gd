extends VBoxContainer

var itemNames: Array[String] = []
var measureTypes: Array[String] = ["Milliliters", "Teaspoons", "Tablespoons", "Cups"]
var itemDensities: Array[float] = []

func _ready() -> void:
	var parent = get_parent()
	parent.text_changed_extended_forwarded.connect(_on_text_changed_extended_forwarded)
	itemNames = IngredientDB.get_all_ingred_names()

func _on_text_changed_extended_forwarded(new_text: String, source: Node):
	get_parent().visible = false

	for child in get_children():
		child.queue_free()  # schedules each child for removal

	if new_text.is_empty():
		get_parent().visible = false
		_try_to_populate_result_box(source)
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

	_try_to_populate_result_box(source)

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

	_try_to_populate_result_box(lineEdit)

func _try_to_populate_result_box(source: Node) -> void:
	var neededInfoCounter: int = 0
	for textBox in source.get_parent().get_children():
		if textBox is LineEdit:
			if textBox.tag == "Result": textBox.text = ""
			if textBox.tag == "Item Name" or textBox.tag == "Number" or textBox.tag == "Measure Type":
				if textBox.text != "":
					neededInfoCounter += 1

	if neededInfoCounter >= 3:
		var itemName: String = ""
		var itemQuantity: float = 0
		var measureType: String = ""
		var resultBox: LineEdit = null
		for textBox in source.get_parent().get_children():
			if textBox is LineEdit:
				if textBox.tag == "Result":
					resultBox = textBox
		for textBox in source.get_parent().get_children():
			if textBox is LineEdit:
				if textBox.tag == "Item Name": itemName = textBox.text
				elif textBox.tag == "Number": itemQuantity = float(textBox.text)
				elif textBox.tag == "Measure Type": measureType = textBox.text
		if resultBox != null:
			resultBox.text = str(IngredientDB.volume_to_grams(IngredientDB.get_density(itemName), itemQuantity, measureType))
