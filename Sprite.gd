extends Node2D
class_name Turret

export var color = "blue"
export var piercing:int = 1
export(float) var shotEffectTime: float

onready var turretPivot = $Pivot
onready var orig_pivot_position = $Pivot.global_position

onready var blueShotEffect = $BlueShotEffect
onready var redShotEffect = $RedShotEffect
onready var shotEffectTween = $ShotEffectTween

signal shoot

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	look_at(mouse_pos)

func shoot():
	emit_signal("shoot", self, get_viewport().get_mouse_position())
	
	var effect
	if self.color == "blue":
		effect = blueShotEffect
	else:
		effect = redShotEffect
		
	effect.set_visible(true)
	$ShotEffectTween.interpolate_property(effect, "modulate:a", \
	1, 0, shotEffectTime, \
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$ShotEffectTween.start()
