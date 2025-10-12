extends Panel

signal child_text_changed_forwarded(new_text: String, parentNode: Node, source: Node)
signal ready_to_fill_result_box_forwarded(parentNode: Node, resultBox: Node)

var _focused_linedit: LineEdit = null

var focusedLine: LineEdit:
	get:
		return _focused_linedit
	set(value):
		_focused_linedit = value

func _init() -> void:
	visible = false

func _ready() -> void:
	var scrollContainer = get_parent().get_node("ScrollContainer")
	var newLineParent = scrollContainer.get_node("VBoxContainer")
	newLineParent.new_entry_created.connect(_on_new_entry_created)
	newLineParent.entry_deleted.connect(_on_entry_deleted)

func _on_new_entry_created(newNode: Node):
	visible = false
	for child in get_node("VBoxContainer").get_children():
		child.queue_free()
	newNode.child_text_changed.connect(_on_child_text_changed)
	newNode.ready_to_fill_result_box.connect(_on_ready_to_fill_result_box)

func _on_entry_deleted():
	visible = false
	for child in get_node("VBoxContainer").get_children():
		child.queue_free()

func _on_child_text_changed(new_text: String, parentNode: Node, source: Node):
	var line_rect = source.get_global_rect()
	size.x = line_rect.size.x
	size.y = line_rect.size.y
	position = Vector2(line_rect.position.x, line_rect.position.y + line_rect.size.y)
	visible = false
	focusedLine = source
	emit_signal("child_text_changed_forwarded", new_text, parentNode, source)

func _on_ready_to_fill_result_box(parentNode: Node, resultBox: Node):
	emit_signal("ready_to_fill_result_box_forwarded", parentNode, resultBox)
