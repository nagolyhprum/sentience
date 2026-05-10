extends Node2D

const DIRECTIONAL_SPEED : float = 50.0
const ANGULAR_SPEED : float = 5.0
const BULLET_SPEED : float = 250.0
const PARALLAX : float = 100_000.0
const PLANET_ROTATION : float = 0.1
const MAX_ANGLE_VELOCITY : float = PI
const MAX_VELOCITY : float = 250

var velocity = Vector2()
var velocity_angle : float = 0.0

var cooldown = 0

var player_offset = Vector2()
var angle : float = 0.0

const laser_scene = preload("res://laser.tscn")

@onready var thruster_audio = $ThrusterAudio
@onready var laser_audio = $LaserAudio

@onready var player = $Player
@onready var background = $Background
@onready var space = $Space
@onready var planet = $Space/Planet

func _process(delta: float) -> void:
	var acceleration_angle : float = 0.0
	if Input.is_action_pressed("left"):
		acceleration_angle += -ANGULAR_SPEED
	if Input.is_action_pressed("right"):
		acceleration_angle += ANGULAR_SPEED
	velocity_angle += acceleration_angle * delta
	velocity_angle = clamp(velocity_angle, -MAX_ANGLE_VELOCITY, MAX_ANGLE_VELOCITY)
	angle += velocity_angle * delta
	player.rotation = angle
	
	var acceleration_x : float = 0.0
	var acceleration_y : float = 0.0
	if Input.is_action_pressed("up"):
		acceleration_x += -DIRECTIONAL_SPEED * sin(angle)
		acceleration_y += DIRECTIONAL_SPEED * cos(angle)
	if Input.is_action_pressed("down"):
		acceleration_x += DIRECTIONAL_SPEED * sin(angle)
		acceleration_y += -DIRECTIONAL_SPEED * cos(angle)
	velocity.x += acceleration_x * delta
	player_offset.x += velocity.x * delta
	velocity.y += acceleration_y * delta
	player_offset.y += velocity.y * delta
	velocity = velocity.limit_length(MAX_VELOCITY)
	
	if acceleration_angle or acceleration_x or acceleration_y:
		if not thruster_audio.playing:
			thruster_audio.play()
	else:
		thruster_audio.stop()
	
	var current_ticks = Time.get_ticks_msec()
	
	if Input.is_action_pressed("shoot"):
		if current_ticks > cooldown:
			var laser = laser_scene.instantiate()
			space.add_child(laser)
			laser.velocity_x = velocity.x + BULLET_SPEED * sin(angle)
			laser.velocity_y = velocity.y - BULLET_SPEED * cos(angle)
			laser.position.x = -player_offset.x + player.position.x + player.size.x / 2 - laser.size.x / 2
			laser.position.y = -player_offset.y + player.position.y + player.size.y / 2 - laser.size.y / 2
			laser.rotation = angle
			cooldown = current_ticks + 1000
			laser_audio.play()
	
	background.material.set_shader_parameter("x", -player_offset.x / PARALLAX)
	background.material.set_shader_parameter("y", -player_offset.y / PARALLAX)
		
	space.position.x = player_offset.x
	space.position.y = player_offset.y
	
	queue_redraw()
	
func _draw():
	var radius = 100
	var center = Vector2(150,110)
	draw_circle(
		center, 
		100, 
		Color.RED, 
		true, 
		-1, 
		true
	)
	var angle_percent : float = velocity_angle / MAX_ANGLE_VELOCITY
	draw_arc(
		center, 
		radius - 10, 
		-PI / 2, 
		-PI / 2 + PI / 2 * angle_percent, 
		32, 
		Color.BLUE, 
		5, 
		true
	)
	var length = velocity.length()
	var velocity_offset = velocity.limit_length((radius - 30) * length / MAX_VELOCITY)
	draw_circle(
		center - velocity_offset,
		10,
		Color.BLUE,
		true,
		-1,
		true
	)
	draw_circle(
		center + (player_offset - player.position).normalized() * radius,
		5,
		Color.YELLOW,
		true,
		-1,
		true
	)

	
	
	
		
