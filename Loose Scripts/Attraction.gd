# An Attraction At The Orchard
class_name Attraction extends Node

# How Much Does This Event Cost
var cost: int

# How Much People Want To Go To This
var wow: int

# Simplified Processing Only Runs When A Tick Defined In Plot Completes
func _tick():
	# Defined In Base Classes
    return