extends TextureRect

var velocity_x : float = 0.0
var velocity_y : float = 0.0

func _process(delta: float) -> void:
	position.x += velocity_x * delta
	position.y += velocity_y * delta
