extends Node

@onready var dodge_bar = preload("res://DodgeBar.tscn")  # adjust path to wherever you place the scene

var pending_player_attacks : Array = []
var pending_enemy_attacks : Array = []
var total_player_units := 0

func set_total_player_units(amount:int):
	total_player_units = amount
	print("Total player units: ", total_player_units)

func queue_attack(attacker, target):
	var action = {
		"attacker": attacker,
		"target": target,
		"speed": attacker.SPD
	}
	if target.is_in_group("enemy_units"):
		pending_player_attacks.append(action)
		print(attacker.name, " queued player attack.")
	else:
		pending_enemy_attacks.append(action)
		print(attacker.name, " queued enemy attack.")
	check_turn_ready()

func queue_enemy_turns():
	pending_enemy_attacks.clear()
	var enemies = get_tree().get_nodes_in_group("enemy_units")
	var players = get_tree().get_nodes_in_group("player_units")
	for enemy in enemies:
		if players.is_empty():
			return
		var random_target = players.pick_random()
		queue_attack(enemy.unit_data, random_target)

func check_turn_ready():
	print("Player actions: ", pending_player_attacks.size(), "/", total_player_units)
	if pending_player_attacks.size() >= total_player_units:
		resolve_turn()

func resolve_turn():
	print("Resolving Turn")

	var combat_queue : Array = []
	combat_queue.append_array(pending_player_attacks)
	combat_queue.append_array(pending_enemy_attacks)

	combat_queue.sort_custom(func(a, b):
		return a["speed"] > b["speed"]
	)

	for action in combat_queue:
		var attacker = action["attacker"]
		var target = action["target"]

		if !is_instance_valid(attacker) or !is_instance_valid(target):
			continue
		var attacker_hp = attacker.HP if attacker is Resource else attacker.unit_data.HP
		var target_hp = target.HP if target is Resource else target.unit_data.HP
		if attacker_hp <= 0 or target_hp <= 0:
			continue

		print(attacker.name, " attacks ", target.name)

		# Only show dodge bar for enemy -> player attacks
		if target.is_in_group("player_units"):
			var enemy_spd = attacker.SPD if attacker is Resource else attacker.unit_data.SPD
			var player_spd = target.unit_data.SPD
			dodge_bar.start(enemy_spd, player_spd)
			var dodged = await dodge_bar.finished
			if dodged:
				print(target.name, " dodged the attack!")
				await get_tree().create_timer(0.5).timeout
				continue

		target.take_damage(attacker.PWR)
		await get_tree().create_timer(0.5).timeout

	# Reset turn
	pending_player_attacks.clear()
	pending_enemy_attacks.clear()

	# Check end condition BEFORE queuing next enemy turn
	if get_tree().get_nodes_in_group("enemy_units").size() == 0 \
	or get_tree().get_nodes_in_group("player_units").size() == 0:
		get_tree().change_scene_to_file("res://world.tscn")
		return  # Stop here — don't plan a new turn on a dying scene

	queue_enemy_turns()
	print("Turn End")
