extends Node
class_name WeaponGroup


var weapons:Array = []
var action:String = "fire1"

func _init(weapons, action):
	self.weapons = weapons
	self.action = action

func add_weapon(weapon:Turret):
	self.weapons.append(weapon)

func remove_weapon(weapon:Turret):
	self.weapons.erase(weapon)

func shoot():
	for weapon in weapons:
		weapon.shoot()
