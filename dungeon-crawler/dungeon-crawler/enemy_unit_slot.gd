extends TextureRect

@onready var unit_data : Unit
const THRALL = preload("res://Thrall.tres")


func _ready() -> void:
	unit_data = THRALL.duplicate()
	texture = unit_data.icon

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	
	return data is Unit

func _drop_data(at_position: Vector2, data: Variant) -> void:
	
	CombatManager.queue_attack(data, self)

func take_damage(amount:int):
	unit_data.HP -= amount
	
	print("Thrall took ", amount, " damage!")
	
	if unit_data.HP <= 0:
		queue_free()

func _process(delta: float) -> void:
	pass
