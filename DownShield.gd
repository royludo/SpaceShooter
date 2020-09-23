extends Node2D

const downBlueSprite:Texture = preload("res://assets/down_blue.png")
const downRedSprite:Texture = preload("res://assets/down_red.png")

var color

func constructor(color):
	var sprite
	if color == "blue":
		sprite = downBlueSprite
	else:
		sprite = downRedSprite
	$Sprite.set_texture(sprite)
	self.color = color

func hit_by(projectile_color):
	if projectile_color == self.color:
		queue_free()
