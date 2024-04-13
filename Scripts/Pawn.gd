# A character moving around the orchard
class_name Pawn extends CharacterBody2D
# Speed Pawn Moves
var movement_speed: float = 40.0
# Current Target Position
@export var movement_target_position: Vector2 = Vector2(40.0, 500.0)
var idle: bool = false

# Our Navigation Routines
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# All Attractions
var attractions: Array[Plot]

# Moods a pawn can have
# Hungry prioritizes apples
# Uninterested has a higher weight for doing nothing
# Walker likes to go farther away 
enum Mood {HUNGRY, UNINTERESTED, WALKER}

func _ready():
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup")
	
	
	# get all attractions which exist
	var all_attractions = get_tree().get_nodes_in_group("plots")
	for attraction in all_attractions:
		if attraction.built:
			attractions.append(attraction)
	
	# Get a timer so we can register ticks
	# var timer = get_node("/root/Timer")
	# timer.timeout.connect(_tick)

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Need to start thinking right away
	_think()

func set_movement_target(movement_target: Vector2):
	navigation_agent.target_position = movement_target

func _physics_process(delta):
	# Don't move if where we want to be
	if navigation_agent.is_navigation_finished():
		# If we are idle just skip movement
		if (!idle):
			velocity = Vector2()
			_spend()
			# TODO Remove with timer
			_think()
		return
		

	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	pass

# Think About Where To Go Next
func _think():
	# We want to go to something of interest
	var best: Plot
	
	# TODO need more plot details to make good choices for now random
	var current_pawn_position: Vector2 = global_position
	
	best = attractions.pick_random()
	
	movement_target_position = best.global_position
	set_movement_target(movement_target_position)

# Spend Money When Arriving
func _spend():
	pass
