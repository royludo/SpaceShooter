extends AbstractShieldPart

const downBlueSprite:Texture = preload("res://assets/down_blue.png")
const downRedSprite:Texture = preload("res://assets/down_red.png")

func constructor(color):
	var sprite
	if color == "blue":
		sprite = downBlueSprite
	else:
		sprite = downRedSprite
	$Sprite.set_texture(sprite)
	self.color = color
