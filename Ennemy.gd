extends Node2D

export(int) var speed
var movementEnabled:bool
var color

const blue_shader = preload("res://blue.shader")
const red_shader = preload("res://red.shader")
const ShieldSet = preload("res://ShieldSet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func hit_by(projectile_color):
	if projectile_color == self.color:
		queue_free()

func constructor(movementEnabled, speed, shieldsPresent, shieldsColors):
	self.movementEnabled = movementEnabled
	self.speed = speed
	
	if rand_range(0, 1.0) > 0.5:
		color = "blue"
		$Sprite.material.shader = blue_shader
	else:
		color = "red"
		$Sprite.material.shader = red_shader
	
	var shields = ShieldSet.instance()
	shields.constructor(shieldsPresent, shieldsColors)
	add_child(shields)

func _physics_process(delta):
	if movementEnabled:
		var velocity = Vector2.ZERO
		velocity.x = -speed * delta
	
		set_position(position + velocity)
