extends Node2D
class_name Turret

onready var turretPivot = $Pivot
onready var orig_pivot_position = $Pivot.global_position
export var color = "blue"
export var piercing:int = 1

signal shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var angle = orig_pivot_position.angle_to_point(get_viewport().get_mouse_position())
	#print(orig_pivot_position)
	
	set_rotation_degrees(rad2deg(angle) - 180)
	translate(orig_pivot_position - turretPivot.global_position)

func shoot():
	emit_signal("shoot", self, get_viewport().get_mouse_position())
