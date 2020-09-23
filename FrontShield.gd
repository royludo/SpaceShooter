extends Node2D

const frontBlueSprite:Texture = preload("res://assets/front_blue.png")
const frontRedSprite:Texture = preload("res://assets/front_red.png")

var color

func constructor(color):
	var sprite
	if color == "blue":
		sprite = frontBlueSprite
	else:
		sprite = frontRedSprite
	$Sprite.set_texture(sprite)
	self.color = color

func hit_by(projectile_color):
	if projectile_color == self.color:
		queue_free()
