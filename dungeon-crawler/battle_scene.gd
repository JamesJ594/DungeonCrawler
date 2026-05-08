extends Control

@onready var player_unit_container: VBoxContainer = $PlayerUnitContainer
@onready var enemy_unit_container: HBoxContainer = $EnemyUnitContainer

const PLAYER_UNIT_SLOT = preload("res://player_unit_slot.tscn")
const ENEMY_UNIT_SLOT = preload("res://enemy_unit_slot.tscn")

func _ready() -> void:

	# Spawn player units
	for i in range(4):
		var player_unit_instance = PLAYER_UNIT_SLOT.instantiate()

		# Add to combat groups
		player_unit_instance.add_to_group("player_units")

		player_unit_container.add_child(player_unit_instance)

	# Spawn enemies
	for i in range(3):
		var enemy_unit_instance = ENEMY_UNIT_SLOT.instantiate()

		# Add to combat groups
		enemy_unit_instance.add_to_group("enemy_units")

		enemy_unit_container.add_child(enemy_unit_instance)

	# Tell BattleManager how many player units exist
	CombatManager.set_total_player_units(
		get_tree().get_nodes_in_group("player_units").size()
	)

	# Queue enemy attacks for the turn
	CombatManager.queue_enemy_turns()

func _process(delta: float) -> void:
	pass
