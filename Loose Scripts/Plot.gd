# A place for attractions to go
class_name Plot extends StaticBody2D

# Plots Have An Attraction
var attraction: Attraction
# Cost To Unlock
@export var unlockCost: int
# If it is unlocked
@export var unlocked: bool = false

# Has name through StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass