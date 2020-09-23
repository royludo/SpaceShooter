extends Node2D

var hasShieldUp:bool
var hasShieldFront:bool
var hasShieldDown:bool
var colorUp:String
var colorFront:String
var colorDown:String

const UpShield = preload("res://UpShield.tscn")
const DownShield = preload("res://DownShield.tscn")
const FrontShield = preload("res://FrontShield.tscn")

# take array of 3 bool and array of 3 colors string
func constructor(hasAtPosition:Array, colors:Array):
	hasShieldUp = hasAtPosition[0]
	hasShieldFront = hasAtPosition[1]
	hasShieldDown = hasAtPosition[2]
	
	colorUp = colors[0]
	colorFront = colors[1]
	colorDown = colors[2]
	
	if hasShieldUp:
		var shieldUp = UpShield.instance()
		shieldUp.set_position($UpPos.get_position())
		shieldUp.constructor(colorUp)
		add_child(shieldUp)
		
	if hasShieldFront:
		var shieldFront = FrontShield.instance()
		shieldFront.set_position($FrontPos.get_position())
		shieldFront.constructor(colorFront)
		add_child(shieldFront)
	
	if hasShieldDown:
		var shieldDown = DownShield.instance()
		shieldDown.set_position($DownPos.get_position())
		shieldDown.constructor(colorDown)
		add_child(shieldDown)
