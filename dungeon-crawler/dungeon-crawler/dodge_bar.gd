extends CanvasLayer

# Emitted when the minigame finishes. dodged = true means no damage.
signal finished(dodged: bool)

@onready var needle = $Bar/Needle
@onready var safe_zone = $Bar/SafeZone
@onready var bar = $Bar

const BAR_WIDTH = 400.0       # must match your Bar width in the scene
const SAFE_ZONE_WIDTH = 80.0  # how forgiving the window is

var speed := 300.0            # pixels per second — set via start()
var direction := 1.0
var needle_x := 0.0
var active := false

# Call this from resolve_turn before applying damage.
# enemy_spd and player_spd come from the action data.
func start(enemy_spd: int, player_spd: int) -> void:
	# Faster enemy relative to player = faster needle
	var ratio = clampf(float(enemy_spd) / max(float(player_spd), 1.0), 0.5, 4.0)
	speed = 200.0 * ratio

	# Randomise safe zone position
	var margin = SAFE_ZONE_WIDTH / 2.0
	safe_zone.position.x = randf_range(margin, BAR_WIDTH - margin) - SAFE_ZONE_WIDTH / 2.0

	needle_x = 0.0
	active = true
	show()

func _process(delta: float) -> void:
	if !active:
		return

	needle_x += speed * direction * delta

	if needle_x >= BAR_WIDTH:
		needle_x = BAR_WIDTH
		direction = -1.0
	elif needle_x <= 0.0:
		needle_x = 0.0
		direction = 1.0

	needle.position.x = needle_x

func _unhandled_input(event: InputEvent) -> void:
	if !active:
		return
	if event.is_action_pressed("ui_accept"):  # spacebar / A button by default
		_resolve()

func _resolve() -> void:
	active = false
	hide()

	var safe_start = safe_zone.position.x
	var safe_end = safe_start + SAFE_ZONE_WIDTH
	var dodged = needle_x >= safe_start and needle_x <= safe_end

	emit_signal("finished", dodged)
