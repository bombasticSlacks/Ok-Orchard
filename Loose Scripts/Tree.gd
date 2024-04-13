# A Tree At The Orchard
class_name AppleTree extends Attraction

# How Many Apples Are On The Tree
var appleCount: int = 0

# How Long Till Apples Regrow
var appleRegrowTime: int = 0

# How long It Takes To Grow The Tree In Days
var growTime: int = 4

# Different Sprites For Different Phases
enum Growth {PLANTED, GROWING, GROWN}

# Simplified Processing Only Runs When A Tick Defined In Plot Completes
func _tick():
    # TODO
    return
