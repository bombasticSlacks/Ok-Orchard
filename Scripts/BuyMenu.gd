extends PanelContainer

@onready var buy_label: Label = $BoxContainer/Label
@onready var buy_button: Button = $BoxContainer/HBoxContainer/BuyButton
@onready var cancel_button: Button = $BoxContainer/HBoxContainer/CancelButton
@onready var player: Player = $/root/main/Player
@onready var timer: Timer = $/root/main/Timer

var current_selected_plot : Plot

func _connect_plots():
	var plots = get_tree().get_nodes_in_group("plots")
	for plot in plots:
		plot.sig_buy_menu.connect(show_buy_menu)

# Called when the node enters the scene tree for the first time.
func _ready():
	buy_button.pressed.connect(_buy)
	cancel_button.pressed.connect(_hide_buy_menu)
	timer.timeout.connect(_tick)
	#Tilemap Scenes aren't instantiated until after their parents
	call_deferred("_connect_plots")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func show_buy_menu(plot, mouse_position):
	current_selected_plot = plot
	self.position = mouse_position
	if current_selected_plot.unlocked and not current_selected_plot.built:
		buy_label.set_text("Tree Costs: $" + String.num_int64(current_selected_plot.trees[0].cost))
		buy_button.text = "Buy"
	elif current_selected_plot.unlocked and current_selected_plot.built:
		buy_label.set_text("Remove tree?")
		buy_button.text = "Delete"
	elif not current_selected_plot.unlocked:
		buy_label.set_text("Plot Costs: $" + String.num_int64(current_selected_plot.unlock_cost))
		buy_button.text = "Buy"

	self.visible = true

func _hide_buy_menu():
	current_selected_plot = null
	self.visible = false

func _buy():
	if current_selected_plot:
		if current_selected_plot.unlocked and not current_selected_plot.built:
			current_selected_plot.buy_tree()
		elif current_selected_plot.unlocked and current_selected_plot.built:
			current_selected_plot.remove_tree()
		elif not current_selected_plot.unlocked:
			current_selected_plot.buy_plot()
		_hide_buy_menu()

func _tick():
	# update UI if we can afford the plot
	if self.visible and current_selected_plot:
		if current_selected_plot.unlocked and not current_selected_plot.built:
			buy_button.disabled = player.money < current_selected_plot.trees[0].cost
		elif not current_selected_plot.unlocked:
			buy_button.disabled = player.money < current_selected_plot.unlock_cost
