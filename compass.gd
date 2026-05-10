extends Control

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var radius = size.x / 2
	var center = Vector2(radius, radius)
	draw_circle(
		center, 
		radius, 
		Color.RED, 
		true, 
		-1, 
		true
	)
	var angle_percent : float = State.player_velocity_angle / Constant.MAX_ANGLE_VELOCITY
	draw_arc(
		center, 
		radius - 10, 
		-PI / 2, 
		-PI / 2 + PI / 2 * angle_percent, 
		32, 
		Color.BLUE, 
		radius / 20, 
		true
	)
	var length = State.player_velocity.length()
	var velocity_offset = State.player_velocity.limit_length((radius - 30) * length / Constant.MAX_VELOCITY)
	draw_circle(
		center - velocity_offset,
		radius / 10,
		Color.BLUE,
		true,
		-1,
		true
	)
	draw_circle(
		center + (State.player_offset - Constant.PLAYER_POSITION).normalized() * radius,
		radius / 10,
		Color.YELLOW,
		true,
		-1,
		true
	)

	
