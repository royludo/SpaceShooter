extends Node
class_name WeaponGroupManager

var weaponGroups:Dictionary = {}

func add_group(weapons:Array, action:String):
	var group = WeaponGroup.new(weapons, action)
	self.weaponGroups[action] = group

func get_group_with_action(action:String) -> WeaponGroup:
	return self.weaponGroups[action]
