# An Attraction At The Orchard
class_name Attraction extends Node

# How Much Does This Event Cost
var cost: int

# How Much People Want To Go To This
var wow: int

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get a timer so we can register ticks
	var timer = get_node("/root/Timer")
	timer.timeout.connect(_tick)

# Simplified Processing Only Runs When A Tick Defined In Plot Completes
func _tick():
	# Defined In Base Classes
    pass