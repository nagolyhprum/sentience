extends Node2D

var SIZE = 1500.0
var COLUMNS = 1
var ROWS = 1

@onready var asteroids = $Asteroids
var cooldown = 0
var previous_row = 0
var previous_column = 0

func _process(delta: float) -> void:
	queue_redraw()
	
func _draw() -> void:
	var offset = Constant.PLAYER_POSITION + Constant.HALF_PLAYER_SIZE - State.player_offset
	var bounds = Rect2(
		offset.x - SIZE / 2, 
		offset.y - SIZE / 2, 
		SIZE, 
		SIZE
	)
	draw_circle(
		offset,
		SIZE / 2,
		Color.YELLOW,
		false,
		1,
		true
	)
	draw_rect(
		bounds,
		Color.BLUE,
		false,
		1,
		true		
	)
	var now = Time.get_ticks_msec()
	if cooldown < now:
		cooldown = now + 1000
		var angle = 2 * PI * randf()
		var asteroid_index = randi() % len(Constant.ASTEROIDS)
		var asteroid_scene = Constant.ASTEROIDS[asteroid_index]
		var asteroid = asteroid_scene.instantiate()
		asteroids.add_child(asteroid)		
		var x = cos(angle) * SIZE / 2 - asteroid.size.x / 2 + offset.x
		var y = sin(angle) * SIZE / 2 - asteroid.size.y / 2 + offset.y
		asteroid.position.x = x
		asteroid.position.y = y
		var direction : Vector2 = bounds.get_center() - asteroid.position
		asteroid.velocity = direction.rotated(randf() * deg_to_rad(30)).limit_length(randf())
		asteroid.angular_velocity = PI * randf() - PI / 2
	for asteroid in asteroids.get_children():
		if not bounds.intersects(Rect2(asteroid.position, asteroid.size)):
			asteroid.queue_free()
