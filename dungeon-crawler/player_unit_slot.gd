extends TextureRect

@onready var unit_data = Unit
const DEPRIVED = preload("res://Deprived.tres")


func _ready() -> void:
	unit_data = DEPRIVED.duplicate()
	texture = unit_data.icon


func _get_drag_data(at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.texture = unit_data.icon
	
	set_drag_preview(preview)
	
	return unit_data

func take_damage(amount: int) -> void:
	unit_data.HP -= amount
	
	if unit_data.HP <= 0:
		queue_free()

func _process(delta: float) -> void:
	pass
