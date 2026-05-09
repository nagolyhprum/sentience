extends TextureRect

@export var diameter : float = 0 # in thousands of miles
@export var distance : float = 0 # in millions of miles
@export var days_per_orbit : float = 0 # in earth days
var random_offset = randf() * 100
	
func _process(delta: float) -> void:
	var offset : float = random_offset + Time.get_ticks_msec() / 100.0 / days_per_orbit
	var scale_offset = cos(offset) * distance / 25.0
	var half_size = size / 2
	var z = floor(distance / 30.0)
	if cos(offset) < 0:
		z_index = -z
	else:
		z_index = z
	scale.x = diameter / 10 + scale_offset 
	scale.y = diameter / 10 + scale_offset
	pivot_offset = half_size
	position.x = 865 / 2 - half_size.x + sin(offset) * distance * 1000.0
	position.y = 865 / 2 - half_size.y
