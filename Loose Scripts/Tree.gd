# A Tree At The Orchard
class_name AppleTree extends Attraction

# How Many Apples Are On The Tree
var apple_count: int = 0

# How Long Till Apples Regrow
var apple_regrow_time: int = 0

# How long It Takes To Grow The Tree In Days
var grow_time: int = 4

# Different Sprites For Different Phases
enum Growth {PLANTED, GROWING, GROWN}

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
    # TODO
    pass
