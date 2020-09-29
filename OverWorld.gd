extends Node2D

var isLeftMenuOn:bool = false
onready var leftMenuItem = preload("res://LeftMenuItem.tscn")

func _ready():
	
	# init left menu and connect to appropriate turret
	for t in get_tree().get_nodes_in_group("Turrets"):
		var turret = t as Turret
		var item = leftMenuItem.instance()
		var colorSwitch = item.get_node("MarginContainer/GridContainer/ColorSwitch")
		var group = item.get_node("MarginContainer/GridContainer/WeaponGroup")
		
		#init menu item to match state of the turret
		if turret.color == "blue":
			colorSwitch.pressed = false
		else:
			colorSwitch.pressed = true
		
		if turret.get_groups().find("fire1") != -1:
			group.pressed = false
		elif turret.get_groups().find("fire2") != -1:
			group.pressed = true
			
		# connect
		colorSwitch.connect("toggled", self, "_on_color_switch", [turret])
		group.connect("toggled", self, "_on_group_switch", [turret])
		
		$LeftMenu/VBoxContainer.add_child(item)


func _input(event):
	if event.is_action_pressed("menu"):
		if isLeftMenuOn:
			$AnimationPlayer.play_backwards("LeftMenuSlideIn")
			isLeftMenuOn = false
			$PauseOverlay.set_visible(false)
			get_tree().paused = false
		else:
			get_tree().paused = true
			$PauseOverlay.set_visible(true)
			$AnimationPlayer.play("LeftMenuSlideIn")
			isLeftMenuOn = true
			

func _on_color_switch(is_pressed:bool, turret:Turret):
	var color
	if is_pressed:
		color = "red"
	else:
		color = "blue"
	turret.color = color

func _on_group_switch(is_pressed:bool, turret:Turret):
	print("group switch " + str(is_pressed)+" "+str(turret))
	var group
	var previous_group
	if is_pressed:
		group = "fire2"
		previous_group = "fire1"
	else:
		group = "fire1"
		previous_group = "fire2"
		
	var previousWeaponGroup = $World.weaponGroupManager.get_group_with_action(previous_group)
	var weaponGroup = $World.weaponGroupManager.get_group_with_action(group)
	
	previousWeaponGroup.remove_weapon(turret)
	weaponGroup.add_weapon(turret)
	
