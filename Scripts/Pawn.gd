# A character moving around the orchard
class_name Pawn extends CharacterBody2D
# Speed Pawn Moves
var movement_speed: float = 40.0
# Current Target Position
var movement_target_position: Vector2 = Vector2(40.0, 500.0)

# How patient a pawn will be with seeing lots of stuff
var patience: float = .2

enum states {LEAVING, MOVING, IDLE}
var current_state: states = states.IDLE

# Check if we are bouncing up or down
var bounce_state = true

# Time till a pawn thinks
const think_ticks = 30
var tick_count = think_ticks

# How Tired The Pawn Is
var tiredness: int = 0

var current_target: Plot

@export var spriteArray: Array[Texture2D]

# Our Navigation Routines
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Game State
@onready var game: Game = $/root/main

@onready var player: Player = get_node("/root/main/Player")

@onready var starting_position: Vector2

@onready var sprite: Sprite2D = $Sprite2D


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
	
	# Make note of the entrance (where we spawn)
	starting_position = global_position
	
	# get all attractions which exist
	var all_attractions = get_tree().get_nodes_in_group("plots")
	for attraction in all_attractions:
		if attraction.built:
			attractions.append(attraction)
	
	var timer = get_node("/root/main/Timer")
	timer.timeout.connect(_tick)
	
	# Randomize Our Style
	sprite.texture = spriteArray.pick_random()
	sprite.modulate = Color(randf(), randf(), randf())

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
		match current_state:
			# If we have made it to the location stop moving
			states.MOVING:
				current_state = states.IDLE
				sprite.scale.y = 1.0
				velocity = Vector2()
				_spend()
			# If we have made it to the exit leave
			states.LEAVING:
				game.unload_pawn(self)
		# If we aren't navigating then don't give velocity
		return
		
	# Bounce Slightly
	const bounce_speed = .8
	
	if bounce_state:
		sprite.scale.y += bounce_speed * delta
		if sprite.scale.y > 1.1:
			bounce_state = false
	else:
		sprite.scale.y -= bounce_speed * delta
		if sprite.scale.y < 1:
			bounce_state = true
			
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	tick_count -= 1
	if tick_count <= 0:
		_think()


# Think About Where To Go Next
func _think():	
	# If we are leaving we don't want to think
	if current_state == states.LEAVING:
		return
	
	# Check if we've decided to leave
	if randf() < tiredness * patience:
		set_leaving()
		return
	
	# Mark being more tired
	tiredness += 1
	
	# We want to go to something of interest
	var best: Plot
	
	# TODO need more plot details to make good choices for now random
	var current_pawn_position: Vector2 = global_position
	
	best = attractions.pick_random()
	
	if current_target && best.name == current_target.name:
		movement_target_position = global_position + Vector2(randf_range(-150, 150), randf_range(-150, 150))
		current_target = null
	else:
		# randomize location slightly
		movement_target_position = best.global_position + + Vector2(randf_range(-15, 15), randf_range(-15, 15))
		current_target = best
	set_movement_target(movement_target_position)
	current_state = states.MOVING

	
	# Reset Counter
	tick_count = think_ticks

# Spend Money When Arriving
func _spend():
	# TODO define money a tree is worth
	player.money += 10
	
# Set this pawn to be leaving the park
func set_leaving():
	current_state = states.LEAVING
	# If we are leaving we want to set a leaving location and stop thinking
	movement_target_position = starting_position
	set_movement_target(movement_target_position)
