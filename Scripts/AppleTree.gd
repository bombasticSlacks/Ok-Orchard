# A Tree At The Orchard
class_name AppleTree extends Attraction

# How Many Apples Are On The Tree
var apple_count: int = 0

# How Long Till Apples Regrow in Ticks
var apple_regrow_time: int = 40
var current_tick = 0
var apple_cost = 10

# How long It Takes To Grow The Tree In days
var grow_time: int = 4

var apple_sprites = []

# Different Sprites For Different Phases
enum Growth {PLANTED, GROWING, GROWN}

func _ready():
	var timer = get_node("/root/main/Timer")
	for apple_num in 5:
		apple_sprites.append(get_node(str("Tree/Apple", apple_num)))
	_draw_apples()
	timer.timeout.connect(_tick)

func _draw_apples():
	for apple_num in 5:
		apple_sprites[apple_num].set_visible(apple_num+1 <= apple_count)

func add_apple():
	apple_count = apple_count + 1
	return apple_count;

#Failing to pick from an empty tree returns -1
func remove_apple():
	if apple_count > 0:
		apple_count = apple_count - 1
		_draw_apples()
		return apple_count
	else:
		return -1

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	current_tick = current_tick + 1
	if current_tick == apple_regrow_time:
		add_apple()
		_draw_apples()
		current_tick = 0
