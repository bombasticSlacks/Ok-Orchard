# A character moving around the orchard
class_name Pawn extends CharacterBody2D
# Speed Pawn Moves
var movement_speed: float = 200.0
# Current Target Position
var movement_target_position: Vector2 = Vector2(60.0, 180.0)
var idle: bool = false

# Our Navigation Routines
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Moods a pawn can have
# Hungry prioritizes apples
# Uninterested has a higher weight for doing nothing
# Walker likes to go farther away 
enum Mood {HUNGRY, UNINTERESTED, WALKER}

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 4.0
	navigation_agent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

	# Get a timer so we can register ticks
	var timer = get_node("/root/Timer")
	timer.timeout.connect(_tick)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movement_target_position)

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	# Don't move if where we want to be
	if navigation_agent.is_navigation_finished():
		# If we are idle just skip movement
		if (idle):
			return
		_spend()

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	pass

# Think About Where To Go Next
func _think():
	pass

# Spend Money When Arriving
func _spend():
	pass