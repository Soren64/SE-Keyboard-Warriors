extends CanvasLayer

@onready var label = $Time
@onready var timer = $Timer

func _ready() -> void:
	timer.start()
	
func time_left_in_level():
	var time_left = timer.time_left
	var min = floor(time_left / 60)
	var sec = int(time_left) % 60
	return [min, sec]
	
func _process(delta: float) -> void:
	label.text = "%02d:%02d" % time_left_in_level()
