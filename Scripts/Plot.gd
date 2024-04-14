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
@onready var buy_tree_label: Label = $BuyPlot/PanelContainer/BoxContainer/Label
@onready var buy_tree_menu: Control = $BuyPlot
@onready var tree_button: Button = $BuyPlot/PanelContainer/BoxContainer/HBoxContainer/Button

# Player
@onready var player: Player = $/root/main/Player

# Plots Have An Attraction
#@onready var attraction: Attraction = $Attraction

# Has name through StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Attach some buttons
	var rect: ColorRect = $ColorRect
	if(rect):
		rect.clicked.connect(_clicked)

	if(button):
		button.pressed.connect(_buy)
		
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
		

# Happens when the plot is purchased
func _buy():
	if player.money >= unlock_cost:
		unlocked = true
		player.money -= unlock_cost
		buy_menu.visible = false

# Happens when the plot is clicked
func _clicked():
	# if not unlocked prompt to buy it
	if !unlocked:
		buy_menu.visible = true
		buy_label.set_text("Plot Costs: " + String.num_int64(unlock_cost) + "$")
