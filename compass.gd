extends Control

const glow = Color(65.0 / 255.0, 255.0 / 255.0, 0, 0.5)
const green = Color(65.0 / 255.0, 255.0 / 255.0, 0, 1)

var points = []

func _quadratic_bezier(p0: Vector2, p1: Vector2, p2: Vector2, t: float):
	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)
	var r = q0.lerp(q1, t)
	return r
	
func draw_bezier(p0: Vector2, p1: Vector2, p2: Vector2):
	var curves = Curve2D.new()
	for i in range(32):
		curves.add_point(_quadratic_bezier(p0, p1, p2, i / 32.0))
	return curves.get_baked_points()
	

func _ready() -> void:
	points = []
	var top = Vector2(size.x / 2, 0)
	var left = Vector2(0, size.y / 2)
	var middle = Vector2(size.x / 2, size.y / 2)
	var right = Vector2(size.x, size.y / 2)
	var bottom = Vector2(size.x / 2, size.y)
	points.append(draw_bezier(top, left, bottom))
	points.append(draw_bezier(top, middle, bottom))
	points.append(draw_bezier(top, right, bottom))
	
	points.append(draw_bezier(left, top, right))
	points.append(draw_bezier(left, middle, right))
	points.append(draw_bezier(left, bottom, right))

func _process(delta: float) -> void:
	_ready()
	queue_redraw()

func _draw() -> void:
	var radius = size.x / 2
	var center = Vector2(radius, radius)
	draw_circle(
		center, 
		radius, 
		Color.BLACK, 
		true, 
		-1, 
		true
	)
	var angle_percent : float = State.player_velocity_angle / Constant.MAX_ANGLE_VELOCITY
	draw_arc(
		center, 
		radius - 30, 
		-PI / 2, 
		-PI / 2 + PI * angle_percent, 
		32, 
		green, 
		radius / 20, 
		true
	)
	var length = State.player_velocity.length()
	var velocity_offset = State.player_velocity.limit_length((radius - 40) * length / Constant.MAX_VELOCITY)
	draw_circle(
		center - velocity_offset,
		radius / 20,
		green,
		true,
		-1,
		true
	)
	draw_circle(
		center + (State.player_offset - Constant.PLAYER_POSITION - Constant.HALF_PLAYER_SIZE).normalized() * (radius - 20),
		radius / 20,
		green,
		true,
		-1,
		true
	)
	for point in points:
		draw_polyline(point, glow, 1, true)

	
