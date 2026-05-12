extends TextureRect

var velocity_x : float = 0.0
var velocity_y : float = 0.0

@onready var explosion = $AudioStreamPlayer

func _process(delta: float) -> void:
	position.x += velocity_x * delta
	position.y += velocity_y * delta

func _on_area_2d_area_entered(area: Area2D) -> void:
	explosion.play()
	
	area.get_parent().queue_free()
	
	hide()
	set_process(false)
	set_physics_process(false)
	
	await explosion.finished
	
	queue_free()
