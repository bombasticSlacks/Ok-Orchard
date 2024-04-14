extends Control

@onready var label: Label = $Label
var current_opacity: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	const fade_speed = .8
	current_opacity -= fade_speed * delta
	# if we are invisible unload
	if current_opacity < 0:
		queue_free()
		
	label.modulate = Color(1,1,1, current_opacity)
