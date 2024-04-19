# Tracker For Game And Simulation Stuff
class_name Game extends Node

# Player
@export var player: Player

# Generated Pawns For The Current Day
@export var pawns: Array[Pawn]
var timer
var dayColor
var clock
var daytime_ambience
var nighttime_ambience
var money_display

@onready var tile_map: TileMap = $TileMap

@onready var entrance_transform: Transform2D = pawns[0].transform

@onready var next_day: Control = $UI/Control
@onready var next_day_label: Label = $UI/Control/PanelContainer/BoxContainer/Label

@onready var day_display: RichTextLabel = $UI/DayDisplay

# Preload Pawn Setup
var pawn_setup = preload("res://pawnSetup.tscn")

# Plots the game tracks
@export var plots: Plot

var current_ticks: int = 0
var current_day: int = 1

#Timer 0.3
@export var day_ticks = 580
#16 hour days, 6:00am to 10pm
var start_sunrise_hour = 6
var end_sunrise_hour = 8
var start_sunset_hour = 18
var end_sunset_hour = 22
var max_day_color_alpha = 0.4
var min_db = -40

var plot_state = []

# Pause for nighttime
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get a timer so we can register ticks
	timer = get_node("Timer")
	dayColor = get_node("UI/DayLayer/DayColor")
	clock = get_node("UI/Clock")
	daytime_ambience = get_node("DaytimeAmbience")
	nighttime_ambience = get_node("NighttimeAmbience")
	money_display = get_node("UI/MoneyDisplay")
	player = get_node("Player")
	timer.timeout.connect(_tick)
	
	# Assign a button from UI
	var button: Button = $UI/Control/PanelContainer/BoxContainer/Button
	button.pressed.connect(_start_day)
	
	# Call start day once
	_start_day()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _conv_time(current_ticks, hour_pad):
	var ticks = current_ticks * 100;
	var hh = floor(ticks / 3600) + hour_pad
	var mm = floor((ticks % 3600) / 60)
	var ss = ticks % 60
	return [hh,mm,ss]

func _format_time(hour, minute):
	#round to the nearest ten for minutes
	return "%d:%02d" % [hour, floor(minute/10)*10]

func _set_day_color(current_hour, current_minute):
	if current_hour >= start_sunrise_hour and (current_hour * 60 + current_minute) <= end_sunrise_hour * 60:
		var sunrise_percent = float((current_hour*60 + current_minute) - (start_sunrise_hour*60)) / float(end_sunrise_hour*60 - start_sunrise_hour*60)
		dayColor.color.a = (1-sunrise_percent) * max_day_color_alpha
	elif current_hour >= start_sunset_hour and (current_hour * 60 + current_minute) <= end_sunset_hour * 60:
		var sunrise_percent = float((current_hour*60 +current_minute) - (start_sunset_hour*60)) / float(end_sunset_hour*60 - start_sunset_hour*60)
		dayColor.color.a = sunrise_percent * max_day_color_alpha

func _adjust_ambience(current_hour, current_minute):
	if current_hour >= start_sunrise_hour and (current_hour * 60 + current_minute) <= end_sunrise_hour * 60:
		var sunrise_percent = float((current_hour*60 + current_minute) - (start_sunrise_hour*60)) / float(end_sunrise_hour*60 - start_sunrise_hour*60)
		daytime_ambience.set_volume_db((1-sunrise_percent) * min_db)
		nighttime_ambience.set_volume_db((sunrise_percent) * min_db)
	elif current_hour >= start_sunset_hour and (current_hour * 60 + current_minute) <= end_sunset_hour * 60:
		var sunrise_percent = float((current_hour*60 +current_minute) - (start_sunset_hour*60)) / float(end_sunset_hour*60 - start_sunset_hour*60)
		nighttime_ambience.set_volume_db((1-sunrise_percent) * min_db)
		daytime_ambience.set_volume_db((sunrise_percent) * min_db)

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	# if paused no processing ticks
	if paused:
		return
	
	# Count Ticks
	current_ticks = current_ticks+1
	
	# Check If We Spawn More Pawns
	if pawns.size() < 10 && current_ticks < day_ticks && randf() > .95:
		var pawn = pawn_setup.instantiate()
		pawn.transform = entrance_transform
		tile_map.add_child(pawn)
		pawns.append(pawn)
	
	# Calculate Time Stuff
	var time = _conv_time(current_ticks, start_sunrise_hour)

	var current_hour = time[0]
	var current_minute = time[1]
	_set_day_color(current_hour, current_minute)
	_adjust_ambience(current_hour, current_minute)

	# Format Displays
	var formatted_time = _format_time(current_hour, current_minute)
	clock.set_text(formatted_time)
	money_display.set_text(String.num_int64(player.money) + "$")

	# Check If The Day Is Over
	if current_ticks >= day_ticks:
		_end_day()

# stuff that happens when the day starts
func _start_day():
	# Clear the pause after a day
	next_day.visible = false
	paused = false
	day_display.set_text("Day: " + String.num_int64(current_day))
	
	
	# Reset ticks timer
	current_ticks = 0
	
	# Clear any pawns still in the park
	for pawn in pawns:
		pawn.queue_free()
	pawns.clear()
	
	
# stuff that happens when the day ends
func _end_day():
	# Set Menu UI
	paused = true
	next_day_label.set_text("End Of Day: " + String.num_int64(current_day))
	current_day += 1
	next_day.visible = true

	# Set pawns in park to start leaving
	for pawn in pawns:
		pawn.set_leaving()

# removes a pawn from the current array
func unload_pawn(pawn: Pawn):
	pawns.erase(pawn)
	pawn.queue_free()

