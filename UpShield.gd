extends AbstractShieldPart

const upBlueSprite:Texture = preload("res://assets/up_blue.png")
const upRedSprite:Texture = preload("res://assets/up_red.png")

func constructor(color):
	var sprite
	if color == "blue":
		sprite = upBlueSprite
	else:
		sprite = upRedSprite
	$Sprite.set_texture(sprite)
	self.color = color
