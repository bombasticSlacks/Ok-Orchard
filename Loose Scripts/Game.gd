# Tracker For Game And Simulation Stuff
class_name Game extends Node

# Player
@export var player: Player

# Generated Pawns For The Current Day
var pawns: Array

# Plots the game tracks
@export var plots: Plot

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get a timer so we can register ticks
	var timer = get_node("/root/Timer")
	timer.timeout.connect(_tick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	pass