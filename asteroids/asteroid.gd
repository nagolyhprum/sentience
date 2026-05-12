extends TextureRect

var velocity = Vector2()
var angular_velocity = 0

func _process(delta: float) -> void:
	rotation += delta * angular_velocity
	position += delta * velocity * 100
