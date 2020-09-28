extends Node2D

export(Color) var blueColor:Color
export(Color) var redColor:Color
export(float) var fadeTime:float

func _ready():
	$Tween.interpolate_property($line, "default_color:a", \
		0.8, 0.2, fadeTime, \
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($line, "width", \
		$line.width, 0.2, fadeTime, \
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.start()

func constructor(color):
	if color == "blue":
		$line.default_color = blueColor
	elif color == "red":
		$line.default_color = redColor

