# Tracker For Player Related Values
class_name Player extends Node

# How Much Money The Player Has
@export var money: int = 150
# Track your upgrades I don't think this array can be typed
var upgrades: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	pass
