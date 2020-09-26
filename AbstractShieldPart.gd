extends Node2D
class_name AbstractShieldPart

var color
onready var destroyAnimatedSprite:AnimatedSprite = $AnimatedSprite
onready var sprite = $Sprite
onready var collisionShape = $Hurtbox/CollisionPolygon2D

func hit_by(projectile_color):
	if projectile_color == self.color:
		destroy()

func destroy():
	destroyAnimatedSprite.set_visible(true)
	destroyAnimatedSprite.play("ShieldDestroyed")


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_AnimatedSprite_frame_changed():
	if destroyAnimatedSprite.frame == 1:
		sprite.set_visible(false)
	elif destroyAnimatedSprite.frame == 2:
		collisionShape.disabled = true
