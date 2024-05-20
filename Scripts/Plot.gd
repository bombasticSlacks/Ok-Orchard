# A place for attractions to go
class_name Plot extends StaticBody2D

# Cost To Unlock
@export var unlock_cost: int = 100
# If it is unlocked
@export var unlocked: bool = false
# If this is built
@export var built: bool = false

@onready var plot_color: Polygon2D = $Polygon2D

# Player
@onready var player: Player = $/root/main/Player

signal sig_buy_menu(plot)

# Preload Tree Node
var tree = preload("res://tree.tscn")

var trees: Array[AppleTree]

# Plots Have An Attraction
#@onready var attraction: Attraction = $Attraction

# Called when the node enters the scene tree for the first time.
func _ready():
	if unlocked:
		plot_color.color = Color("3498db")
	else:
		plot_color.color = Color("eb3c2d")

	# Load up potential trees
	var tempTree: AppleTree = tree.instantiate()
	trees.append(tempTree)
	
	#starting trees
	if(built):
		var index = 0
		# Add tree to the plot
		trees[index].add_apple()
		add_child(trees[index])
		plot_color.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func buy_tree():
	var index = 0
	if trees.size() > 0 && player.money >= trees[index].cost:
		built = true
		player.money -= trees[index].cost
		# Add tree to the plot
		add_child(trees[index])
		plot_color.visible = false

func remove_tree():
	remove_child(trees[0])
	built = false
	plot_color.visible = true

# Happens when the plot is purchased
func buy_plot():
	if player.money >= unlock_cost:
		unlocked = true
		player.money -= unlock_cost
		plot_color.color = Color("3498db")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			sig_buy_menu.emit(self, event.position)

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	if unlocked:
		plot_color.color = Color("b2dbfc")
	else:
		plot_color.color = Color("fdb9ae")

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if unlocked:
		plot_color.color = Color("3498db")
	else:
		plot_color.color = Color("eb3c2d")
