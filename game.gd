extends Node2D

const DIRECTIONAL_SPEED : float = 50.0
const ANGULAR_SPEED : float = 5.0
const BULLET_SPEED : float = 250.0
const PARALLAX : float = 100_000.0
const PLANET_ROTATION : float = 0.1

var velocity_x : float = 0.0
var velocity_y : float = 0.0
var velocity_angle : float = 0.0

var cooldown = 0

var x : float = 0.0
var y : float = 0.0
var angle : float = 0.0

const laser_scene = preload("res://laser.tscn")

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
	velocity_x += acceleration_x * delta
	x += velocity_x * delta
	velocity_y += acceleration_y * delta
	y += velocity_y * delta
	
	var current_ticks = Time.get_ticks_msec()
	
	if Input.is_action_pressed("shoot"):
		if current_ticks > cooldown:
			var laser = laser_scene.instantiate()
			space.add_child(laser)
			laser.velocity_x = velocity_x + BULLET_SPEED * sin(angle)
			laser.velocity_y = velocity_y - BULLET_SPEED * cos(angle)
			laser.position.x = -x + player.position.x + player.size.x / 2 - laser.size.x / 2
			laser.position.y = -y + player.position.y + player.size.y / 2 - laser.size.y / 2
			laser.rotation = angle
			cooldown = current_ticks + 1000
	
	background.material.set_shader_parameter("x", -x / PARALLAX)
	background.material.set_shader_parameter("y", -y / PARALLAX)
		
	space.position.x = x
	space.position.y = y
	
	planet.rotation += delta * PLANET_ROTATION
	
	
	
		
