extends Node2D

const upBlueSprite:Texture = preload("res://assets/up_blue.png")
const upRedSprite:Texture = preload("res://assets/up_red.png")

var color

func constructor(color):
	var sprite
	if color == "blue":
		sprite = upBlueSprite
	else:
		sprite = upRedSprite
	$Sprite.set_texture(sprite)
	self.color = color

func hit_by(projectile_color):
	if projectile_color == self.color:
		queue_free()
