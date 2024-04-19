# A place for attractions to go
class_name Plot extends StaticBody2D

# Cost To Unlock
@export var unlock_cost: int = 100
# If it is unlocked
@export var unlocked: bool = false
# If this is built
@export var built: bool = false

# Buy Plot UI
@onready var buy_label: Label = $BuyPlot/PanelContainer/BoxContainer/Label
@onready var buy_menu: Control = $BuyPlot
@onready var button: Button = $BuyPlot/PanelContainer/BoxContainer/HBoxContainer/Button

# Buy Tree UI
@onready var buy_tree_label: Label = $BuyTree/PanelContainer/BoxContainer/Label
@onready var buy_tree_menu: Control = $BuyTree
@onready var tree_button: Button = $BuyTree/PanelContainer/BoxContainer/HBoxContainer/Button

@onready var plot_color: Polygon2D = $Polygon2D

# Player
@onready var player: Player = $/root/main/Player

# Preload Tree Node
var tree = preload("res://tree.tscn")

var trees: Array[AppleTree]

# Plots Have An Attraction
#@onready var attraction: Attraction = $Attraction

# Has name through StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load up potential trees
	var tempTree: AppleTree = tree.instantiate()
	trees.append(tempTree)
	
	# Set Plot Color
	if(plot_color):
		plot_color.color = Color("eb3c2d")
	
	#starting trees
	if(built):
		var index = 0
		# Add tree to the plot
		trees[index].add_apple()
		add_child(trees[index])
		plot_color.visible = false

	# Attach some buttons
	var rect: ColorRect = $ColorRect
	if(rect):
		rect.clicked.connect(_clicked)

	if(button):
		button.pressed.connect(_buy_plot)
		
	if(tree_button):
		tree_button.pressed.connect(_buy_tree)
		
	# Setup ticks
	var timer = get_node("/root/main/Timer")
	timer.timeout.connect(_tick)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _tick():
	# update UI if we can afford the plot
	if(button):
		button.disabled = player.money < unlock_cost
	if(tree_button):
		tree_button.disabled = player.money < trees[0].cost

# Happens when the plot is purchased
func _buy_plot():
	if player.money >= unlock_cost:
		unlocked = true
		player.money -= unlock_cost
		buy_menu.visible = false
		plot_color.color = Color("3498db")

func _buy_tree():
	var index = 0
	if trees.size() > 0 && player.money >= trees[index].cost:
		built = true
		player.money -= trees[index].cost
		# Add tree to the plot
		add_child(trees[index])
		plot_color.visible = false
		
		buy_tree_menu.visible = false

# Happens when the plot is clicked
func _clicked():
	# if not unlocked prompt to buy it
	if !unlocked:
		buy_menu.visible = true
		buy_label.set_text("Plot Costs: " + String.num_int64(unlock_cost) + "$")
	elif !built:
		buy_tree_menu.visible = true
		buy_tree_label.set_text("Tree Costs: " + String.num_int64(trees[0].cost) + "$")
