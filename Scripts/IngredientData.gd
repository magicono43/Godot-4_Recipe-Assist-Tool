extends Node

var ingredients = {}

func _ready():
	ingredients = load_ingredients("res://Data/Ingredients.json")
	#print(ingredients["Cake Flour"]["density"]) # → 120
	#print(ingredients["Butter"]["density"]) # → 227

func load_ingredients(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_error("Ingredients file not found: %s" % path)
		return {}

	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	var data = JSON.parse_string(text)

	return data if typeof(data) == TYPE_DICTIONARY else {}

func get_density(ingredName: String) -> float:
	if ingredients.has(ingredName):
		return ingredients[ingredName].get("density", 0)
	return 0

func get_category(ingredName: String) -> String:
	if ingredients.has(ingredName):
		return ingredients[ingredName].get("category", "Unknown")
	return "Unknown"

# Converts any common cooking unit to weight in grams using density (g/ml)
# density_g_ml = grams per milliliter
# amount = numeric amount
# unit = "ml", "tsp", "tbsp", "cup"
func volume_to_grams(density_g_ml: float, amount: float, unit: String) -> int:
	# All units expressed in ml
	var unit_to_ml = {
		"ml": 1,
		"tsp": 5,
		"tbsp": 15,
		"cup": 240
	}

	if not unit_to_ml.has(unit):
		push_error("Unsupported unit: %s" % unit)
		return 0

	var volume_ml = amount * unit_to_ml[unit]  # Convert to base ml
	return round(density_g_ml * volume_ml)
