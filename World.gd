extends Node2D


onready var canvas = $CanvasLayer
onready var LaserEffect = preload("res://laserEffect.tscn")
onready var Ennemy = preload("res://Ennemy.tscn")

### debug variables ###
export(bool) var spawnEnnemies
export(bool) var ennemiesMove

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#line.points = [orig_pivot_position,  get_viewport().get_mouse_position()]
	
	pass

func _input(event):
	if event.is_action_pressed("fire1"):
		$Turret.shoot()
		$Turret2.shoot()
	elif event.is_action_pressed("fire2"):
		$Turret3.shoot()
		$Turret4.shoot()
		pass

func _on_Turret_shoot(turret:Turret, mouse_pos):
	#print("shoot " + str(turret)+" "+str(mouse_pos)+" "+turret.color)
	
	var origin = turret.get_node("Nozzle").get_global_position()
	var target = get_viewport().get_mouse_position()
	
	var effect = LaserEffect.instance()
	effect.constructor(turret.color)
	effect.get_node("Timer").connect("timeout", self, "laser_timer_out", [effect])
	
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
	newtarget = newtarget * (400/l)
	newtarget = origin + newtarget
	return newtarget


func laser_timer_out(effect):
	effect.queue_free()
	pass

func spawn_ennemy_at(y):
	var ennemy = Ennemy.instance()
	ennemy.constructor(ennemiesMove)
	#print("spawn at: " + str(y))
	ennemy.set_position(Vector2(320, y))
	add_child(ennemy)

func _on_EnnemySpawnTimer_timeout():
	var ennemyCount = ceil(rand_range(1, 4))
	#print("spawn "+str(ennemyCount))
	for i in range(ennemyCount):
		if spawnEnnemies:
			spawn_ennemy_at(ceil(rand_range(20,160)))
