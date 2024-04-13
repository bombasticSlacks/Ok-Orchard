# A character moving around the orchard
class_name Pawn extends CharacterBody2D
# Speed Pawn Moves
var movementSpeed: float = 200.0
# Current Target Position
var movementTargetPosition: Vector2 = Vector2(60.0, 180.0)
var idle: bool = false

# Our Navigation Routines
@onready var navigationAgent: NavigationAgent2D = $NavigationAgent2D

# Moods a pawn can have
# Hungry prioritizes apples
# Uninterested has a higher weight for doing nothing
# Walker likes to go farther away 
enum Mood {HUNGRY, UNINTERESTED, WALKER}

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigationAgent.path_desired_distance = 4.0
	navigationAgent.target_desired_distance = 4.0

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(movementTargetPosition)

func set_movement_target(movement_target: Vector2):
	navigationAgent.target_position = movement_target

func _physics_process(delta):
	# Don't move if where we want to be
	if navigationAgent.is_navigation_finished():
		# If we are idle just skip movement
		if (idle):
			return
		spend()

	var currentAgentPosition: Vector2 = global_position
	var nextPathPosition: Vector2 = navigationAgent.get_next_path_position()

	velocity = currentAgentPosition.direction_to(nextPathPosition) * movementSpeed
	move_and_slide()

# Think About Where To Go Next
func think():
	return

# Spend Money When Arriving
func spend():
	return