class_name CloseButton extends Button

@export var control: Control

func _button_pressed():
	control.visible = false
	

# Called when the node enters the scene tree for the first time.
func _ready():
	self.pressed.connect(self._button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
