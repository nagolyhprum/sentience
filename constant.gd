extends Node

const SCREEN_WIDTH = 1152
const SCREEN_HEIGHT = 648
const PANEL_WIDTH = 250
const DIRECTIONAL_SPEED : float = 50.0
const ANGULAR_SPEED : float = 5.0
const BULLET_SPEED : float = 250.0
const PARALLAX : float = 100_000.0
const PLANET_ROTATION : float = 0.1
const MAX_ANGLE_VELOCITY : float = PI
const MAX_VELOCITY : float = 250
const HALF_PLAYER_SIZE = Vector2(99.0 / 2.0, 75.0 / 2.0)
const PLAYER_POSITION = Vector2(
	PANEL_WIDTH + (SCREEN_WIDTH - PANEL_WIDTH) / 2 - HALF_PLAYER_SIZE.x, 
	SCREEN_HEIGHT / 2 - HALF_PLAYER_SIZE.y
)
var ASTEROIDS = [
	preload("res://asteroids/asteroid.tscn"),
	preload("res://asteroids/asteroid2.tscn"),
	preload("res://asteroids/asteroid3.tscn"),
	preload("res://asteroids/asteroid4.tscn")
]
