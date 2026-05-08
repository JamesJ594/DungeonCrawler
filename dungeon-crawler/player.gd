extends Node3D

var move_distance := 10.0
var turn_amount := deg_to_rad(90.0)

var move_time := 0.4
var rotate_time := 0.25

var is_moving := false

func _process(delta):
	handle_input()

func handle_input():

	if is_moving:
		return

	if Input.is_action_just_pressed("move_up"):
		move(-transform.basis.z * move_distance)

	if Input.is_action_just_pressed("move_down"):
		move(transform.basis.z * move_distance)

	if Input.is_action_just_pressed("move_left"):
		turn(turn_amount)

	if Input.is_action_just_pressed("move_right"):
		turn(-turn_amount)

func move(direction: Vector3):

	is_moving = true

	var tween = create_tween()

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"position",
		position + direction,
		move_time
	)

	tween.finished.connect(func():
		is_moving = false
	)

func turn(amount: float):

	is_moving = true

	var tween = create_tween()

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		self,
		"rotation:y",
		rotation.y + amount,
		rotate_time
	)

	tween.finished.connect(func():
		is_moving = false
	)
