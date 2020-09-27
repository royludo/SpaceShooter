extends Node2D
class_name Turret

onready var turretPivot = $Pivot
onready var orig_pivot_position = $Pivot.global_position

export var color = "blue"
export var piercing:int = 1
export(float) var shotEffectTime: float

onready var blueShotEffect = $BlueShotEffect
onready var redShotEffect = $RedShotEffect
onready var shotEffectTween = $ShotEffectTween

signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var n = 0
func _process(delta):
	var nozzle_to_pivot = self.global_position - $Nozzle.global_position
	if get_name() == "Turret" and n == 30:
		print("nozzle to pivot" + str(nozzle_to_pivot))
	var adjusted_mouse_pos = get_viewport().get_mouse_position() + nozzle_to_pivot
	var angle = orig_pivot_position.angle_to_point(adjusted_mouse_pos)
	#print(orig_pivot_position)
	if get_name() == "Turret":
		if n == 60:
			print("dist: "+str(get_viewport().get_mouse_position().distance_to($Nozzle.global_position)))
			print(str(get_viewport().get_mouse_position()) +" "+ str(orig_pivot_position)+" "+str(adjusted_mouse_pos)+" " +str(nozzle_to_pivot)+" "+str(angle))
			n = 0
		else:
			n += 1
	
	#angle -= 0.35
	set_rotation(angle + PI)# + 3.1)#+ stepify(PI, 0.01) )# + PI)
	#translate(orig_pivot_position - turretPivot.global_position)
	

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
