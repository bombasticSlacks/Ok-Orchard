# A place for attractions to go
class_name Plot extends StaticBody2D

# Cost To Unlock
@export var unlock_cost: int
# If it is unlocked
@export var unlocked: bool = false
# If this is built
@export var built: bool = false
# Plots Have An Attraction
#@onready var attraction: Attraction = $Attraction

# Has name through StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
