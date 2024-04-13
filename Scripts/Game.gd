# Tracker For Game And Simulation Stuff
class_name Game extends Node

# Player
@export var player: Player

# Generated Pawns For The Current Day
var pawns: Array
var timer
var dayColor
var clock

# Plots the game tracks
@export var plots: Plot

var current_ticks = 0
#Timer 0.3
@export var day_ticks = 580
#16 hour days, 6:00am to 10pm
var start_sunrise_hour = 6
var end_sunrise_hour = 8
var start_sunset_hour = 18
var end_sunset_hour = 22
var max_day_color_alpha = 0.4

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get a timer so we can register ticks
	timer = get_node("Timer")
	dayColor = get_node("UI/DayLayer/DayColor")
	clock = get_node("UI/Clock")
	timer.timeout.connect(_tick)

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
	if current_hour >= start_sunrise_hour and current_hour <= end_sunrise_hour:
		var sunrise_percent = float((current_hour*60 + current_minute) - (start_sunrise_hour*60)) / float(end_sunrise_hour*60 - start_sunrise_hour*60)
		dayColor.color.a = (1-sunrise_percent) * max_day_color_alpha
	elif current_hour >= start_sunset_hour and current_hour <= end_sunset_hour:
		var sunrise_percent = float((current_hour*60 +current_minute) - (start_sunset_hour*60)) / float(end_sunset_hour*60 - start_sunset_hour*60)
		dayColor.color.a = sunrise_percent * max_day_color_alpha

# Simplified Processing Only Runs When A Root Level Timer Finishes
func _tick():
	current_ticks = current_ticks+1
	var time = _conv_time(current_ticks, start_sunrise_hour)

	var current_hour = time[0]
	var current_minute = time[1]
	_set_day_color(current_hour, current_minute)

	var formatted_time = _format_time(current_hour, current_minute)
	clock.set_text(formatted_time)

	if current_ticks >= day_ticks:
		current_ticks = 0
