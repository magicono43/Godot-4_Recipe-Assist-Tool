extends Panel

signal text_changed_extended_forwarded(new_text: String, source: Node)

var _focused_linedit: LineEdit = null

var focusedLine: LineEdit:
	get:
		return _focused_linedit
	set(value):
		_focused_linedit = value

func _init() -> void:
	visible = false

func _ready() -> void:
	var newLineParent = get_parent().get_node("VBoxContainer")
	newLineParent.new_entry_created.connect(_on_new_entry_created)
	newLineParent.entry_deleted.connect(_on_entry_deleted)

func _on_new_entry_created(newNode: Node):
	#print("Event received, bitch ass.   ", newNode.name)
	visible = false
	for child in get_node("VBoxContainer").get_children():
		child.queue_free()
	newNode.text_changed_extended.connect(_on_text_changed_extended)

func _on_entry_deleted():
	visible = false
	for child in get_node("VBoxContainer").get_children():
		child.queue_free()

func _on_text_changed_extended(new_text: String, source: Node):
	#print("Fuck You Nigger.   ", new_text, source.name)
	var line_rect = source.get_global_rect()
	size.x = line_rect.size.x
	size.y = line_rect.size.y
	position = Vector2(line_rect.position.x, line_rect.position.y + line_rect.size.y)
	visible = false
	focusedLine = source
	emit_signal("text_changed_extended_forwarded", new_text, source)
