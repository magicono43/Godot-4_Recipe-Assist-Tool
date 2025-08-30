extends Node

var ingredients = {}

func _ready():
	ingredients = load_ingredients("res://Data/Ingredients.json")
	print(ingredients["Cake Flour"]["weight_per_cup"]) # → 120
	print(ingredients["Butter"]["weight_per_cup"]) # → 227

func load_ingredients(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Ingredients file not found: %s" % path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	var data = JSON.parse_string(text)

	return data if typeof(data) == TYPE_DICTIONARY else {}

func get_weight(ingredName: String) -> int:
	if ingredients.has(ingredName):
		return ingredients[ingredName].get("weight_per_cup", 0)
	return 0

func get_category(ingredName: String) -> String:
	if ingredients.has(ingredName):
		return ingredients[ingredName].get("category", "Unknown")
	return "Unknown"
