extends Node2D

const laser_scene = preload("res://laser.tscn")

@onready var thruster_audio = $ThrusterAudio
@onready var laser_audio = $LaserAudio

@onready var player = $Player
@onready var background = $Background
@onready var space = $Space
@onready var planet = $Space/Planet

func _ready() -> void:
	player.position = Constant.PLAYER_POSITION
	player.size = 2 * Constant.HALF_PLAYER_SIZE

func _process(delta: float) -> void:
	var acceleration_angle : float = 0.0
	if Input.is_action_pressed("left"):
		acceleration_angle += -Constant.ANGULAR_SPEED
	if Input.is_action_pressed("right"):
		acceleration_angle += Constant.ANGULAR_SPEED
	State.player_velocity_angle += acceleration_angle * delta
	State.player_velocity_angle = clamp(State.player_velocity_angle, -Constant.MAX_ANGLE_VELOCITY, Constant.MAX_ANGLE_VELOCITY)
	State.player_angle += State.player_velocity_angle * delta
	player.rotation = State.player_angle
	
	var acceleration_x : float = 0.0
	var acceleration_y : float = 0.0
	if Input.is_action_pressed("up"):
		acceleration_x += -Constant.DIRECTIONAL_SPEED * sin(State.player_angle)
		acceleration_y += Constant.DIRECTIONAL_SPEED * cos(State.player_angle)
	if Input.is_action_pressed("down"):
		acceleration_x += Constant.DIRECTIONAL_SPEED * sin(State.player_angle)
		acceleration_y += -Constant.DIRECTIONAL_SPEED * cos(State.player_angle)
	State.player_velocity.x += acceleration_x * delta
	State.player_offset.x += State.player_velocity.x * delta
	State.player_velocity.y += acceleration_y * delta
	State.player_offset.y += State.player_velocity.y * delta
	State.player_velocity = State.player_velocity.limit_length(Constant.MAX_VELOCITY)
	
	if acceleration_angle or acceleration_x or acceleration_y:
		if not thruster_audio.playing:
			thruster_audio.play()
	else:
		thruster_audio.stop()
	
	var current_ticks = Time.get_ticks_msec()
	
	if Input.is_action_pressed("shoot"):
		if current_ticks > State.player_cooldown:
			var laser = laser_scene.instantiate()
			space.add_child(laser)
			laser.velocity_x = State.player_velocity.x + Constant.BULLET_SPEED * sin(State.player_angle)
			laser.velocity_y = State.player_velocity.y - Constant.BULLET_SPEED * cos(State.player_angle)
			laser.position.x = -State.player_offset.x + player.position.x + player.size.x / 2 - laser.size.x / 2
			laser.position.y = -State.player_offset.y + player.position.y + player.size.y / 2 - laser.size.y / 2
			laser.rotation = State.player_angle
			State.player_cooldown = current_ticks + 1000
			laser_audio.play()
	
	background.material.set_shader_parameter("x", -State.player_offset.x / Constant.PARALLAX)
	background.material.set_shader_parameter("y", -State.player_offset.y / Constant.PARALLAX)
		
	space.position.x = State.player_offset.x
	space.position.y = State.player_offset.y
	
	queue_redraw()
	
	
	
		
