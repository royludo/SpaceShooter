extends AbstractShieldPart

const frontBlueSprite:Texture = preload("res://assets/front_blue.png")
const frontRedSprite:Texture = preload("res://assets/front_red.png")

func constructor(color):
	var sprite
	if color == "blue":
		sprite = frontBlueSprite
	else:
		sprite = frontRedSprite
	$Sprite.set_texture(sprite)
	self.color = color

