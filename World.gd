extends Node2D


onready var canvas = $CanvasLayer
onready var LaserEffect = preload("res://laserEffect.tscn")
onready var Ennemy = preload("res://Ennemy.tscn")

var weaponGroupManager = WeaponGroupManager.new()

### debug variables ###
export(bool) var spawnEnnemies
export(bool) var ennemiesMove
export(bool) var customVisualDebug:bool

func _ready():
	#init ennemies with some behavior if they are present on start, for tests
	for child in get_children():
		if child.get_name().begins_with("Ennemy") and child is Node2D:
			child.constructor(ennemiesMove, 0, [true, true, true], \
			["blue", "blue", "blue"])
	
	# init weapon groups
	weaponGroupManager.add_group([$Turret1, $Turret2, $Turret3], "fire1")
	weaponGroupManager.add_group([$Turret4, $Turret5, $Turret6], "fire2")

func _input(event):
	if event.is_action_pressed("fire1"):
		weaponGroupManager.get_group_with_action("fire1").shoot()
	elif event.is_action_pressed("fire2"):
		weaponGroupManager.get_group_with_action("fire2").shoot()


func _on_Turret_shoot(turret:Turret, mouse_pos):
	#print("shoot " + str(turret)+" "+str(mouse_pos)+" "+turret.color)
	
	var origin = turret.get_node("Nozzle").get_global_position()
	var pivot_to_nozzle = origin - turret.global_position
	var target = get_viewport().get_mouse_position() + pivot_to_nozzle
	
	var effect = LaserEffect.instance()
	effect.constructor(turret.color)
	effect.get_node("Tween").connect("tween_completed", self, "laser_timer_out", [effect])
	
	var raycast:RayCast2D = turret.get_node("RayCast2D")
	if raycast.is_colliding():
		var ennemies_hit = get_all_colliders(raycast, turret.piercing)
		#print("colliders: "+str(ennemies_hit))
		
		# we may be hitting less ennemies than the piercing allows
		# in this case, laser should extend
		if ennemies_hit.size() < turret.piercing:
			# extend line to end out of screen
			effect.get_node("line").points = [origin, target_out_of_screen(origin, target)]
		else:
			effect.get_node("line").points = [origin, raycast.get_collision_point()]
		
		for ennemy in ennemies_hit:
			ennemy.hit_by(turret.color)
	else:
		# extend line to end out of screen
		effect.get_node("line").points = [origin, target_out_of_screen(origin, target)]
	
	canvas.add_child(effect)

func _draw():
	if customVisualDebug:
		var mouse_pos = get_viewport().get_mouse_position()
		var nozzle_to_pivot = $Turret.global_position - $Turret/Nozzle.global_position
		var adjusted_mouse_pos = mouse_pos + nozzle_to_pivot
		#draw_line(get_viewport().get_mouse_position(), adjusted_mouse_pos, Color.red)
		#var angle = $Turret.global_position.angle_to_point(adjusted_mouse_pos)
		var new_direction = $Turret.global_position.direction_to(adjusted_mouse_pos)
		new_direction *= $Turret.global_position.distance_to(adjusted_mouse_pos)
		
		var pivot_to_nozzle = $Turret/Nozzle.global_position - $Turret.global_position
		var pivot_to_mouse = mouse_pos - $Turret.global_position
	
		#draw_circle(get_viewport().get_mouse_position(), 3.0, Color.red)
		draw_line(mouse_pos, adjusted_mouse_pos, Color.red, 1.0)
		draw_circle(adjusted_mouse_pos, 2.0, Color.red)
		draw_line($Turret.global_position, $Turret.global_position + new_direction, Color.green, 2.0)
		draw_line($Turret.global_position, $Turret.global_position - new_direction, Color.blue, 2.0)
		draw_line($Turret.global_position, $Turret.global_position + pivot_to_nozzle, Color.yellow, 2.0)
		draw_line($Turret.global_position, $Turret.global_position + pivot_to_mouse, Color.orange, 2.0)

func _process(delta):
	update() # update debug drawings

# returns ordered array of all colliding ennemies
# ordered from closest to farthest
func get_all_colliders(raycast:RayCast2D, piercing:int):
	var result = []
	# trivial case
	if piercing == 1:
		# if colliding too fast (with both lasers), ennemy may be null
		if raycast.get_collider() != null:
				result.append(raycast.get_collider().get_node(".."))
	else:
		var level = piercing
		while level > 0:
			# if colliding too fast (with both lasers), ennemy may be null
			if raycast.get_collider() != null:
				var collider = raycast.get_collider()
				var ennemy = collider.get_node("..")
				result.append(ennemy)
				level -= 1
				
				if level > 0: # things we don't need on the last loop only
					raycast.add_exception(collider)
					raycast.force_raycast_update()
				
			else: #no more collision, we're done
				break
		raycast.clear_exceptions()
	
	return result

func target_out_of_screen(origin, old_target):
	var newtarget:Vector2 = old_target - origin
	var l = newtarget.length()
	newtarget = newtarget * (500/l)
	newtarget = origin + newtarget
	return newtarget


func laser_timer_out(object, key, effect):
	effect.queue_free()

func spawn_ennemy_at(y):
	var ennemy = Ennemy.instance()
	
	# randomize ennemy stats
	var speed = ennemy.speed * rand_range(0.5, 1.5)
	
	var shieldrand = floor(rand_range(0.0, 4.0))
	var colorrand = floor(rand_range(0.0, 2.0))
	var shieldsPresent = [false, false, false]
	var shieldsColors = ["blue", "blue", "blue"]
	
	if shieldrand == 1:
		shieldsPresent = [false, true, false]
		if colorrand == 0:
			shieldsColors = ["blue", "blue", "blue"]
		else:
			shieldsColors = ["blue", "red", "blue"]
	elif shieldrand == 2:
		shieldsPresent = [true, false, true]
		if colorrand == 0:
			shieldsColors = ["blue", "blue", "blue"]
		else:
			shieldsColors = ["red", "red", "red"]
	elif shieldrand == 3:
		shieldsPresent = [true, true, true]
		if colorrand == 0:
			shieldsColors = ["blue", "red", "blue"]
		else:
			shieldsColors = ["blue", "red", "blue"]
	
	
	ennemy.constructor(ennemiesMove, speed, shieldsPresent, shieldsColors)
	#print("spawn at: " + str(y))
	ennemy.set_position(Vector2(480, y))
	add_child(ennemy)

func _on_EnnemySpawnTimer_timeout():
	var ennemyCount = ceil(rand_range(1, 3))
	#print("spawn "+str(ennemyCount))
	for i in range(ennemyCount):
		if spawnEnnemies:
			spawn_ennemy_at(ceil(rand_range(5,245)))
